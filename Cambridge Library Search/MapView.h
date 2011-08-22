//
//  MapView.h
//  Cambridge Library Search
//
//  Created by James Snee on 19/08/2011.
//  Copyright (c) 2011 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RecordLocation.h"

@interface MapView : UIViewController<MKMapViewDelegate>{
	MKMapView *mapView;
	NSString *locationToView;
	NSDictionary *libraryLocations;
	RecordLocation *recordLocation;
}

@property (retain) IBOutlet MKMapView *mapView;
@property (retain) NSString *locationToView;
@property (retain) NSDictionary *libraryLocations;
@property (retain) RecordLocation *recordLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRecordLocation:(RecordLocation *)n_recordLocation;

@end
