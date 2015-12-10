//
//  ViewController.m
//  GeometryWidgetTest
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "AnnotationViewController.h"
#import "Customization.h"
#import "MyCertificate.h"
#import "SettingsViewController.h"
#import "ViewController.h"

@interface ViewController ()

// Buttons
@property (strong, nonatomic) UIBarButtonItem *configureButton;
@property (strong, nonatomic) UIBarButtonItem *undoButton;
@property (strong, nonatomic) UIBarButtonItem *redoButton;
@property (strong, nonatomic) UIBarButtonItem *clearButton;
@property (strong, nonatomic) UIBarButtonItem *exportButton;

// Popovers
@property (strong, nonatomic) UIPopoverController *configurePopoverController;
@property (strong, nonatomic) UIPopoverController *exportPopoverController;
@property (strong, nonatomic) UIPopoverController *inputBoxPopoverController;

// Annotation
@property (strong, nonatomic) AnnotationViewController *annotationViewController;

@end

@implementation ViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Create the Geometry Widget View
        _geometryView = [[GWGeometryView alloc] init];
        
        // Register self as delegate
        _geometryView.delegate = self;
        
        // Configure geometry component recognition engine
        [self configureGeometryWidget];
        
        // Customize the ink color
        _geometryView.inkColor = [UIColor appTintColor];
        
        // Example of constraint configuration: enable display of explicit concentric constraint
        [_geometryView setConstraintsEnabled:YES
                                 constraints:GWConstraintConcentric
                                 forBehavior:GWConstraintBehaviorExplicitDisplay];
        
        // Create a controller that manages annotation when an item is selected
        _annotationViewController              = [[AnnotationViewController alloc] init];
        _annotationViewController.geometryView = self.geometryView;
        
        _inputBoxPopoverController                    = [[UIPopoverController alloc] initWithContentViewController:_annotationViewController];
        _inputBoxPopoverController.popoverContentSize = CGSizeMake(275, 140);
        _inputBoxPopoverController.delegate           = _annotationViewController;
    }
    
    return self;
}

- (void)loadView
{
    // Use the Geometry View as our controller view
    self.view = _geometryView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent         = NO;
    self.navigationController.navigationBar.barTintColor        = [UIColor appTintColor];
    self.navigationController.navigationBar.tintColor           = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]};
    
    self.navigationItem.title = @"MyScript Geometry Widget";
    
    [self configureButtons];
}

- (void)configureButtons
{
    _configureButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconSettings.png"]
                                                        style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(presentConfigureMenu:)];
    
    _undoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconUndo.png"]
                                                   style:UIBarButtonItemStyleBordered
                                                  target:_geometryView
                                                  action:@selector(undo)];
    
    _redoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconRedo.png"]
                                                   style:UIBarButtonItemStyleBordered
                                                  target:_geometryView
                                                  action:@selector(redo)];
    
    _clearButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconTrash.png"]
                                                    style:UIBarButtonItemStyleBordered
                                                   target:_geometryView
                                                   action:@selector(clear)];
    
    _exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                  target:self
                                                                  action:@selector(presentExportMenu:)];
    
    _undoButton.enabled = NO;
    _redoButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItems  = @[_undoButton, _redoButton, _clearButton];
    self.navigationItem.rightBarButtonItems = @[_exportButton, _configureButton];
}

#pragma mark - Widgets configuration

- (void)configureGeometryWidget
{
    NSArray *geometryResources = @[@"shk-standard.res"];
    
    NSData *certificate = [NSData dataWithBytes:myCertificate.bytes length:myCertificate.length];
    
    [_geometryView configureWithResources:geometryResources certificate:certificate];
}

#pragma mark - Geometry Widget Delegate - Configuration

- (void)geometryViewDidBeginConfiguration:(GWGeometryView *)geometryView
{
    NSLog(@"Geometry component configuration begin");
}

- (void)geometryViewDidEndConfiguration:(GWGeometryView *)geometryView
{
    NSLog(@"Geometry component configuration loaded successfully");
}

- (void)geometryView:(GWGeometryView *)geometryView didFailConfigurationWithError:(NSError *)error
{
    NSLog(@"Geometry component configuration error (%@)", [error localizedDescription]);
}

#pragma mark - Geometry Widget Delegate - Undo Redo

- (void)geometryViewDidChangeUndoRedoState:(GWGeometryView *)geometryView
{
    NSLog(@"Undo Redo state changed");
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.undoButton.enabled = [geometryView canUndo];
        self.redoButton.enabled = [geometryView canRedo];
    }];
}

#pragma mark - Geometry Widget Delegate - Gesture

- (void)geometryView:(GWGeometryView *)geometryView didPerformEraseGesture:(BOOL)partial
{
    NSString *gestureState = partial ? @"partial" : @"complete";
    
    NSLog(@"Erase gesture handled by current Geometry component (%@)", gestureState);
}

