//
//  EntryView_Group.h
//  Cambridge Library Search
//
//  Created by James Snee on 19/08/2011.
//  Copyright (c) 2011 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@class Entry;

@interface EntryView_Group : UIViewController<UITableViewDelegate,UITableViewDataSource>{
	NSArray *currEntry;
	Entry *entry_full;
	IBOutlet UITableView *recordTable;
}

@property (retain) NSArray *currEntry;
@property (retain) Entry *entry_full;
@property (retain) IBOutlet UITableView *recordTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entry:(Entry *)entry;

@end
