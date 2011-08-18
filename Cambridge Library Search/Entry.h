//
//  Entry.h
//  Cambridge Library Search
//
//  Created by James Snee on 17/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entry : NSObject{
	NSString *author;
	NSString *title;
	NSString *edition;
	NSString *isbn;
	NSString *location_name;
	NSString *location_code;
}

//Properties
@property (retain) NSString *author;
@property (retain) NSString *title;
@property (retain) NSString *edition;
@property (retain) NSString *isbn;
@property (retain) NSString *location_name;
@property (retain) NSString *location_code;

@end
