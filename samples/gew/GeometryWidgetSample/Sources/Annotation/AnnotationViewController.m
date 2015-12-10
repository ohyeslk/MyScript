//
//  AnnotationViewController.m
//  GeometryWidgetTest
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "AnnotationViewController.h"
#import "ExternCertificate.h"
#import <AtkMaw/MAWMathWidget.h>

// Recognition resources used by the MathWidget
NSString *const MathViewResourceAK     = @"math-ak.res";
NSString *const MathViewResourceLength = @"segmentarc-grm-mathwidget.res";
NSString *const MathViewResourceAngle  = @"angle-grm-mathwidget.res";
NSString *const MathViewResourceLetter = @"point-grm-mathwidget.res";

@interface AnnotationViewController () <MAWMathViewControllerDelegate>

// Instruction displayed at the bottom of the view
@property (strong, nonatomic) UILabel *instructionLabel;

// Activity indicator displayed while the Math View is loading
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

// Value before editon
@property (strong, nonatomic) NSString *originalStringValue;

// Math views to take in user input and convert it to digitalized text.
// Regarding the type of items to annotate, we use different Math Views, configured with different
// recognition resources.
@property (strong, nonatomic) MAWMathViewController *lengthMathView;
@property (strong, nonatomic) MAWMathViewController *angleMathView;
@property (strong, nonatomic) MAWMathViewController *letterMathView;

@end

@implementation AnnotationViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        _lengthMathView = [MAWMathViewController new];
        _angleMathView  = [MAWMathViewController new];
        _letterMathView = [MAWMathViewController new];
        
        [self configureMathView:_lengthMathView withResources:@[MathViewResourceAK, MathViewResourceLength]];
        [self configureMathView:_angleMathView withResources:@[MathViewResourceAK, MathViewResourceAngle]];
        [self configureMathView:_letterMathView withResources:@[MathViewResourceAK, MathViewResourceLetter]];
        
        _itemType = GWItemOther;
        
        _instructionLabel                  = [[UILabel alloc] init];
        _instructionLabel.textAlignment    = NSTextAlignmentCenter;
        _instructionLabel.textColor        = [UIColor colorWithWhite:0.6 alpha:1.000];
        _instructionLabel.backgroundColor  = [UIColor clearColor];
        _instructionLabel.font             = [UIFont fontWithName:@"Helvetica-Light" size:18];
        _instructionLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                              UIViewAutoresizingFlexibleTopMargin);
    }
    
    return self;
}

- (void)configureMathView:(MAWMathViewController *)mathView withResources:(NSArray *)resources
{
    // Customize the visual appearance of the Math View
    mathView.view.frame            = CGRectMake(0, 0, 275, 140);
    mathView.baselineColor         = [UIColor clearColor];
    mathView.backgroundView        = nil;
    mathView.backgroundColor       = [UIColor clearColor];
    mathView.delegate              = self;
    mathView.font                  = [UIFont fontWithName:@"Helvetica-Light" size:100];
    mathView.textColor             = [UIColor colorWithRed:21.0 / 255.0 green:164.0 / 255.0 blue:252.0 / 255.0 alpha:1.0];
    mathView.inkColor              = [UIColor blackColor];
    mathView.paddingRatio          = UIEdgeInsetsMake(1.0, 0.6, 1.0, 0.6);
    mathView.beautificationOption  = MAWBeautifyFontify;
    mathView.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleHeight);
    
    // Configure the Math View with appropriate recognition resources and certificate
    NSData *certificate = [NSData dataWithBytes:myCertificate.bytes length:myCertificate.length];
    
    [mathView configureWithResources:resources certificate:certificate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lengthMathView.view.frame = self.view.bounds;
    _angleMathView.view.frame  = self.view.bounds;
    _letterMathView.view.frame = self.view.bounds;
    
    [self.view addSubview:_lengthMathView.view];
    [self.view addSubview:_angleMathView.view];
    [self.view addSubview:_letterMathView.view];
    
    _instructionLabel.frame = CGRectMake(0, self.view.frame.size.height - 38, self.view.frame.size.width, 20);
    [self.view addSubview:_instructionLabel];
}

#pragma mark - Type

- (void)setItemType:(GWItemType)itemType
{
    if (itemType != _itemType)
    {
        _itemType = itemType;
        
        // Display the appropriate Math View for the item type
        _lengthMathView.view.hidden = YES;
        _angleMathView.view.hidden  = YES;
        _letterMathView.view.hidden = YES;
        
        self.mathView.view.hidden = NO;
    }
}

#pragma mark - Math view

