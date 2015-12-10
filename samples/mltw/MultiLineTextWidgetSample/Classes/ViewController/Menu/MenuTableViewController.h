//
//  MenuTableViewController.h
//  MultiLineTextWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLViewController;

@interface MenuTableViewController : UITableViewController

@property (nonatomic, strong) MLViewController           *viewController;
@property (nonatomic, strong) UIPopoverController        *parentPopopController;

- (void)closePopoverOrModal;

@end