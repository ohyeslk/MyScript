//
//  GWGeometryView.h
//  GeometryWidget
//
//  Copyright (c) 2014 Vision Objects. All rights reserved.
//

#import "GeometryWidgetDefines.h"
#import <UIKit/UIKit.h>

typedef int64_t ItemID;

@class GWGeometryView;

/**
 * The GWGeometryViewDelegate protocol defines the methods you can implement to be notified of
 * the activity of a GWGeometryView object.
 * These methods allow to monitor events such as configuration, recognition or a change in the Undo
 * Redo stack.
 *
 * All of the methods in this protocol are optional.
 **/
@protocol GWGeometryViewDelegate <NSObject>

@optional

#pragma mark - Configuration

/** @name Monitoring Configuration */

/**
 * Tells the delegate that the Geometry Widget has started its configuration.
 * @param geometryView The geometry view that has started its configuration.
 */
- (void)geometryViewDidBeginConfiguration:(GWGeometryView *)geometryView;

/**
 * Tells the delegate that the Geometry Widget has end its configuration with success.
 * @param geometryView The geometry view that has ended its configuration.
 */
- (void)geometryViewDidEndConfiguration:(GWGeometryView *)geometryView;

/**
 * Tells the delegate that the Geometry Widget has failed its configuration.
 * @param geometryView The geometry view that has failed its configuration.
 * @param error        An NSError object that encapsulates information why configuration failed.
 */
- (void)geometryView:(GWGeometryView *)geometryView didFailConfigurationWithError:(NSError *)error;

#pragma mark - Recognition

/** @name Monitoring Recognition Progress */

/**
 * Tells the delegate that the Geometry Widget has begun a recognition session.
 * @param geometryView The geometry view that has begun a recognition process.
 * @discussion A recognition session starts when the user starts writing on the screen.
 *             The session can also start after an undo or redo or a after any context restoration
 *             such as screen rotation.
 */
- (void)geometryViewDidBeginRecognition:(GWGeometryView *)geometryView;

/**
 * Tells the delegate that the Geometry Widget has ended a recognition process.
 * @param geometryView The geometry view that has ended a recognition process.
 */
- (void)geometryViewDidEndRecognition:(GWGeometryView *)geometryView;

/**
 *  Tells the delegate that the Geometry Widget has ended updating the items after a recognition.
 *  @param geometryView The geometry view that has ended a recognition process.
 */
- (void)geometryViewDidUpdateItems:(GWGeometryView *)geometryView;

#pragma mark - Undo Redo

/** @name Monitoring Changes in Undo Redo Stack */

/**
 * Tells the delegate that the Geometry Widget Undo/Redo stack has changed.
 * @param geometryView The geometry view whose Undo/Redo stack has changed.
 */
- (void)geometryViewDidChangeUndoRedoState:(GWGeometryView *)geometryView;

#pragma mark - Gesture

/** @name Handling Gestures */

/**
 * Tells the delegate that the Geometry Widget has detected an erase gesture.
 * @param geometryView The geometry view that has detected an erase gesture.
 * @param partial      `YES` if the all the sketch was deleted; otherwise, `NO`.
 */
- (void)geometryView:(GWGeometryView *)geometryView didPerformEraseGesture:(BOOL)partial;

#pragma mark - Selection

/**
 *  Tells the delegate that an item has been selected by the user.
 *  @param geometryView The geometry view that has detected the selection.
 *  @param item         The selected item.
 *  @param type         The type of the selected item.
 *  @param point
 */
- (void)geometryView:(GWGeometryView *)geometryView
       didSelectItem:(ItemID)item
              ofType:(GWItemType)type
             displayPoint:(CGPoint)point;

#pragma mark - Recognition Timeout

/** @name Handling Long Recognition  */

#pragma mark - Writing

/** @name Monitoring User Input */

/**
 * Tells the delegate that the user has started touching the screen.
 * @param geometryView The geometry view receiving touches.
 */
- (void)geometryViewDidBeginWriting:(GWGeometryView *)geometryView;

/**
 * Tells the delegate that the user has ending touching the screen.
 * @param geometryView The geometry view that has stopped receiving touches.
 */
