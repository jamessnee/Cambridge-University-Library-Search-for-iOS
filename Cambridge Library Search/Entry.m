//
//  Entry.m
//  Cambridge Library Search
//
//  Created by James Snee on 17/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import "Entry.h"

@implementation Entry

@synthesize author, title, edition, isbn, location_name, location_id;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
