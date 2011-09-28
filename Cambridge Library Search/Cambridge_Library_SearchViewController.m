//
//  Cambridge_Library_SearchViewController.m
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

#import "Cambridge_Library_SearchViewController.h"
#import "SBJson.h"
#import "SearchResultsViewController.h"
#import "SearchOptionsView.h"

@implementation Cambridge_Library_SearchViewController

@synthesize entries,searchButton,searchOptions;

#pragma mark - Setup
-(IBAction)search:(id)sender{
	
	//Activity indicator
	[activityIndicator setHidden:NO];
	[activityIndicator startAnimating];
	
	//Disable the search button to stop this being called multiple times
	[searchButton setEnabled:NO];
	
	//Hide the keyboard
	[txt_searchTerm resignFirstResponder];
	
	if([searchOptions.searchProvider isEqualToString:@"Newton"])
		[self searchNewton];
	else if([searchOptions.searchProvider isEqualToString:@"Aquabrowser"])
		[self searchAquabrowserThinPage:1];
}

-(void)searchNewton{
	//Build up the request 
    NSString *searchTerm = [txt_searchTerm text];
    NSMutableString *url = [[NSMutableString alloc] init];
    NSString *searchArg = [NSString stringWithFormat:@"searchArg=%@&",searchTerm];
	NSMutableString *database = [[NSMutableString alloc]init];
	[database appendString:@"databases="];
	for(int i=0;i<[[searchOptions dbSelected] count]; i++){
		[database appendString:[[searchOptions dbSelected]objectAtIndex:i]];
		if((i+1)!=[[searchOptions dbSelected]count])
			[database appendString:@","];
	}
	[database appendString:@"&"];
	
    NSString *format = @"format=json";
	
	//Get the search type code
	NSMutableString *searchCode = [[NSMutableString alloc]initWithString:@"searchCode="];
	switch ([searchOptions getPickerRow]) {
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
	[url appendString:searchCode];
    [url appendString:format];
	
    NSLog(@"Searching for: %@",url);
	NSString* escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrl]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	//Setup the parser after the request (fake threading I guess)
	parser = [[SBJsonParser alloc]init];
	
	[searchCode release];
	[url release];
	//[con release];
}

