//
//  EntryView_Group.m
//  Cambridge Library Search
//
//  Created by James Snee on 19/08/2011.
//  Copyright (c) 2011 James Snee. All rights reserved.
//

#import "EntryView_Group.h"
#import "MapView.h"

@implementation EntryView_Group

@synthesize currEntry,recordTable;

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
        currEntry = [[NSArray alloc] initWithObjects:entry.title,entry.author,entry.edition,entry.isbn,entry.location_name,entry.location_code, nil];
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
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - UITableView controller stuff
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(section == 0)
		return 2;
	else
		return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section == 0)
		return @"Book Details:";
	else
		return @"Holding Details:";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSUInteger index;
	if(indexPath.section==0)
		index = (NSUInteger) indexPath.row;
	else
		index = (NSUInteger) indexPath.row + 2;
	if([[currEntry objectAtIndex:index] isEqual:@""]){
		[cell.textLabel setText:@"No Details"];
	}
	
	[cell.textLabel setNumberOfLines:4];
	[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	[cell.textLabel setText:[currEntry objectAtIndex:index]];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 1)
		if(indexPath.row == 2){
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			
			MapView *map = [[MapView alloc]initWithNibName:@"MapView" bundle:nil andLocation:@"UL"];
			[self.navigationController pushViewController:map animated:YES];
		}
}

@end
