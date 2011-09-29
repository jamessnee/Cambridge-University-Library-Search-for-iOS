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

int previousPageNum=0; //Horrid hack!
float progressIncrement=0;

#pragma mark - Setup
-(IBAction)search:(id)sender{
	
	//Progress Bar
	[progressBar setHidden:NO];
	progressBar.progress = 0;
	
	
	//Disable the search button to stop this being called multiple times
	[searchButton setEnabled:NO];
	
	//Hide the keyboard
	[txt_searchTerm resignFirstResponder];

	[self searchAquabrowserThinPage:1];
}

-(void)searchAquabrowserThinPage:(int)pageNum{
	NSLog(@"Search Term: %@",[txt_searchTerm text]);
	//Build up the request 
    NSString *searchTerm = [txt_searchTerm text];
    NSMutableString *url = [[NSMutableString alloc] init];
    NSString *searchArg = [NSString stringWithFormat:@"searchArg=%@&",searchTerm];
	
	//Search the correct databases
	NSMutableString *database = [NSMutableString stringWithString:@"branch="];
	NSArray *dbSelected = [searchOptions dbSelected];
	for(int i=0;i<[dbSelected count];i++){
		[database appendFormat:@"%@",[dbSelected objectAtIndex:i]];
		if(i+1!=[dbSelected count])
			[database appendString:@","];
	}
	[database appendString:@"&"];
	
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
	
	previousPageNum = pageNum;
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
	//NSLog(@"Got a response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[returnedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Couldn't connect to the Library. Do you have an Internet connection?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	//Tidy up
	[progressBar setHidden:YES];
	[searchButton setEnabled:YES];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
	
	NSString *responseString = [[NSString alloc]initWithData:returnedData encoding:NSUTF8StringEncoding];
	
	progressBar.progress = progressBar.progress+progressIncrement;
	[self parseAquabrowserData:responseString];

	if([entries count]==0){
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Results" message:@"There were no results found for your search" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		//Tidy up
		[searchButton setEnabled:YES];
		
		return;
	}
}

#pragma mark - JSON Parsing
-(void)parseAquabrowserData:(NSString *)responseString{
	//init entries array if this is the first time we've looked here
	if (entries == nil) {
		//NSLog(@"Creating new entries array");
		entries = [[NSMutableArray alloc] init];
	}

	//Parse the json
	NSError *jsonError = nil;
	NSDictionary *data = (NSDictionary *) [parser objectWithString:responseString error:&jsonError];
	NSDictionary *results = (NSDictionary *) [data objectForKey:@"search_results"];
	NSDictionary *bib_record = (NSDictionary *) [results objectForKey:@"bib_record"];
	
	//Deal with the simple record stuff first
	for (NSDictionary *record in bib_record){
		Entry *currEntry = [[Entry alloc]init];
		
		currEntry.title = [record objectForKey:@"title"];
		currEntry.bibId = [record objectForKey:@"bibId"];
		currEntry.coverImageURL = [record objectForKey:@"cover_image_url"];
		//NSLog(@"%@",[currEntry coverImageURL]);
		currEntry.database = [record objectForKey:@"database"];
		
		[entries addObject:currEntry];
		[currEntry release];
	}
	[responseString release];
	[parser release];

	//If there are still pages to search (in searchOptions) and we're not looping back on ourselves. Search again.
	NSDictionary *nextPage = [results objectForKey:@"next_page"];
	NSString *pageNumStr = (NSString *)[nextPage objectForKey:@"page"];
	NSInteger pageNum = [pageNumStr intValue];
	if(pageNum <= [[searchOptions numOfPages] intValue] && pageNum>previousPageNum)
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
	progressIncrement = 1/[[searchOptions numOfPages] floatValue];
}

-(void)viewDidAppear:(BOOL)animated{
	progressIncrement = 1/[[searchOptions numOfPages] floatValue];
	
	/* Need to get rid of the entries, so make sure it's gone then ensure it's nil */
	[entries dealloc];
	entries = nil;
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

- (void)switchView{
	[progressBar setHidden:YES];
	[searchButton setEnabled:YES];
	SearchResultsViewController *srvc = [[SearchResultsViewController alloc]initWithNibName:@"SearchResultsViewController" bundle:nil entries:entries];
	[self.navigationController pushViewController:srvc animated:YES];
}

-(IBAction)hideKeyboard:(id)sender{
	[sender resignFirstResponder];
}

-(IBAction)showSearchOptions:(id)sender{
	SearchOptionsView *searchOptionsView = [[SearchOptionsView alloc]initWithNibName:@"SearchOptionsView" bundle:nil searchOptions:searchOptions];
	[self.navigationController pushViewController:searchOptionsView animated:YES];
}

@end
