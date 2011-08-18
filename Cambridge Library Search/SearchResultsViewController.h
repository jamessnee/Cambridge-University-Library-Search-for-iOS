//
//  SearchResultsViewController.h
//  Cambridge Library Search
//
//  Created by James Snee on 18/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
	
	NSArray *searchResults;

	IBOutlet UITableView *tblView;
}

@property (retain) NSArray *searchResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entries:(NSArray *)entries;

@end
