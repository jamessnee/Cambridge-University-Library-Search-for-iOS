//
//  Cambridge_Library_SearchViewController.m
//  Cambridge Library Search
//
//  Created by James Snee on 17/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import "Cambridge_Library_SearchViewController.h"
#import <SBJson/SBJson.h>
#import "SearchResultsViewController.h"

@implementation Cambridge_Library_SearchViewController

@synthesize entries, searchTypes;

NSInteger selectedSearchType;

#pragma mark - Setup
-(IBAction)search:(id)sender{
	
	//Hide the keyboard
	[txt_searchTerm resignFirstResponder];
    
    //Build up the request 
    NSString *searchTerm = [txt_searchTerm text];
    NSMutableString *url = [[NSMutableString alloc] init];
    NSString *searchArg = [NSString stringWithFormat:@"searchArg=%@&",searchTerm];
    NSString *database = (@"databases=cambrdgedb&");
    NSString *format = (@"format=json");
	
	//Get the search type code
	NSMutableString *searchCode = [[NSMutableString alloc]initWithString:@"searchCode="];
	switch (selectedSearchType) {
		case 0:
			[searchCode appendString:@"GKEY&"];
			break;
		case 1:
			[searchCode appendString:@"TKEY&"];
			break;
		case 2:
			[searchCode appendString: @"NKey&"];
			break;
		case 3:
			[searchCode appendString:@"SKEY&"];
			break;
		case 4:
			[searchCode appendString:@"ISBN&"];
			break;
		case 5:
			[searchCode appendString:@"SERI&"];
			break;
		case 6:
			[searchCode appendString:@"260C&"];
			break;
		case 7:
			[searchCode appendString:@"260B&"];
			break;
		case 8:
			[searchCode appendString:@"ISSN&"];
			break;
		case 9:
			[searchCode appendString:@"100A&"];
			break;
		default:
			[searchCode appendString:@"GKEY&"];
			break;
	}
	
    [url appendString:@"http://www.lib.cam.ac.uk/api/voyager/newtonSearch.cgi?"];
    [url appendString:searchArg];
    [url appendString:database];
	[url appendFormat:searchCode];
    [url appendString:format];
	
    NSLog(@"Searching for: %@",url);
	NSString* escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrl]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	//Setup the parser after the request (fake threading I guess)
	parser = [[SBJsonParser alloc]init];
	
	
	[url release];
	//[con release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Data Connection and JSON parsing
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[returnedData setLength:0];
	NSLog(@"Got a response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[returnedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    NSLog(@"Fail");
    NSLog(@"%@",[error description]);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
	
	//Show the activity loading thingey
	
	
	NSString *responseString = [[NSString alloc]initWithData:returnedData encoding:NSUTF8StringEncoding];
	
	//init entries array
	entries = [[NSMutableArray alloc] init];
	
	//Parse the json
	NSError *jsonError = nil;
	NSDictionary *data = (NSDictionary *) [parser objectWithString:responseString error:&jsonError];
	NSDictionary *results = (NSDictionary *) [data objectForKey:@"search_results"];
	NSDictionary *bib_record = (NSDictionary *) [results objectForKey:@"bib_record"];
	for (NSDictionary *record in bib_record){
		Entry *en = [[Entry alloc]init];
		en.author = [record objectForKey:@"author"];
		en.title = [record objectForKey:@"title"];
		en.edition = [record objectForKey:@"edition"];
		en.isbn = [record objectForKey:@"normalisedIsbn"];
		
		//Now delve into the holding data -- this gets a bit strange and I'm going to figure out a
		//better way of doing things later
		NSDictionary *holdings = (NSDictionary *) [record objectForKey:@"holdings"];
		id holding_id  = (id) [holdings objectForKey:@"holding"];
		if([holding_id isKindOfClass:[NSDictionary class]]){
			NSDictionary *holding = (NSDictionary *) holding_id;
			en.location_name = [holding objectForKey:@"locationName"];
			en.location_code = [holding objectForKey:@"locationCode"];
		}else if ([holding_id isKindOfClass:[NSArray class]]){
			NSLog(@"THIS IS AN ARRAY PANIC!");
		}
		
		//Tidy up before the next itteration
		[entries addObject:en];
		[en release];
	}
	[responseString release];
	
	/* - DEBUG
	for(Entry *en in entries){
		NSLog(@"Title: %@",en.title);
		NSLog(@"Location Name: %@",en.location_name);
	}
	 */
	//Show the results
	[self switchView];
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
	selectedSearchType = row;
	NSLog(@"Converted into %d",selectedSearchType);
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    returnedData = [[NSMutableData data] retain];
	self.title = @"Search";
	
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
	
	selectedSearchType = 0;
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

- (void)switchView{
	SearchResultsViewController *srvc = [[SearchResultsViewController alloc]initWithNibName:@"SearchResultsViewController" bundle:nil entries:entries];
	[self.navigationController pushViewController:srvc animated:YES];
}

-(IBAction)hideKeyboard:(id)sender{
	[sender resignFirstResponder];
}


@end
