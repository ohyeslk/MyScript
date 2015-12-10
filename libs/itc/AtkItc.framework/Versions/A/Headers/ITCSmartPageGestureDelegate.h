// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCSmartPage.h"

@class ITCSmartWord;
@class ITCWordRange;

/**
 * The ITCSmartPageGestureDelegate protocol defines the methods you can implement to be notified of
 * the activity in a ITCSmartPage.
 * These methods allow to monitor events related to the gestures.
 *
 * All the methods in this protocol are optional.
 **/
@protocol ITCSmartPageGestureDelegate <NSObject>

@optional

/**
 *  Notifies that an insert gesture has been detected.
 *  @param page           The page where the gesture has been detected.
 *  @param gestureStrokes The strokes written to perform a gesture. They may not be in the model.
 *  @param x              The abscissa of the gesture.
 *  @param nearestWord    The nearest word.
 *  @param charIndex      The character index next to the gesture in the writing direction.
 */
- (void)insertGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray*)gestureStrokes x:(float)x nearestWord:(ITCSmartWord *)nearestWord charIndex:(NSInteger)charIndex;

/**
 *  Notifies that a join gesture has been detected.
 *  @param page           The page where the gesture has been detected.
 *  @param gestureStrokes The strokes written to perform a gesture. They may not be in the model.
 *  @param x              The abscissa of the gesture.
 *  @param nearestWord    The nearest word.
 *  @param charIndex      The character index next to the gesture in the writing direction.
 */
- (void)joinGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray*)gestureStrokes x:(float)x nearestWord:(ITCSmartWord *)nearestWord charIndex:(NSInteger)charIndex;

/**
 *  Notifies that an erase gesture has been detected.
 *  @param page           The page where the gesture has been detected.
 *  @param gestureStrokes The strokes written to perform a gesture. They may not be in the model.
 *  @param wordRange      The word range.
 */
- (void)eraseGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray*)gestureStrokes wordRange:(ITCWordRange *)wordRange;

/**
 *  Notifies that an overwrite gesture has been detected.
 *  @param page           The page where the gesture has been detected.
 *  @param wordRange      The word range.
 */
- (void)overwriteGestureWithinPage:(ITCSmartPage *)page wordRange:(ITCWordRange *)wordRange;

/**
 *  Notifies that a single tap gesture has been detected.
 *  @param page           The page where the gesture has been detected.
 *  @param gestureStrokes The strokes written to perform a gesture. They may not be in the model.
 *  @param x              The abscissa of the gesture.
 *  @param y              The ordinate of the gesture.
 */
- (void)singleTapGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray*)gestureStrokes x:(float)x y:(float)y;

/**
 *  Notifies that a selection gesture has been detected.
 *  @param page           The page where the gesture has been detected.
 *  @param gestureStrokes The strokes written to perform a gesture. They may not be in the model.
 *  @param wordRange      The word range.
 */
- (void)selectionGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray*)gestureStrokes wordRange:(ITCWordRange *)wordRange;

/**
 *  Notifies that an underline gesture has been detected.
 *  @param page           The page where the gesture has been detected.
 *  @param gestureStrokes The strokes written to perform a gesture. They may not be in the model.
 *  @param wordRange      The word range.
 */
- (void)underlineGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray*)gestureStrokes wordRange:(ITCWordRange *)wordRange;

/**
 *  Notifies that a return gesture has been detected.
 *  @param page           The page where the gesture has been detected.
 *  @param gestureStrokes The strokes written to perform a gesture. They may not be in the model.
 *  @param x              The abscissa of the gesture.
 *  @param nearestWord    The nearest word.
 *  @param charIndex      The character index next to the gesture in the writing direction.
 */
- (void)returnGestureWithinPage:(ITCSmartPage *)page gestureStrokes:(NSArray*)gestureStrokes x:(float)x nearestWord:(ITCSmartWord *)nearestWord charIndex:(NSInteger)charIndex;

@end
