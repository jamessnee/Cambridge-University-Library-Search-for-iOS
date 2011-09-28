//
//  SearchOptionsView.h
//  Cambridge Library Search
//
//  Created by James Snee on 28/09/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchOptions.h"

@class SearchOptions;
@interface SearchOptionsView : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>{
	IBOutlet UISwitch *db_cambridge;
	IBOutlet UISwitch *db_depfacaedb;
	IBOutlet UISwitch *db_depfacfmdb;
	IBOutlet UISwitch *db_depfacozdb;
	IBOutlet UISwitch *db_otherdb;
	IBOutlet UISwitch *db_manuscrpdb;
	
	IBOutlet UIPickerView *searchTypePicker;
	
	NSArray *searchTypes;
	
	SearchOptions *searchOptions;
}

@property (retain) NSArray *searchTypes;
@property (retain) SearchOptions *searchOptions;

@property (retain) IBOutlet UISwitch *db_cambridge;
@property (retain) IBOutlet UISwitch *db_depfacaedb;
@property (retain) IBOutlet UISwitch *db_depfacfmdb;
@property (retain) IBOutlet UISwitch *db_depfacozdb;
@property (retain) IBOutlet UISwitch *db_otherdb;
@property (retain) IBOutlet UISwitch *db_manuscrpdb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchOptions:(SearchOptions *)searchOpts;
-(IBAction)dbSwitchChanged:(id)sender;

@end
