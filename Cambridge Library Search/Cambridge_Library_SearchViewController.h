//
//  Cambridge_Library_SearchViewController.h
//  Cambridge Library Search
//
//  Created by James Snee on 17/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@class SBJsonParser;
@class Entry;

@interface Cambridge_Library_SearchViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource> {

    IBOutlet UITextField *txt_searchTerm;
	IBOutlet UIPickerView *searchTypePicker;
	NSArray *searchTypes;
    
    NSMutableData *returnedData;
	SBJsonParser *parser;
	NSMutableArray *entries;
	
	IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

//Properties
@property (retain)NSMutableArray *entries;
@property (retain)NSArray *searchTypes;

//Methods
-(IBAction) search: (id)sender;
-(void)switchView;
-(IBAction)hideKeyboard: (id)sender;

@end
