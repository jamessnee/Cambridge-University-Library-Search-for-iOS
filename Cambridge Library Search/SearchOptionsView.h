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
@interface SearchOptionsView : UIViewController{
	IBOutlet UISwitch *db_ulDep;
	IBOutlet UISwitch *db_depsFacs;
	IBOutlet UISwitch *db_collegeLibs;
	IBOutlet UISwitch *db_afilInst;
	IBOutlet UISwitch *db_eResource;
	
	IBOutlet UISlider *pagesNumSlider;
	IBOutlet UILabel *pagesNumLabel;
	
	NSArray *searchTypes;
	
	SearchOptions *searchOptions;
}

@property (retain) NSArray *searchTypes;
@property (retain) SearchOptions *searchOptions;

@property (retain) IBOutlet UISwitch *db_ulDep;
@property (retain) IBOutlet UISwitch *db_depsFacs;
@property (retain) IBOutlet UISwitch *db_collegeLibs;
@property (retain) IBOutlet UISwitch *db_afilInst;
@property (retain) IBOutlet UISwitch *db_eResource;

@property (retain) IBOutlet UISlider *pagesNumSlider;
@property (retain) IBOutlet UILabel *pagesNumLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchOptions:(SearchOptions *)searchOpts;
-(IBAction)dbSwitchChanged:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;

@end