-(void)searchAquabrowserThinPage:(int)pageNum{
	//Build up the request 
    NSString *searchTerm = [txt_searchTerm text];
    NSMutableString *url = [[NSMutableString alloc] init];
    NSString *searchArg = [NSString stringWithFormat:@"searchArg=%@&",searchTerm];
	NSString *database = @"branch=UL & Dependents&";
	
	NSString *page = [NSString stringWithFormat:@"resultsPage=%d&",pageNum];
    NSString *format = @"format=json";
	
    [url appendString:@"http://www.lib.cam.ac.uk/api/aquabrowser/abSearchThin.cgi?"];
    [url appendString:searchArg];
    [url appendString:database];
	[url appendString:page];
    [url appendString:format];
	
    NSLog(@"Searching for: %@",url);
	NSString* escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrl]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	//Setup the parser after the request (fake threading I guess)
	parser = [[SBJsonParser alloc]init];
	
	[url release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Data Connection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[returnedData setLength:0];
	NSLog(@"Got a response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[returnedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Couldn't connect to the Library. Do you have an Internet connection?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	//Tidy up
	[activityIndicator stopAnimating];
	[searchButton setEnabled:YES];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
	
	NSString *responseString = [[NSString alloc]initWithData:returnedData encoding:NSUTF8StringEncoding];
	if([searchOptions.searchProvider isEqualToString:@"Newton"]){
		[self parseNewtonData:responseString];
	}else if([searchOptions.searchProvider isEqualToString:@"Aquabrowser"]){
		[self parseAquabrowserData:responseString];
	}

	if([entries count]==0){
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Results" message:@"There were no results found for your search" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		//Tidy up
		[activityIndicator stopAnimating];
		[searchButton setEnabled:YES];
		
		return;
	}
	
	if([searchOptions.searchProvider isEqualToString:@"Newton"]){
		//Show the results
		[self switchView];
	}
}

#pragma mark - JSON Parsing
-(void)parseNewtonData:(NSString *)responseString{
	//init entries array
	entries = [[NSMutableArray alloc] init];
	
	//Parse the json
	NSError *jsonError = nil;
	NSDictionary *data = (NSDictionary *) [parser objectWithString:responseString error:&jsonError];
	NSDictionary *results = (NSDictionary *) [data objectForKey:@"search_results"];
	NSDictionary *bib_record = (NSDictionary *) [results objectForKey:@"bib_record"];
	
	//Deal with the simple record stuff first
	for (NSDictionary *record in bib_record){
		Entry *en = [[Entry alloc]initWithEntryType:@"Newton"];
		en.author = [record objectForKey:@"author"];
		en.title = [record objectForKey:@"title"];
		en.edition = [record objectForKey:@"edition"];
		en.isbn = [record objectForKey:@"normalisedIsbn"];
		
		//Now delve into the holding data
		NSDictionary *holdings = (NSDictionary *) [record objectForKey:@"holdings"];
		//NSLog([holdings description]);
		id holding_id  = (id) [holdings objectForKey:@"holding"];
		
		//If there is a single holding deal with it
		if([holding_id isKindOfClass:[NSDictionary class]]){
			NSDictionary *holding = (NSDictionary *) holding_id;
			NSArray *location_namesLocal = [[NSArray alloc]initWithObjects:[holding objectForKey:@"locationName"], nil];
			NSArray *location_codesLocal = [[NSArray alloc]initWithObjects:[holding objectForKey:@"locationCode"], nil];
			en.location_names = location_namesLocal;
			en.location_codes = location_codesLocal;
			[location_namesLocal release];
			[location_codesLocal release];
		}
		//If there are multiple holdings deal with these
		else if ([holding_id isKindOfClass:[NSArray class]]){
			NSArray *holdings = (NSArray *)holding_id;
			NSMutableArray *location_namesLocal = [[NSMutableArray alloc]init];
			NSMutableArray *location_codesLocal = [[NSMutableArray alloc]init];
			for(NSDictionary *individual_holding in holdings){
				[location_namesLocal addObject:[individual_holding objectForKey:@"locationName"]];
				[location_codesLocal addObject:[individual_holding objectForKey:@"locationCode"]];
			}
			NSArray *fixedLocationNames = [[NSArray alloc]initWithArray:location_namesLocal];
			NSArray *fixedLocationCodes = [[NSArray alloc]initWithArray:location_codesLocal];
			en.location_names = fixedLocationNames;
			en.location_codes = fixedLocationCodes;
			
			[location_namesLocal release];
			[location_codesLocal release];
			[fixedLocationNames release];
			[fixedLocationCodes release];
		}
		
		//Tidy up before the next itteration
		[entries addObject:en];
		[en release];
	}
	[responseString release];
	[parser release];
}

-(void)parseAquabrowserData:(NSString *)responseString{
	//init entries array if this is the first time we've looked here
	if (entries == nil) {
		NSLog(@"Creating new entries array");
		entries = [[NSMutableArray alloc] init];
	}

	//Parse the json
	NSError *jsonError = nil;
	NSDictionary *data = (NSDictionary *) [parser objectWithString:responseString error:&jsonError];
	NSDictionary *results = (NSDictionary *) [data objectForKey:@"search_results"];
	NSDictionary *bib_record = (NSDictionary *) [results objectForKey:@"bib_record"];
	
	//Deal with the simple record stuff first
	for (NSDictionary *record in bib_record){
		Entry *currEntry = [[Entry alloc]initWithEntryType:@"Aquabrowser"];
		
		currEntry.title = [record objectForKey:@"title"];
		currEntry.extID = [record objectForKey:@"extID"];
		currEntry.coverImageURL = [record objectForKey:@"\"cover_image_url\""];
		
		[entries addObject:currEntry];
		[currEntry release];
	}
	[responseString release];
	[parser release];

	NSDictionary *nextPage = [results objectForKey:@"next_page"];
	NSString *pageNumStr = (NSString *)[nextPage objectForKey:@"page"];
	NSInteger pageNum = [pageNumStr intValue];
	if(pageNum <= 25)
		[self searchAquabrowserThinPage:pageNum];
	else
		[self switchView];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    returnedData = [[NSMutableData data] retain];
	self.title = @"Search";
	
	searchOptions = [[SearchOptions alloc]init];
}

-(void)viewDidAppear:(BOOL)animated{
	NSLog(@"Search Options: %@",searchOptions.searchType);
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
	[activityIndicator stopAnimating];
	[searchButton setEnabled:YES];
	SearchResultsViewController *srvc = [[SearchResultsViewController alloc]initWithNibName:@"SearchResultsViewController" bundle:nil entries:entries];
	[self.navigationController pushViewController:srvc animated:YES];
}

-(IBAction)hideKeyboard:(id)sender{
	[sender resignFirstResponder];
}

-(IBAction)showSearchOptions:(id)sender{
	//SearchOptionsView *searchOptionsView = [[SearchOptionsView alloc]initWithNibName:@"SearchOptionsView" bundle:nil];
	SearchOptionsView *searchOptionsView = [[SearchOptionsView alloc]initWithNibName:@"SearchOptionsView" bundle:nil searchOptions:searchOptions];
	[self.navigationController pushViewController:searchOptionsView animated:YES];
}

@end
