//
//  EntryView.m
//  Cambridge Library Search
//
//  Created by James Snee on 18/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import "EntryView.h"
#import "Entry.h"

@implementation EntryView

@synthesize currEntry, lbl_title, lbl_author, lbl_edition, lbl_ISBN, lbl_locationName, lbl_locationId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entry:(Entry *)entry{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		currEntry = entry;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:@"Record"];
	[lbl_title setText:[currEntry title]];
	[lbl_author setText:[currEntry author]];
	[lbl_edition setText:[currEntry edition]];
	[lbl_ISBN setText:[currEntry isbn]];
	[lbl_locationId setText:[currEntry location_code]];
	[lbl_locationName setText:[currEntry location_name]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
