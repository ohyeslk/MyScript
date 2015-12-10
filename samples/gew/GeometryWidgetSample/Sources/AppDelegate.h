//
//  AppDelegate.h
//  GeometryWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

/**
 *  Sample app demonstrating how to use the Geometry Widget.
 *  This sample shows how to:
 * - Integrate a `GWGeometryView`
 * - Configure it
 * - Perform basic customization (ink color...)
 * - Annotate selected geometry items
 * - Export the result as an image
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  View controller managing the Geometry View
 */
@property (strong, nonatomic) ViewController *viewController;

@end
