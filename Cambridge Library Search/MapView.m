//
//  MapView.m
//  Cambridge Library Search
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

#import "MapView.h"
#import <MapKit/MapKit.h>
#import "RecordLocation.h"
#import "IndoorLocationView.h"

@implementation MapView

@synthesize mapView, locationToView, libraryLocations, recordLocations;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRecordLocation:(RecordLocation *)n_recordLocation{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		recordLocations = [[NSArray alloc]initWithObjects:n_recordLocation, nil];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRecordLocations:(NSArray *)n_recordLocations{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.recordLocations = n_recordLocations;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setTitle:@"Holding Locations"];
	
    mapView.mapType = MKMapTypeStandard;
	
	CLLocationCoordinate2D coord = [[recordLocations objectAtIndex:0] coordinate];
	
	//If there are multiple entries, zoom the map out far enough to see 
	//all the pins -- this isn't the best way to do this, but it's quite simple
	if([recordLocations count]>1){
		MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
		MKCoordinateRegion region = {coord, span};
		[mapView setRegion:region];
	}
	else{
		MKCoordinateSpan span = {.latitudeDelta =  0.009, .longitudeDelta =  0.009};
		MKCoordinateRegion region = {coord, span};
		[mapView setRegion:region];
	}
	
	[mapView addAnnotations:recordLocations];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)switchViewWithLibraryName:(NSString *)libraryName{
	IndoorLocationView *indoorLocV = [[IndoorLocationView alloc]initWithLocaitonName:libraryName];
	[self.navigationController pushViewController:indoorLocV animated:YES];
}

#pragma mark - MapView Stuff
/*
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{

}
 */

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
	RecordLocation *rec = [view annotation];
	if([[rec title] rangeOfString:@"UL"].location!=NSNotFound){
		[self switchViewWithLibraryName:rec.libraryName];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *pinAnnotation = nil;
	static NSString *defaultPinID = @"myPin";
	pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
	if ( pinAnnotation == nil )
		pinAnnotation = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
	
	pinAnnotation.canShowCallout = YES;
	
	RecordLocation *rl = annotation;
	if([[rl title] rangeOfString:@"UL"].location!=NSNotFound){
		UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		pinAnnotation.rightCalloutAccessoryView = infoButton;
	}
	return pinAnnotation;
}

@end
