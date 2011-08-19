//
//  MapView.h
//  Cambridge Library Search
//
//  Created by James Snee on 19/08/2011.
//  Copyright (c) 2011 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapView : UIViewController<MKMapViewDelegate>{
	MKMapView *mapView;
	NSString *locationToView;
	NSDictionary *libraryLocations;
}

@property (retain) IBOutlet MKMapView *mapView;
@property (retain) NSString *locationToView;
@property (retain) NSDictionary *libraryLocations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(NSString *)location;

@end
