//
//  SettingsViewController.h
//  GeometryWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWGeometryView;

/**
 *  Basic settings menu.
 */
@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) GWGeometryView *geometryView;

@end