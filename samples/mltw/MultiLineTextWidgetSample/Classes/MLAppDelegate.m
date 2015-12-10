//
//  MLAppDelegate.m
//  MultiLineTextWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "MLAppDelegate.h"
#import "UIColor+Customization.h"
#import "Fabric/Fabric.h"
#import "Crashlytics/Crashlytics.h"

@implementation MLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    [self applyInterfaceCustomization];

    return YES;
}

- (void)applyInterfaceCustomization
{
    NSString *currentVersion = [[UIDevice currentDevice] systemVersion];

    if ([currentVersion compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        // set color for ui components
        [[UISwitch appearance] setOnTintColor:[UIColor appTintColor]];
        [[UIProgressView appearance] setTintColor:[UIColor appTintColor]];
        [[UIButton appearance] setTintColor:[UIColor appTintColor]];
        [[UISlider appearance] setTintColor:[UIColor appTintColor]];
        
        // set color for nav bar
        [UINavigationBar appearance].barTintColor = [UIColor appTintColor];
        [UINavigationBar appearance].tintColor    = [UIColor whiteColor];
        
        // color navigation bar
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            // set title color for nav bar in popover (iPad)
            [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setTintColor:[UIColor blackColor]];
        else
            // set title color for nav bar for iPhone
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
        
        // set status bar to white
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

@end