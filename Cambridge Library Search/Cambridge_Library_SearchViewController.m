//
//  Cambridge_Library_SearchViewController.m
//  Cambridge Library Search
//
//  Created by James Snee on 17/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import "Cambridge_Library_SearchViewController.h"
#import <SBJson/SBJson.h>

@implementation Cambridge_Library_SearchViewController

@synthesize entries;

#pragma mark - Setup

-(IBAction)search:(id)sender{
    
    //Build up the request 
    NSString *searchTerm = [txt_searchTerm text];
    NSMutableString *url = [[NSMutableString alloc] init];
    NSString *searchArg = [NSString stringWithFormat:@"searchArg=%@&",searchTerm];
    NSString *database = (@"databases=cambrdgedb&");
    NSString *format = (@"format=json");
    [url appendString:@"http://www.lib.cam.ac.uk/api/voyager/newtonSearch.cgi?"];
    [url appendString:searchArg];
    [url appendString:database];
    [url appendString:format];
    NSLog(@"Searching for: %@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
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

#pragma mark - Data Connection and JSON parsing
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[returnedData setLength:0];
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
		[entries addObject:en];
		[en release];
	}
	[responseString release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    returnedData = [[NSMutableData data] retain];
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
