//
//  SearchOptions.m
//  Cambridge Library Search
//
//  Created by James Snee on 28/09/2011.
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

#import "SearchOptions.h"

@implementation SearchOptions
@synthesize searchType, dbSelected,searchProvider;


- (id)init
{
    self = [super init];
	if(self){
		//Set the default search Type to General
		searchType = @"General";
		
		//Set the default db to be db_cambridge
		dbSelected = [[NSMutableArray alloc]init];
		[self addDb:@"cambrdgedb"];
		pickerRow = 0;
		
		//Set the default search provider
		//searchProvider = @"Newton";
		searchProvider = @"Aquabrowser";
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
