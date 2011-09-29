//
//  SearchResultsViewController.m
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

#import "SearchResultsViewController.h"
#import "Entry.h"
#import "EntryView_Group.h"
#import "SBJson.h"

@implementation SearchResultsViewController

@synthesize searchResults, parser;

Entry * entry; //There must be a better way, but sice the connection is async it's difficult

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entries:(NSArray *)entries{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		searchResults = entries;
		NSLog(@"%d",[searchResults count]);
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
	[self setTitle:@"Search Results"];
	
	returnedData = [[NSMutableData data] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View Controller
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [searchResults count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}

	Entry *en = (Entry *) [searchResults objectAtIndex:indexPath.row];
	NSString *book_title = en.title;
	[cell.textLabel setNumberOfLines:3];
	[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	[[cell textLabel] setText:book_title];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	Entry *en = (Entry *) [searchResults objectAtIndex:indexPath.row];
	[self getFullEntry:en];
}

-(void)switchViewToEntry:(Entry *)en{
	EntryView_Group *entryView = [[EntryView_Group alloc]initWithNibName:@"EntryView_Group" bundle:nil entry:en];
	[self.navigationController pushViewController:entryView animated:YES];
}

#pragma mark - Connection Stuff
-(void)getFullEntry:(Entry *)en{
	//Build up url - http://www.lib.cam.ac.uk/api/voyager/bibData.cgi?bib_id=505678&database=depfacaedb
	NSMutableString *url = [[NSMutableString alloc]initWithString:@"http://www.lib.cam.ac.uk/api/voyager/bibData.cgi?"];
	[url appendFormat:@"bib_id=%@&",[en bibId]];
	[url appendFormat:@"database=%@&",[en database]];
	[url appendString:@"format=json"];
	
	//Start connection
	NSString* escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrl]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	//Setup the parser after the request (fake threading I guess)
	parser = [[SBJsonParser alloc]init];
	NSLog(@"URL %@",url);
	
	//Save the entry
	entry = en;
	
	[url release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[returnedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[returnedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Couldn't connect to the Library. Do you have an Internet connection?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
	
	NSString *responseString = [[NSString alloc]initWithData:returnedData encoding:NSUTF8StringEncoding];
	[self parseFullRecordData:responseString];
}

-(void)parseFullRecordData:(NSString *)responseString{
	//Parse the json
	NSError *jsonError = nil;
	NSDictionary *data = (NSDictionary *) [parser objectWithString:responseString error:&jsonError];
	NSDictionary *bib_record = (NSDictionary *) [data objectForKey:@"bib_record"];
	//NSLog(@"%@",[bib_record allKeys]);
	entry.author = [bib_record objectForKey:@"author"];
	entry.edition = [bib_record objectForKey:@"edition"];
	entry.isbn = [bib_record objectForKey:@"isbn"];
	entry.pubDate = [bib_record objectForKey:@"pubDate"];
	
	//Get the holding data
	@try {
		NSDictionary *holdings = [bib_record objectForKey:@"holdings"];
		NSDictionary *holding = [holdings objectForKey:@"holding"];
		[entry.libraryCodes addObject:[holdings objectForKey:@"libraryCode"]];
		[entry.normalisedCallNos addObject:[holding objectForKey:@"normalisedCallNo"]];
		[entry.locationCodes addObject:[holding objectForKey:@"locationCode"]];
		[entry.locationNames addObject:[holding objectForKey:@"locationName"]];
	}
	@catch (NSException *exception) {
		NSLog(@"Exception");
	}
	
	[self switchViewToEntry:entry];
}

@end