- (void)geometryViewDidEndWriting:(GWGeometryView *)geometryView;

#pragma mark - Label

/**
 *  Return the label to display next to the given item
 *
 *  @param geometryView The geometry view
 *  @param item         The ID of the item for which to display the label
 *
 *  @return An `NSString` corresponding to the label to display
 */
- (NSString *)geometryView:(GWGeometryView *)geometryView labelForItem:(ItemID)item;

@end

/**
 * The `GWGeometryView` is the entry point of the Geometry Widget. You use this class as-is to 
 * display an interactive canvas to create and manipulate geometry items.
 *
 * The `GWGeometryView` takes care of capturing user input, and displaying recognized geometry items
 * such as line segments, arcs, points, etc.
 *
 * After initializing the `GWGeometryView`, you configure it with recognition resources and a 
 * recognition certificate (see `configureWithResources:certificate:`).
 *
 * Although you should not subclass the `GWGeometryView` class itself, you can get information about
 * the geometry view’s behavior by providing a delegate object. The geometry view calls the methods 
 * of your custom delegate to let it know about events such as configuration, recognition or item 
 * selection. The delegate object can be any object in your application as long as it conforms to 
 * the `GWGeometryViewDelegate` protocol.
 */
@interface GWGeometryView : UIView

#pragma mark - Engine Configuration

/** @name Configuring the Engine */

/**
 * Configure the geometry component.
 * @param resources   An array of `NSString` objects that represent the names to geometry resources.
 * @param certificate The data object containing the certificate.
 * @discussion This method is non-blocking and returns immediately.
 *             Configuration is a lengthy process that may take up to several seconds, depending on
 *             the resources attached. It is recommended to setup a delegate to detect the
 *             end of the configuration process. See GWGeometryViewDelegate.
 */
- (void)configureWithResources:(NSArray *)resources certificate:(NSData *)certificate;

/**
 * An `NSString` object representing the location of the geometry component recognition resources.
 * @discussion The geometry component recognition resources are normally loaded from default
 * application bundle. You can choose to load the geometry componnent recognition resources from a
 * different path using this property.
 */
@property (strong, nonatomic) NSString *resourcesPath;

#pragma mark - Delegate

/** @name Getting and Setting the Delegate */

/**
 * The receiver’s delegate or nil if it doesn’t have a delegate.
 * @discussion See GWGeometryViewDelegate for the methods this delegate can implement.
 */
@property (assign, nonatomic) id <GWGeometryViewDelegate> delegate;

#pragma mark - Undo Redo

/** @name Managing Undo/Redo */

/**
 * Returns a Boolean value that indicates whether the Geometry Widget has any actions to undo.
 * @return `YES` if the Geometry Widget has any actions to undo, otherwise `NO`.
 */
- (BOOL)canUndo;

/**
 * Returns a Boolean value that indicates whether the Geometry Widget has any actions to redo.
 * @return `YES` if the Geometry Widget has any actions to redo, otherwise `NO`.
 */
- (BOOL)canRedo;

/**
 * Performs one undo step.
 */
- (void)undo;

/**
 * Performs one redo step.
 */
- (void)redo;

#pragma mark - Items management

/** @name Managing items */

/**
 * Clears the ink and the text.
 */
- (void)clear;

/**
 * Returns a Boolean value that indicates whether the Geometry Widget contains items (ink or text).
 * @return `YES` if the Geometry Widget does not contain any items, otherwise `NO`.
 */
@property (assign, nonatomic, readonly) BOOL isEmpty;

#pragma mark - Constraints management

/** @name Managing detection and display for implicit and explicit constraints */

/**
 *  Returns the constraints for which the specified behavior is active.
 *  @param behavior The behavior
 *  @return An integer bit mask that determines the constraints for which the specified behavior is
 *          active.
 */
- (GWConstraint)enabledConstraintsForBehavior:(GWConstraintBehavior)behavior;

