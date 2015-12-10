//
//  ExportMenuTableViewController.h
//  MultiLineTextWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "MLViewController.h"
#import <UIKit/UIKit.h>


@interface ExportMenuTableViewController : UITableViewController

@property (nonatomic, strong) MLViewController    *viewController;
@property (nonatomic, strong) UIPopoverController *parentPopopController;

@end