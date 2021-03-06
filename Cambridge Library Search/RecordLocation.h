//
//  RecordLocation.h
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

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RecordLocation : NSObject<MKAnnotation>{
	NSString *title;
	NSString *subtitle;
	NSString *libraryName;
	CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property CLLocationCoordinate2D *libraryLocation;
@property (retain) NSString *libraryName;
@property (copy) NSString *title;
@property (copy) NSString *subtitle;
-(id)initWithTitle: (NSString *)n_title andSubTitle: (NSString *)n_subtitle andLibraryName:(NSString *) libName;
//-(NSString *) title;
//-(NSString *) subtitle;

+(NSArray *)getLibraryNames;
+(NSArray *)getLibraryLocations;


@end
