//
//  RecordLocation.m
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

#import "RecordLocation.h"

@implementation RecordLocation
@synthesize coordinate, title, subtitle, libraryLocation, libraryName;

-(id)initWithTitle:(NSString *)n_title andSubTitle:(NSString *)n_subtitle andLibraryName:(NSString *)libName{
	self = [super init];
	if(self){
		self.title = n_title;
		self.subtitle = n_subtitle;
		self.libraryName = libName;
		
		NSArray *libraries = [[NSArray alloc] initWithObjects:@"UL",@"Medical Library",@"Squire Law Library",@"Central Science Library",@"Betty & Gordon Moore", nil];
		NSArray *locations = [[NSArray alloc] initWithObjects:@"52.204917,0.107565",@"52.186404,0.137709",@"52.2029,0.110727",@"52.203695,0.119054",@"52.209552,0.100047", nil];
		
		//Do some string stuff to find the coordinates of the library
		for(int i=0;i<[libraries count];i++){
			NSRange textRange;
			textRange =[[libraryName lowercaseString] rangeOfString:[[libraries objectAtIndex:i] lowercaseString]];
			
			if(textRange.location != NSNotFound)
			{
				NSString *longLat = [locations objectAtIndex:i];
				NSArray *coords = [longLat componentsSeparatedByString:@","];
				float longd = [[coords objectAtIndex:1] floatValue];
				float lat = [[coords objectAtIndex:0] floatValue];
				coordinate.latitude = lat;
				coordinate.longitude = longd;
			}
		}
		[libraries release];
		[locations release];
	}
	return self;
}

-(NSString *)title{
	return title;
}

-(NSString *)subtitle{
	return subtitle;
}

@end
