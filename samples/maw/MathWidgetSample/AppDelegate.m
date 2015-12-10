//
//  AppDelegate.m
//  MathWidgetSample
//
//  Copyright (c) 2013 MyScript. All rights reserved.
//

#import "AppDelegate.h"
#import "MyCertificate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    // Create the Math Widget View Controller
    _mathViewController = [[MAWMathViewController alloc] init];
    _mathViewController.delegate = self;
    
    // Configure equation recognition engine
    [self configure];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_mathViewController];
    
    // Add a clear button
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:_mathViewController
                                                                   action:@selector(clear)];
    
    _mathViewController.navigationItem.rightBarButtonItem = clearButton;
    _mathViewController.navigationItem.title = @"MathWidget Sample";
    
    self.window.rootViewController = navigationController;
    
    return YES;
}

- (void)configure
{
    // Recognition resources
    NSArray *resources   = @[@"math-ak.res", @"math-grm-maw.res"];
    
    // Certificate
    NSData  *certificate = [NSData dataWithBytes:myCertificate.bytes length:myCertificate.length];
    
    [_mathViewController configureWithResources:resources
                                    certificate:certificate];
}

#pragma mark - Math Widget Delegate - Configuration

- (void)mathViewControllerDidBeginConfiguration:(MAWMathViewController *)mathViewController
{
    NSLog(@"Equation configuration begin");
}

- (void)mathViewControllerDidEndConfiguration:(MAWMathViewController *)mathViewController
{
    NSLog(@"Equation configuration succeeded");
}

- (void)mathViewController:(MAWMathViewController *)mathViewController didFailConfigurationWithError:(NSError *)error
{
    NSLog(@"Equation configuration failed (%@)", [error localizedDescription]);
}

#pragma mark - Math Widget Delegate - Recognition

- (void)mathViewControllerDidBeginRecognition:(MAWMathViewController *)mathViewController
{
    NSLog(@"Equation recognition begin");
}

- (void)mathViewControllerDidEndRecognition:(MAWMathViewController *)mathViewController
{
    NSLog(@"Equation recognition end");
}

#pragma mark - Math Widget Delegate - Solving

- (void)mathViewController:(MAWMathViewController *)mathViewController didChangeUsingAngleUnit:(BOOL)used
{
    if (used)
    {
        NSLog(@"Angle unit is used");
    }
    else
    {
        NSLog(@"Angle unit is not used");
    }
}

#pragma mark - Math Widget Delegate - Gesture

- (void)mathViewController:(MAWMathViewController *)mathViewController didPerformEraseGesture:(BOOL)partial
{
    NSString *gestureState = partial ? @"partial" : @"complete";
    
    NSLog(@"Erase gesture handled by current equation (%@)", gestureState);
}

#pragma mark - Math Widget Delegate - Undo Redo

- (void)mathViewControllerDidChangeUndoRedoState:(MAWMathViewController *)mathViewController
{
    NSLog(@"Undo Redo state changed");
}

#pragma mark - Math Widget Delegate - Writing

- (void)mathViewControllerDidBeginWriting:(MAWMathViewController *)mathViewController
{
    NSLog(@"Start writing");
}

- (void)mathViewControllerDidEndWriting:(MAWMathViewController *)mathViewController
{
    NSLog(@"End writing");
}

#pragma - Math Widget Delegate - Recognition Timeout

- (void)mathViewControllerDidReachRecognitionTimeout:(MAWMathViewController *)mathViewController
{
    NSLog(@"Recognition timeout reached");
}


@end