/**
 *  Enable or disable detection and display of implicit and explicit constraints.
 *  @param enabled     A boolean specifying if the constraints should be enabled or disabled
 *  @param constraints An integer bit mask that determines the affected constraints
 *  @param behavior    The affected behavior
 *  @discussion Use this method to enable or disable detection and display of implicit and explicit
 *  constraints. 
 *  For example, to enable display of explicit angle equalities and perpendicularities,
 *  call:
 *  `[geometryView setConstraintsEnabled:YES constraints:GWConstraintAngleValue |
 *  GWConstraintPerpendicularity forBehavior:GWConstraintBehaviorExplicitDisplay]`.
 */
- (void)setConstraintsEnabled:(BOOL)enabled
                  constraints:(GWConstraint)constraints
                  forBehavior:(GWConstraintBehavior)behavior;

#pragma mark - Appearance

/** @name Customizing Appearance */

/**
 * Background view of the writing area.
 * @discussion The view is automatically resized to match the size of the Geometry Widget View.
 *
 * The default background view is a `UIImageView` displaying a graph paper pattern. You can set this
 * property to `nil` to remove the background.
 */
@property (strong, nonatomic) UIView *backgroundView;

/**
 * Color of the ink.
 * @discussion The default value of this property is `[UIColor colorWithRed:75/255.0 green:87/255.0
 *             blue:117/255.0 alpha:1]`.
 */
@property (strong, nonatomic) UIColor *inkColor;

/**
 * Thickness of the ink.
 * @discussion This is the maximum thickness of the ink. Real thickness vary slightly to simulate
 *             pressure.
 *
 *             The default value of this property is `2`.
 */
@property (assign, nonatomic) CGFloat inkThickness;

/**
 * Dash aspect for the ink.
 * @discussion The ink is dashed when active.
 *
 *             The default value of this property is `NO`.
 */
@property (assign, nonatomic) BOOL inkDashed;

/**
 *  Return the current boolean value associated to the given `GWBoolParameter`.
 *
 *  @param parameter The parameter for which to get the boolean value.
 *
 *  @return return `YES` if the behavior associated to the `GWBoolParameter` is activated in the 
 *          Geometry view.
 *
 *  @discussion see `GWBoolParameter` to get a description of boolean parameters accepted by the 
 *              Geometry view.
 */
- (BOOL)boolValueForParameter:(GWBoolParameter)parameter;

/**
 *  Set the given boolean value to the specified `GWBoolParameter`.
 *
 *  @param boolValue `YES` to enable the behiavior associated to the `GWBoolParameter`, `NO` to 
 *         disable it.
 *  @param parameter The `GWBoolParameter` to enable or disable.
 *
 *  @discussion see `GWBoolParameter` to get a description of boolean parameters accepted by the
 *              Geometry view.
 */
- (void)setBoolValue:(bool)boolValue forParameter:(GWBoolParameter)parameter;

/**
 *  Return the current float value associated to the given `GWFloatParameter`.
 *
 *  @param parameter The parameter for which to get the float value.
 *
 *  @return return the float value associated to the `GWBoolParameter` in the Geometry view.
 *
 *  @discussion see `GWFloatParameter` to get a description of float parameters accepted by the
 *              Geometry view.
 */
- (CGFloat)floatValueForParameter:(GWFloatParameter)parameter;

/**
 *  Set the given float value to the specified `GWFloatParameter`.
 *
 *  @param floatValue the float value to set for the `GWBoolParameter`.
 *  @param parameter The `GWBoolParameter` to configure.
 *
 *  @discussion see `GWFloatParameter` to get a description of float parameters accepted by the
 *              Geometry view.
 */
- (void)setFloatValue:(CGFloat)floatValue forParameter:(GWFloatParameter)key;

#pragma mark - Padding

/** @name Customizing Padding */

#pragma mark - Recognition Timeout

/** @name Handling Long Recognition */

#pragma mark - Output

/** @name Exporting sketch */

/**
 * Get the sketch as an image.
 * @return A UIImage similar to what is is displayed by the Geometry Widget.
 */
- (UIImage *)resultAsImage;

#pragma mark - Palm rejection

/** @name Ignoring Unwanted Touches */

/**
 * A Boolean value that determines whether the Geometry Widget should ignore unwanted touches caused
 * by the user palm.
 *
 * @discussion The default value of this property is `YES`.
 */
