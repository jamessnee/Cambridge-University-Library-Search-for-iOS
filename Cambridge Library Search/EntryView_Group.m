//
//  EntryView_Group.m
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

#import "EntryView_Group.h"
#import "MapView.h"
#import "RecordLocation.h"
#import <MapKit/MapKit.h>

@implementation EntryView_Group

@synthesize currEntry,recordTable, entry_full;

NSInteger currPosInArray = 0;

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
        currEntry = [[NSArray alloc] initWithObjects:entry.title,entry.author,entry.edition,entry.isbn,[entry.location_names objectAtIndex:0],[entry.location_codes objectAtIndex:0], nil];
		entry_full = entry;
		NSLog(@"Holding library names: %@",[entry_full.location_names description]);
		NSLog(@"Holding library codes: %@",[entry_full.location_codes description]);
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
	
	//Reset currPosInArray
	currPosInArray = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView controller stuff
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	NSInteger numOfSections = 2+[entry_full.location_names count];
	NSLog(@"Setting number of sections to %d",numOfSections);
	return numOfSections;
}

/*
 ===========
	Title
	Author
 ===========
 
 ===========
	Edition
 ===========
 
 ===========
   Lib Name
   Lib Code
 ====...====
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(section == 0)
		return 2;
	else if(section == 1)
		return 1;
	else
		return 2;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section == 0)
		return @"Book Details:";
	else if(section == 1)
		return @"Edition Details:";
	else
		return @"Holding Details";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	if(indexPath.section==0){
		if(indexPath.row==0)
			[cell.textLabel setText:entry_full.title];
		else if(indexPath.row == 1)
			[cell.textLabel setText:entry_full.author];
	}
	else if(indexPath.section==1)
		[cell.textLabel setText:entry_full.edition];
	else if(indexPath.section>=2){
		if(indexPath.row==0){
			[cell.textLabel setText:[entry_full.location_names objectAtIndex:currPosInArray]];
		}
		else if(indexPath.row==1){
			[cell.textLabel setText:[entry_full.location_codes objectAtIndex:currPosInArray]];
			currPosInArray++;
			NSLog(@"CURRENT POS IN ARRAY %d",currPosInArray);
		}
	}
	
	//Fix the cells label
	[cell.textLabel setNumberOfLines:4];
	[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	//[cell.textLabel setText:[currEntry objectAtIndex:index]];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if(indexPath.section >= 2)
		if(indexPath.row == 0){
			//RecordLocation *recordLocation = [[RecordLocation alloc]initWithTitle:[entry_full.location_names objectAtIndex:0] andSubTitle:entry_full.title andLibraryName:[entry_full.location_names objectAtIndex:0]];
			
			UITableViewCell *currCell = [tableView cellForRowAtIndexPath:indexPath];
			RecordLocation *recordLocation = [[RecordLocation alloc]initWithTitle:currCell.textLabel.text andSubTitle:entry_full.title andLibraryName:currCell.textLabel.text];
			
			MapView *map = [[MapView alloc]initWithNibName:@"MapView" bundle:nil andRecordLocation:recordLocation];
			[self.navigationController pushViewController:map animated:YES];
		}
}

@end
