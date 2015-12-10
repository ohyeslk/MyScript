//
//  AppDelegate.h
//  MathWidgetSample
//
//  Copyright (c) 2013 MyScript. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AtkMaw/MAWMathWidget.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, MAWMathViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MAWMathViewController *mathViewController;

@end
