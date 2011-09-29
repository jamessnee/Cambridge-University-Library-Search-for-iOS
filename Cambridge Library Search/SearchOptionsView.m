//
//  SearchOptionsView.m
//  Cambridge Library Search
//
//  Created by James Snee on 28/09/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import "SearchOptionsView.h"

@implementation SearchOptionsView
@synthesize searchTypes,searchOptions,db_ulDep,db_depsFacs,db_collegeLibs,db_afilInst,db_eResource,pagesNumLabel,pagesNumSlider;

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
	//NSArray *dbSwitches = [[NSArray alloc]initWithObjects:db_ulDep,db_depsFacs,db_collegeLibs,db_afilInst,db_eResource,nil];
	
	//Set the first switch for now
	//UISwitch *topSwitch = [dbSwitches objectAtIndex:0];
	//[topSwitch setOn:YES];
	
	for(NSString *i in [searchOptions dbSelected])
		NSLog(@"SWITCHES: %@",i);
	
	//Set the switches
	for (int i=0; i<[[searchOptions dbSelected] count]; i++) {
		NSString *currDbName = [[searchOptions dbSelected]objectAtIndex:i];
		if([currDbName isEqualToString:@"db_ulDep"]){
		   [db_ulDep setOn:YES];
		}else if([currDbName isEqualToString:@"db_depsFacs"]){
		   [db_depsFacs setOn:YES];
		}else if([currDbName isEqualToString:@"db_collegeLibs"]){
		   [db_collegeLibs setOn:YES];
		}else if([currDbName isEqualToString:@"db_afilInst"]){
		   [db_afilInst setOn:YES];
		}else if([currDbName isEqualToString:@"db_eResource"]){
		   [db_eResource setOn:YES];
		}
	}
	
	//Show the correct number of pages selected
	[pagesNumSlider setValue:[[searchOptions numOfPages] floatValue]];
	NSString *pagesNum = [NSString stringWithFormat:@"%d",[[searchOptions numOfPages] intValue]];
	[pagesNumLabel setText:pagesNum];
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
	
	NSLog(@"SWITCH: %d",sw.tag);
	
	if(sw.tag == 0){
		if (sw.isOn)
			[searchOptions addDb:@"db_ulDep"];
		else
			[searchOptions removeDb:@"db_ulDep"];
	}else if(sw.tag == 1){
		if (sw.isOn)
			[searchOptions addDb:@"db_depsFacs"];
		else
			[searchOptions removeDb:@"db_depsFacs"];
	}else if(sw.tag == 2){
		if (sw.isOn)
			[searchOptions addDb:@"db_collegeLibs"];
		else
			[searchOptions removeDb:@"db_collegeLibs"];
	}else if(sw.tag == 3){
		if (sw.isOn)
			[searchOptions addDb:@"db_afilInst"];
		else
			[searchOptions removeDb:@"db_afilInst"];
	}else if(sw.tag == 4){
		if (sw.isOn)
			[searchOptions addDb:@"db_eResource"];
		else
			[searchOptions removeDb:@"db_eResource"];
	}
}

-(IBAction)sliderValueChanged:(id)sender{
	UISlider *slider = (UISlider *)sender;
	int discreteValue = slider.value;
    [slider setValue:(float)discreteValue];
	NSString *currValue = [NSString stringWithFormat:@"%d",discreteValue];
	[pagesNumLabel setText:currValue];
	
	NSNumber *numPages = [NSNumber numberWithInt:discreteValue];
	[searchOptions setNumOfPages:numPages];
}

@end
