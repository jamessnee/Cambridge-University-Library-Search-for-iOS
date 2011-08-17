//
//  Cambridge_Library_SearchAppDelegate.h
//  Cambridge Library Search
//
//  Created by James Snee on 17/08/2011.
//  Copyright 2011 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cambridge_Library_SearchViewController;

@interface Cambridge_Library_SearchAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Cambridge_Library_SearchViewController *viewController;

@end
