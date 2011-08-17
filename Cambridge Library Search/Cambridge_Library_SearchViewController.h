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

@interface Cambridge_Library_SearchViewController : UIViewController {

    IBOutlet UITextField *txt_searchTerm;
    IBOutlet UITextField *txt_cardBarcode;
    IBOutlet UITextField *txt_userSurname;
    
    NSMutableData *returnedData;
	SBJsonParser *parser;
	NSMutableArray *entries;
    
}

//Properties
@property (retain)NSMutableArray *entries;

//Methods
-(IBAction) search: (id)sender;

@end
