//
//  SearchOptionsView.m
//  Cambridge Library Search
//
//  Created by James Snee on 28/09/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import "SearchOptionsView.h"

@implementation SearchOptionsView
@synthesize searchTypes,searchOptions,db_cambridge,db_depfacaedb,db_depfacfmdb,db_depfacozdb,db_otherdb,db_manuscrpdb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchOptions:(SearchOptions *)searchOpts
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		searchOptions = searchOpts;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPickerView stuff
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [searchTypes count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [searchTypes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	searchOptions.searchType = [searchTypes objectAtIndex:row];
	[searchOptions setPickerRow:row];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Search Options";
	
	searchTypes = [[NSArray alloc] initWithObjects:@"General",
				   @"Title",
				   @"Author Name",
				   @"Subject",
				   @"ISBN",
				   @"Series",
				   @"Publisher:Date",
				   @"Publisher:Name",
				   @"ISSN",
				   @"Personal Name", nil];
	
	//Set the switches
	NSArray *dbSwitches = [[NSArray alloc]initWithObjects:db_cambridge,db_depfacaedb,db_depfacfmdb,db_depfacozdb,db_otherdb,db_manuscrpdb, nil];
	
	//Set the first switch for now
	UISwitch *topSwitch = [dbSwitches objectAtIndex:0];
	[topSwitch setOn:YES];
	
	//Select the correct row in the picker
	[searchTypePicker selectRow:[searchOptions getPickerRow] inComponent:0 animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
 * SWITCH TAG ASSIGNMENTS
 * 0 db_cambridge
 * 1 db_depfacaedb
 * 2 db_depfacfmdb
 * 3 db_depfacozdb
 * 4 db_otherdb
 * 5 db_manuscrpdb
 */
-(IBAction)dbSwitchChanged:(id)sender{
	UISwitch *sw = sender;
	if(sw.tag == 0){
		if (sw.isOn)
			[searchOptions addDb:@"db_cambridge"];
		else
			[searchOptions removeDb:@"db_cambridge"];
	}else if(sw.tag == 1){
		if (sw.isOn)
			[searchOptions addDb:@"db_depfacaedb"];
		else
			[searchOptions removeDb:@"db_depfacaedb"];
	}else if(sw.tag == 2){
		if (sw.isOn)
			[searchOptions addDb:@"db_depfacfmdb"];
		else
			[searchOptions removeDb:@"db_depfacfmdb"];
	}else if(sw.tag == 3){
		if (sw.isOn)
			[searchOptions addDb:@"db_depfacozdb"];
		else
			[searchOptions removeDb:@"db_depfacozdb"];
	}else if(sw.tag == 4){
		if (sw.isOn)
			[searchOptions addDb:@"db_otherdb"];
		else
			[searchOptions removeDb:@"db_otherdb"];
	}else if(sw.tag == 5){
		if (sw.isOn)
			[searchOptions addDb:@"db_manuscrpdb"];
		else
			[searchOptions removeDb:@"db_manuscrpdb"];
	}
}

@end