@property (assign, nonatomic) BOOL palmRejectionEnabled;

/**
 * A Boolean value that determines whether the Palm Rejection should be configured for left handed
 * users.
 *
 * @discussion The default value of this property is `NO`.
 */
@property (assign, nonatomic) BOOL palmRejectionLeftHanded;

#pragma mark - Recognition

/** @name Monitoring recognition */

/**
 * Returns a Boolean value that indicates whether the recognition engine is currently busy.
 * @return `YES` if the recognition engine is currently busy, otherwise `NO`.
 */
@property (assign, nonatomic, readonly) BOOL isBusy;

#pragma mark - Item info

/** @name Associate data to geometry items */

/**
 *  Returns the frame of the view representing a given item
 *  @param item The ID of the item
 *  @return The frame of the item
 */
- (CGRect)boundingBoxForItem:(ItemID)item;

/**
 *  Get title previously associated with a given item
 *  @param item The ID of the item
 *  @return The title previously associated with the item
 */
- (NSString *)titleForItem:(ItemID)item;

/**
 *  Set title associated with a given item
 *  @param title The title to associate with the item. Can be `nil`.
 *  @param item The ID of the item
 *  @return `YES` if the value has been successfully set, `NO` otherwise.
 */
- (BOOL)setTitle:(NSString *)title forItem:(ItemID)item;

/**
 *  Get display value flag associated with a given item
 *  @param item The ID of the item.
 *  @return `YES` if the value has been successfully set, `NO` otherwise.
 */
- (BOOL)displayValueForItem:(ItemID)item;

/**
 *  Set display value flag associated with a given item
 *  @param display value flag associate with the item.
 *  @param item The ID of the item.
 *  @return `YES` if the value has been successfully set, `NO` otherwise.
 */
- (BOOL)setDisplayValue:(BOOL)displayValue forItem:(ItemID)item;

/**
 *  Get the value of a given item.
 *  @param item The ID of the item
 *  @return The value of the item
 *  @discussion For line and arc item, this value is the length of the item, in points. For angle
 *  constraints, this value is the value of the angle, in degree. For other types, the value is
 *  undetermined.
 */
- (CGFloat)valueForItem:(ItemID)item;

/** @name Link data with geometry items */

/**
 *  Set the value of a given item.
 *  @param value The new value of the item
 *  @param item The ID of the item
 *  @discussion For line and arc item, you can set the length of the item, in points. For angle
 *  constraints, you can set the value of the angle, in degree.
 *  @return `YES` if the value has been successfully set, `NO` otherwise.
 */
- (BOOL)setValue:(CGFloat)length forItem:(ItemID)item;

/**
 *  Return the annotation view previously associated to a given item. See 
 *  `setAnnotationView:forItem:`.
 *  @param item The ID of the item
 *  @return The annotation view previously associated with the item.
 */
- (UIView *)annotationViewForItem:(ItemID)item;

/**
 *  Add an annotation view to a given item.
 *  @param annotationView The view to use as annotation of the item
 *  @param item           The ID of the item
 *  @discussion You use this method to display an annotation next to an item. Any `UIView` sublass
 * is supported. The Geometry View keeps the size of the given view and automatically adjust its 
 * origin to display it next to the item.
 */
- (void)setAnnotationView:(UIView *)annotationView forItem:(ItemID)item;

#pragma mark - Selection

/**
 *  Deselect all selected items.
 */
- (void)deselect;

/** @name Saving and Restoring recognitions results */

/**
 * Serialize the current input.
 * @discussion This method can be used to save an equation as binary data.
 * @return A data object containing the serialized equation.
 */
- (NSData *)serialize;

/**
 * Restore an input saved using the `serialize` method.
 * @param      data The data to unserialize, provided by `serialize`.
 * @return     `YES` if the data was properly unserialized, `NO` otherwise.
 * @discussion This method can be used to restore an equation from binary data.
 */
- (BOOL)unserialize:(NSData *)data;

#pragma mark - Version

/** @name Getting Geometry Widget version */

/**
 *  Return the Geometry Widget version (e.g.: `1.0.1`).
 *
 *  @return The Geometry Widget version
 */
+ (NSString *)versionString;

@end