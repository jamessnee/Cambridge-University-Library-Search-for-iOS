//
//  IndoorLocationView.m
//  Cambridge Library Search
//
//  Created by James Snee on 07/10/2011.
//  Copyright 2011 James Snee. All rights reserved.
//
/*
 Copyright (c) 2011, James Snee 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 • Redistributions of source code must retain the above copyright notice, this 
 list of conditions and the following disclaimer.
 • Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IndoorLocationView.h"

@implementation IndoorLocationView
@synthesize locationName,responseString,returnedData;

-(id)initWithLocaitonName:(NSString *)locationN{
	self = [super init];
	if(self){
		locationName = locationN;
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Start the image gathering
	NSMutableString *url = [[NSMutableString alloc]init ];
	[url appendString:@"http://www.lib.cam.ac.uk/api/local/ul_floorplan.cgi?location_name="];
	[url appendFormat:@"%@",locationName];
	
	NSString *escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrl]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	NSLog(@"URL: %@",escapedUrl);
	returnedData = [[NSMutableData data]retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setupViewWithLocationSite:(NSString *)site{
	UIImage *floorPlan;
	UIImage *locationPlan;
	floorPlan = [self getFloorPlan];
	locationPlan = [self getPlanOverlayForLocation:site];
	
	floorPlan = [self rotateUIImage:floorPlan angle:90];
	locationPlan = [self rotateUIImage:locationPlan angle:90];
	
	CGRect frame = [[UIScreen mainScreen]bounds];
	UIImageView *floorPlanView = [[UIImageView alloc]initWithFrame:frame];
	[floorPlanView setImage:floorPlan];
	
	UIImageView *locationPlanView = [[UIImageView alloc]initWithFrame:frame];
	[locationPlanView setImage:locationPlan];
	
	[self.view addSubview:floorPlanView];
	[floorPlanView addSubview:locationPlanView];
}

-(UIImage *)getFloorPlan{
	NSString *url = [NSString stringWithString:@"http://www.lib.cam.ac.uk/floorplan2/plan_mobile.jpg"];
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	UIImage *image = [UIImage imageWithData:imageData];
	return image;
}

-(UIImage *)getPlanOverlayForLocation:(NSString *)loc{
	NSString *url = [NSString stringWithFormat:@"http://www.lib.cam.ac.uk/floorplan2/%@.png",loc];
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	UIImage *image = [UIImage imageWithData:imageData];
	return image;
}


#pragma mark - Connection stuff
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[returnedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[returnedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Couldn't connect to the Library. Do you have an Internet connection?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
	responseString = [[NSString alloc]initWithData:returnedData encoding:NSUTF8StringEncoding];
	NSString *location = [self parseLocationString:responseString];
	[self setupViewWithLocationSite:location];
}

-(NSString *)parseLocationString:(NSString *)locationStr{
	NSCharacterSet *chars = [NSCharacterSet symbolCharacterSet];
	NSArray *subStrs = [locationStr componentsSeparatedByCharactersInSet:chars];
	NSString *locationSite;
	for(NSString *i in subStrs){
		if ([i rangeOfString:@"floorplan"].location == NSNotFound) {
			if([i rangeOfString:@"location_site"].location == NSNotFound){
				if([i length]>0){
					locationSite = [NSString stringWithString:i];
					NSLog(@"looking at %@",i);
				}
			}
		}
	}
	return locationSite;
}

#pragma mark - Helper stuff
-(UIImage *)rotateUIImage:(const UIImage *)src angle:(float)angleDegrees{
    UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, src.size.width, src.size.height)];
    float angleRadians = angleDegrees * ((float)M_PI / 180.0f);
    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
	
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, angleRadians);
	
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
}

@end
