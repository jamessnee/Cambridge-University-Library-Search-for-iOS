//
//  Cambridge_Library_SearchViewController.h
//  Cambridge Library Search
/*
 Copyright (c) 2011, James Snee 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 • Redistributions of source code must retain the above copyright notice, this 
 list of conditions and the following disclaimer.
 • Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "SearchOptions.h"

@class SBJsonParser;
@class Entry;
@class SearchOptions;

@interface Cambridge_Library_SearchViewController : UIViewController{

    IBOutlet UITextField *txt_searchTerm;
	//IBOutlet UIPickerView *searchTypePicker;
	//NSArray *searchTypes;
    
    NSMutableData *returnedData;
	SBJsonParser *parser;
	NSMutableArray *entries;
	
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	IBOutlet UIButton *searchButton;
	
	SearchOptions *searchOptions;
}

//Properties
@property (retain)NSMutableArray *entries;
//@property (retain)NSArray *searchTypes;
@property (retain)IBOutlet UIButton *searchButton;
@property (retain)SearchOptions *searchOptions;

//Methods
-(IBAction)search: (id)sender;
-(void)searchNewton;
-(void)searchAquabrowserThin;
-(void)searchAquabrowserAllRecords;
-(void)switchView;
-(void)parseNewtonData:(NSString *)responseString;
-(IBAction)hideKeyboard: (id)sender;
-(IBAction)showSearchOptions:(id)sender;

@end
