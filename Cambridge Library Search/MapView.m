//
//  MapView.m
//  Cambridge Library Search
//
//  Created by James Snee on 19/08/2011.
//  Copyright (c) 2011 James Snee. All rights reserved.
//

#import "MapView.h"
#import <MapKit/MapKit.h>
#import "RecordLocation.h"

@implementation MapView

@synthesize mapView, locationToView, libraryLocations, recordLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRecordLocation:(RecordLocation *)n_recordLocation{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.recordLocation = n_recordLocation;
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
	
	
	//OK OK This is horrid yes but I'm pressed for time
	CLLocationCoordinate2D coord = recordLocation.coordinate;
	
	MKCoordinateSpan span = {latitudeDelta: 0.009, longitudeDelta: 0.009};
	MKCoordinateRegion region = {coord, span};
	
	[mapView setRegion:region];
	
	[mapView addAnnotation:recordLocation];
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
