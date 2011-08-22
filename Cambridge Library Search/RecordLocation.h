//
//  RecordLocation.h
//  Cambridge Library Search
//
//  Created by James Snee on 22/08/2011.
//  Copyright (c) 2011 James Snee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RecordLocation : NSObject<MKAnnotation>{
	NSString *title;
	NSString *subtitle;
	NSString *libraryName;
	CLLocationCoordinate2D *libraryLocation;
}
@property CLLocationCoordinate2D coordinate;
@property CLLocationCoordinate2D *libraryLocation;
@property (retain) NSString *libraryName;
@property (copy) NSString *title;
@property (copy) NSString *subtitle;
-(id)initWithTitle: (NSString *)n_title andSubTitle: (NSString *)n_subtitle andLibraryName:(NSString *) libName;
-(NSString *) title;
-(NSString *) subtitle;


@end