#pragma mark - Geometry Widget Delegate - Recognition

- (void)geometryViewDidBeginRecognition:(GWGeometryView *)geometryView
{
    NSLog(@"Geometry component recognition begin");
}

- (void)geometryViewDidEndRecognition:(GWGeometryView *)geometryView
{
    NSLog(@"Geometry component recognition end");
}

- (void)geometryViewDidUpdateItems:(GWGeometryView *)geometryView
{
    NSLog(@"Geometry component items update");
}

#pragma mark - Geometry Widget Delegate - Writing

- (void)geometryViewDidBeginWriting:(GWGeometryView *)geometryView
{
    NSLog(@"Start writing");
}

- (void)geometryViewDidEndWriting:(GWGeometryView *)geometryView
{
    NSLog(@"End writing");
}

#pragma - Geometry Widget Delegate - Recognition Timeout

- (void)geometryViewDidReachRecognitionTimeout:(GWGeometryView *)geometryView
{
    NSLog(@"Recognition timeout reached");
}

#pragma mark - Geometry Widget Delegate - Selection

- (void)geometryView:(GWGeometryView *)geometryView didSelectItem:(int64_t)item ofType:(GWItemType)type displayPoint:(CGPoint)point
{
    // Configure Input Box
    _annotationViewController.itemType = type;
    _annotationViewController.itemID   = item;
    
    // Basic popover positioning
    CGRect  boundingBox       = [_geometryView boundingBoxForItem:item];
    CGPoint boundingBoxCenter = CGPointMake(CGRectGetMidX(boundingBox), CGRectGetMidY(boundingBox));
    CGPoint center            = self.view.center;
    
    CGFloat offsetValue = 3;
    CGPoint offset;
    
    UIPopoverArrowDirection direction = UIPopoverArrowDirectionAny;
    
    if (boundingBox.size.height > boundingBox.size.width)
    {
        direction = (boundingBoxCenter.x < center.x) ? UIPopoverArrowDirectionLeft : UIPopoverArrowDirectionRight;
        offset    = (boundingBoxCenter.x < center.x) ? CGPointMake(offsetValue, 0) : CGPointMake(-offsetValue, 0);
    }
    else
    {
        direction = (boundingBoxCenter.y < center.y) ? UIPopoverArrowDirectionUp : UIPopoverArrowDirectionDown;
        offset    = (boundingBoxCenter.y < center.y) ? CGPointMake(0, offsetValue) : CGPointMake(0, -offsetValue);
    }
    
    // Ensure the popover is displayed inside the view
    CGFloat presentationX    = MIN(MAX(point.x + offset.x, 0), self.view.frame.size.width);
    CGFloat presentationY    = MIN(MAX(point.y + offset.y, 0), self.view.frame.size.height);
    CGRect  presentationRect = CGRectMake(presentationX, presentationY, 1, 1);
    
    // Present Input Box
    [_inputBoxPopoverController presentPopoverFromRect:presentationRect
                                                inView:self.view
                              permittedArrowDirections:direction
                                              animated:YES];
}

#pragma mark - Geometry Widget Delegate - Label

- (NSString *)geometryView:(GWGeometryView *)geometryView labelForItem:(ItemID)item
{
    NSString *label = [geometryView titleForItem:item];
    
    if ([label isEqualToString:@""] && [geometryView displayValueForItem:item])
    {
        CGFloat pointLength = [geometryView valueForItem:item];
        
        if (pointLength > 0)
        {
            label = [AnnotationViewController stringForLengthValue:pointLength];
        }
    }
    
    return label;
}

#pragma mark - Configure Popover

- (void)presentConfigureMenu:(UIBarButtonItem *)button
{
    [_exportPopoverController dismissPopoverAnimated:NO];
    [_configurePopoverController dismissPopoverAnimated:NO];
    
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    
    settings.geometryView = _geometryView;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
    navController.navigationBar.tintColor = [UIColor appTintColor];
    
    if ([_configurePopoverController isPopoverVisible])
    {
        [_configurePopoverController dismissPopoverAnimated:YES];
        return;
    }
    
    _configurePopoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
    
    [_configurePopoverController presentPopoverFromBarButtonItem:button
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
}

#pragma mark - Export

- (void)presentExportMenu:(UIBarButtonItem *)button
{
    [_exportPopoverController dismissPopoverAnimated:NO];
    [_configurePopoverController dismissPopoverAnimated:NO];
    
    UIImage *image = [_geometryView resultAsImage];
    
    if (image)
    {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image]
                                                                                             applicationActivities:nil];
        
        activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
        
        _exportPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        
        [_exportPopoverController presentPopoverFromBarButtonItem:button
                                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                                         animated:YES];
    }
}

@end