// Return the appropriate Math View for the item type
- (MAWMathViewController *)mathView
{
    if (_itemType == GWItemTypeLineSegment ||
        _itemType == GWItemTypeArc)
    {
        return _lengthMathView;
    }
    
    if (_itemType == GWItemConstraint)
    {
        return _angleMathView;
    }
    
    if (_itemType == GWItemPoint)
    {
        return _letterMathView;
    }
    
    return nil;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setItemID:(int64_t)item
{
    _itemID = item;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSString *stringToDisplay = nil;
        
        if (_itemType == GWItemTypeLineSegment ||
            _itemType == GWItemTypeArc)
        {
            _instructionLabel.text = NSLocalizedString(@"Write a new value", nil);
            
            // Get the length of the item (in points)
            CGFloat pointLength = [_geometryView valueForItem:item];
            
            stringToDisplay = [AnnotationViewController stringForLengthValue:pointLength];
        }
        else if (_itemType == GWItemConstraint)
        {
            _instructionLabel.text = NSLocalizedString(@"Write a new value", nil);
            
            // Get the angle value (in degrees)
            CGFloat angle = [_geometryView valueForItem:item];
            
            stringToDisplay = [AnnotationViewController stringForAngleValue:angle];
        }
        else if (_itemType == GWItemPoint)
        {
            // Get the title, previously associated with the item
            stringToDisplay = [_geometryView titleForItem:item];
            
            BOOL emptyString = (stringToDisplay == nil) || [stringToDisplay isEqualToString:@""];
            
            _instructionLabel.text = emptyString
            ? NSLocalizedString(@"Write a letter", nil)
            : NSLocalizedString(@"Write a new letter", nil);
        }
        
        // Load the string into the Math View
        [self displayString:stringToDisplay];
    }];
}

#pragma mark - Display string

/**
 *  Display a string into the current Math View
 *  @param string The string to display
 *  @discussion This method uses the `addSymbols` method of the Math View, that allows to create
 *  a symbol for each character of a string, and inject it into the Math View.
 */
- (void)displayString:(NSString *)string
{
    _originalStringValue = string;
    
    NSMutableArray *symbols = [NSMutableArray new];
    
    CGSize symbolSize = CGSizeMake(self.mathView.view.frame.size.width / [string length],
                                   self.mathView.view.frame.size.height);
    
    for (int i = 0; i < [string length]; i++)
    {
        NSString *character = [string substringWithRange:NSMakeRange(i, 1)];
        
        MAWSymbol *symbol = [[MAWSymbol alloc] initWithLabel:character
                                                 boundingBox:CGRectMake(i * symbolSize.width,
                                                                        -symbolSize.height,
                                                                        symbolSize.width,
                                                                        symbolSize.height)
                                                  transitory:NO];
        
        [symbols addObject:symbol];
    }
    
    [self.mathView addSymbols:symbols allowUndo:NO];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // Ensure that the popover value is displayed next to the item, once the popover is closed.
    [_geometryView setDisplayValue:YES forItem:_itemID];
    
    NSString *mathViewText = [self.mathView resultAsText];
    
    BOOL success = NO;
    
    if (![mathViewText isEqualToString:_originalStringValue])
    {
        if (_itemType == GWItemTypeLineSegment ||
            _itemType == GWItemTypeArc)
        {
            CGFloat centimeterLength;
            
            centimeterLength = [[mathViewText stringByReplacingOccurrencesOfString:@","
                                                                        withString:@"."] floatValue];
            
            // Rounding centimeterLength first
            NSString *roundedCentimeterLengthString = [NSString stringWithFormat:@"%.2f", centimeterLength];
            float     roundedCentimeterLength       = [roundedCentimeterLengthString floatValue];
            
            // Convert back to points
            CGFloat resolution = isPadMini() ? PointsPerCentimeteriPadMini : PointsPerCentimeteriPad;
            
            CGFloat pointLength = roundedCentimeterLength * resolution;
            
            // Rounding pointLength
            float roundedpointLength = pointLength;
            
            // Apply new length value to item
            success = [_geometryView setValue:roundedpointLength forItem:_itemID];
        }
        else if (_itemType == GWItemConstraint)
        {
            CGFloat angleValue = [[mathViewText stringByReplacingOccurrencesOfString:@","
                                                                          withString:@"."] floatValue];
            
            // Apply new angle value
            success = [_geometryView setValue:angleValue forItem:_itemID];
        }
        else if (_itemType == GWItemPoint)
        {
            // Save the letter into the `title` property of the item
            success = [_geometryView setTitle:mathViewText forItem:_itemID];
        }
    }
    
    [self.mathView clear];
    
    [_geometryView deselect];
}

#pragma mark - Convert length and angle to string

CGFloat const PointsPerCentimeteriPad     = 52.0;
CGFloat const PointsPerCentimeteriPadMini = 64.0;

+ (NSString *)stringForLengthValue:(CGFloat)pointLength
{
    CGFloat resolution = isPadMini() ? PointsPerCentimeteriPadMini : PointsPerCentimeteriPad;
    
    // Rounding pointLength first
    float roundedPointLength = pointLength;
    
    // Convert to centimeters
    CGFloat centimeterLength = roundedPointLength / resolution;
    
    // Truncate to 2 decimals
    NSString *lengthString = [NSString stringWithFormat:@"%.2f", centimeterLength];
    
    return [NSString stringWithFormat:@"%g", [lengthString floatValue]];
}

+ (NSString *)stringForAngleValue:(CGFloat)angle
{
    // Truncate to 2 decimals
    NSString *angleString = [NSString stringWithFormat:@"%.2f", angle];
    
    return [NSString stringWithFormat:@"%g", [angleString floatValue]];
}

@end