//
//  AnnotationViewController.h
//  GeometryWidgetTest
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <atkGew/GeometryWidget.h>

/**
 *  This class demonstrates how to offer item annotation to the user.
 *  In this example, user input is managed by a Math View, available in the Math Widget.
 *  Points, segment lines, arcs and angle can be annotated.
 *  - Point annotation allows to associate a letter with the item (e.g.: "A").
 *  - Segment line and arc annotation allows to edit the lenght of the item (e.g.: "7.3").
 *  - Angle annotation allows to edit the value of the angle (e.g.: "42").
 *  Once the editing is finished, a label is displayed in the canvas, next to the item.
 */
@interface AnnotationViewController : UIViewController <UIPopoverControllerDelegate>

/**
 *  The Geometry View holding the item being annotated
 */
@property (weak, nonatomic) GWGeometryView *geometryView;

/**
 *  The ID of the item being annotated
 */
@property (assign, nonatomic) ItemID itemID;

/**
 *  The type of the item beign annotated
 */
@property (assign, nonatomic) GWItemType itemType;

/**
 *  Create segment line and arc annotation string representing length value.
 */
+ (NSString *)stringForLengthValue:(CGFloat)pointLength;

/**
 *  Create angle annotation string representing angle value.
 */
+ (NSString *)stringForAngleValue:(CGFloat)angle;

@end