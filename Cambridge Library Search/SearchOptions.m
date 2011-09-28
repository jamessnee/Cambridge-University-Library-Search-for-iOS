//
//  SearchOptions.m
//  Cambridge Library Search
//
//  Created by James Snee on 28/09/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import "SearchOptions.h"

@implementation SearchOptions
@synthesize searchType, dbSelected;


- (id)init
{
    self = [super init];
	if(self){
		//Set the default search Type to General
		searchType = @"General";
		
		//Set the default db to be db_cambridge
		dbSelected = [[NSMutableArray alloc]init];
		[self addDb:@"cambridgedb"];
		pickerRow = 0;
	}
    return self;
}

-(void)addDb:(NSString *)dbName{
	[dbSelected addObject:dbName];
}

-(void)removeDb:(NSString *)dbName{
	NSLog(@"Count before: %d",[dbSelected count]);
	[dbSelected removeObject:dbName];
	NSLog(@"Count after: %d",[dbSelected count]);
}

-(NSInteger)getPickerRow{
	return pickerRow;
}
-(void)setPickerRow:(NSInteger)num{
	pickerRow = num;
}

@end
