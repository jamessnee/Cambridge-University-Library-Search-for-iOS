//
//  MapView.m
//  Cambridge Library Search
//
//  Created by James Snee on 19/08/2011.
//  Copyright (c) 2011 James Snee. All rights reserved.
//

#import "MapView.h"
#import <MapKit/MapKit.h>

@implementation MapView

@synthesize mapView, locationToView, libraryLocations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(NSString *)location{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		locationToView = location;
		NSLog(@"LOCATION TO VIEW: %@",locationToView);
		//SETUP LOCATIONS - this should be moved to either a db or just static define statments
		NSArray *libraries = [[NSArray alloc] initWithObjects:@"UL",@"MedicalLibrary",@"SquireLawLibrary",@"CentralScienceLibrary",@"BettyGordonMooreLibrary", nil];
		NSArray *locations = [[NSArray alloc] initWithObjects:@"52.204917,0.107565",@"52.186404,0.137709",@"52.2029,0.110727",@"52.203695,0.119054",@"52.212622,0.102024", nil];
		libraryLocations = [[NSDictionary alloc] initWithObjects:locations forKeys:libraries];
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
    mapView.mapType = MKMapTypeStandard;
	
	NSString *longLat = [libraryLocations objectForKey:locationToView];
	NSArray *coords = [longLat componentsSeparatedByString:@","];
	NSLog(@"%@",longLat);
	
	float coord_long = [[coords objectAtIndex:1] floatValue];
	float coord_lat = [[coords objectAtIndex:0] floatValue];
	
	CLLocationCoordinate2D coord = {latitude: coord_lat, longitude: coord_long};
	MKCoordinateSpan span = {latitudeDelta: 0.009, longitudeDelta: 0.009};
	MKCoordinateRegion region = {coord, span};
	
	[mapView setRegion:region];
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


#pragma mark - MapView Stuff
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
	NSLog(@"MAP LOADING");
}

@end
