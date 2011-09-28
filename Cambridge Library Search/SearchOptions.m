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
    return self;
}

-(void)addDb:(NSString *)dbName{
	[dbSelected addObject:dbName];
}

@end
