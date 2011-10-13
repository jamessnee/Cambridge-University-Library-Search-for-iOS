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

@synthesize currEntry, entry_full,titleLbl,authorLbl,editionLbl,pubDateLbl,coverImage;

NSInteger currPosInArray = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entry:(Entry *)entry{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		entry_full = entry;
	}
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setTitle:@"Record"];
	
	[titleLbl setText:[entry_full title]];
	[authorLbl setText:[entry_full author]];
	[editionLbl setText:[entry_full edition]];
	[pubDateLbl setText:[entry_full pubDate]];
	
	NSLog(@"Image at %@",[entry_full coverImageURL]);
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[entry_full coverImageURL]]];
	UIImage *image = [UIImage imageWithData:imageData];
	[coverImage setImage:image];
}

- (void)viewDidAppear:(BOOL)animated{
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

-(void)switchViewWithRecordLocation:(RecordLocation *)recordLocation{
	MapView *mapView = [[MapView alloc]initWithNibName:@"MapView" bundle:nil andRecordLocation:recordLocation];
	[self.navigationController pushViewController:mapView animated:YES];
}

#pragma mark - UITableView stuff
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[entry_full locationNames] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//Get the name of the library
	NSMutableString *currLibName = [NSMutableString stringWithString:[[entry_full locationNames]objectAtIndex:[indexPath row]]];
	[currLibName appendString:@"\n"];
	[currLibName appendString:[[entry_full normalisedCallNos] objectAtIndex:[indexPath row]]];
	
	UITableViewCell *currCell = [[UITableViewCell alloc]init];
	[[currCell textLabel] setText:currLibName];
	[[currCell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
	[[currCell textLabel] setNumberOfLines:0];
	[currCell setFont:[UIFont fontWithName:@"Helvetica" size:(14.0)]];
	
	NSLog(@"Setting cell with name %@",currLibName);
	
	return currCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//Detect the library selected - at the moment do this with a string search
	//Must get the library codes from the guys at the library and put it all in a dictionary.
	NSString *selectedLibraryName = [[entry_full locationNames]objectAtIndex:[indexPath row]];
	NSString *selectedCallNumber = [[entry_full callNos]objectAtIndex:[indexPath row]];
	
	//Create a recordLocation object for it
	RecordLocation *recordLocation = [[RecordLocation alloc]initWithTitle:selectedLibraryName andSubTitle:selectedCallNumber andLibraryName:selectedLibraryName];
	
	//Deselect the cell
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//Switch to the map view
	[self switchViewWithRecordLocation:recordLocation];
}

@end
