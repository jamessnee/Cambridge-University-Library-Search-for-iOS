//
//  EntryView.h
//  Cambridge Library Search
//
//  Created by James Snee on 18/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Entry.h"

@class Entry;

@interface EntryView : UIViewController{
	Entry *currEntry; 
}

@property (retain) Entry *currEntry;
@property (retain) UILabel *lbl_title;
@property (retain) UILabel *lbl_author;
@property (retain) UILabel *lbl_edition;
@property (retain) UILabel *lbl_ISBN;
@property (retain) UILabel *lbl_locationName;
@property (retain) UILabel *lbl_locationId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entry:(Entry *)entry;

@end
