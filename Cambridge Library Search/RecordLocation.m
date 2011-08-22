//
//  RecordLocation.m
//  Cambridge Library Search
//
//  Created by James Snee on 22/08/2011.
//  Copyright (c) 2011 James Snee. All rights reserved.
//

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
