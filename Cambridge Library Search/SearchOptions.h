//
//  SearchOptions.h
//  Cambridge Library Search
//
//  Created by James Snee on 28/09/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchOptions : NSObject{
	NSString *searchType;
	NSMutableArray *dbSelected;
	NSInteger pickerRow; // for convenience
}

@property (retain) NSString *searchType;
@property (retain) NSMutableArray *dbSelected;

-(void)addDb:(NSString *)dbName;
-(void)removeDb:(NSString *)dbName;

-(NSInteger)getPickerRow;
-(void)setPickerRow:(NSInteger)num;

@end
