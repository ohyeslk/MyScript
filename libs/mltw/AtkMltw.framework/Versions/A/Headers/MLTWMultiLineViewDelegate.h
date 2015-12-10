//
//  MLTWMultiLineViewDelegate.h
//  MultiLineTextWidget
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "MLTWMultiLineEnums.h"
#import "MLTWWord.h"
#import <Foundation/Foundation.h>

@class MLTWMultiLineView;

/**
 *  The main delegate of the multi line text widget.
 *  This protocol is heavily used for configuration, recognition, gestures and other user actions...
 *  Each methods may be implemented or not depending of the needs.
 */
@protocol MLTWMultiLineViewDelegate <NSObject>

@optional

#pragma mark - Configuration

/** @name Monitoring Configuration */

/**
 *  Fired when the configuration starts. This is the first step to active recognition. In order
 * for the recognition to work, a multiLineViewDidEndConfiguration: will be fired soon after.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 */
- (void)multiLineViewDidBeginConfiguration:(MLTWMultiLineView *)view;

/**
 *  Fired when the configuration ends. The recognition mecanism has now started and other
 * notifications can be fired.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 */
- (void)multiLineViewDidEndConfiguration:(MLTWMultiLineView *)view;

/**
 *  Fired when the configuration has failed. If so, an other configuration
 * is required.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate.
 *  @param error The error causing the configuration to fail.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didFailConfigurationWithError:(NSError *)error;

#pragma mark - Gestures

/** @name Monitoring Gestures */
/**
 *  Called when an insert gesture is detected.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 *  @param word The word inside which the gesture is detected
 *  @param characterIndex The character index of the word where the gesture is detected.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didDetectInsertGestureForWord:(MLTWWord *)word atIndex:(NSUInteger)characterIndex;

/**
 *  Called when a join gesture is detected.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 *  @param word The word inside which the gesture is detected
 *  @param characterIndex The character index of the word where the gesture is detected.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didDetectJoinGestureForWord:(MLTWWord *)word atIndex:(NSUInteger)characterIndex;

/**
 *  Called when a return gesture is detected.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 *  @param word The word inside which the gesture is detected
 *  @param characterIndex The character index of the word where the gesture is detected.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didDetectReturnGestureForWord:(MLTWWord *)word atIndex:(NSUInteger)characterIndex;

/**
 *  Called when a selection gesture is detected.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate.
 *  @param words The words impacted by the selection gesture.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didDetectSelectionGestureForWords:(NSArray *)words;

/**
 *  Called when a single tap gesture is detected.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate.
 *  @param word The word inside which the gesture is detected.
 *  @param characterIndex The character index of the word where the gesture is detected.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didDetectSingleTapGestureForWord:(MLTWWord *)word atIndex:(NSUInteger)characterIndex;

/**
 *  Called when an underline tap gesture is detected.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate.
 *  @param words The words impacted by the selection gesture.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didDetectUnderlineGestureForWords:(NSArray *)words;

#pragma mark - Recognition

/** @name Monitoring recognition */

/**
 *  Called every time before the recognition is launched.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate.
 */
- (void)multiLineViewDidStartRecognition:(MLTWMultiLineView *)view;

/**
 *  Called every time after the recognition ends.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate.
 */
- (void)multiLineViewDidEndRecognition:(MLTWMultiLineView *)view;

#pragma mark - Text

/** @name Monitoring text changes */

/**
 *  Called every time the recognition changes.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate.
 *  @param text The new text in the page
 * recognition. This is used to get a feedback for management of large data.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didChangeText:(NSString *)text;

#pragma mark - Selection word

/**
 *  The selection is fired each time a word is highlighted.
 *  This is not the same notification that multiLineView:didDetectSelectionGestureForWords: which
 * will be fired after a selection gesture.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate.
 *  @param word The selected word
 *  @param isHighlighted `YES` if the word has been highlighted, `NO` otherwise.
 */
- (void)multiLineView:(MLTWMultiLineView *)view didSelectionWord:(MLTWWord *)word isHighlighted:(BOOL)isHighlighted;

/**
 *  Called every time a new mode is used.
 *  There are currently 3 modes: Writing, Correction, Insertion. The writing mode is the  default
 *mode and is also called after `setWritingMode:`. Use for writing texts, no highlight of word with
 * automatic scroll. The correction is used after a gesture (except insertGesture) or a
 *`setCorrectionMode:`. The insertion mode is used after a `setInsertMode:`, it will create a
 * insertion zone before or after the word, according to the character index.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 *  @param previousMode The previous mode used
 *  @param newMode The new mode
 */
- (void)multiLineView:(MLTWMultiLineView *)view didChangeModeWithPreviousMode:(MLTWMultilineMode)previousMode newMode:(MLTWMultilineMode)newMode;

#pragma mark - Auto Scroll

/** @name Monitoring scroll event */

/**
 *  Called just before an auto scroll.
 *
 *  Autoscroll is fired with the writing mode or with the `setCorrectionMode:` or when calling
 *`scrollWordToTop:` or a `scrollWordToCenter:`
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 */
- (void)multiLineViewAutoScrollWillBegin:(MLTWMultiLineView *)view;

/**
 *  Called after an auto scroll.
 *
 *  Autoscroll is fired with the writing mode or with the `setCorrectionMode:` or when calling
 *`scrollWordToTop:` or a `scrollWordToCenter:`
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 *  @param offsetY The new Y offset of the scroll bar
 */
- (void)multiLineView:(MLTWMultiLineView *)view autoScrollDidMove:(CGFloat)offsetY;

/**
 *  Called after an auto scroll has stopped.
 *
 *  Autoscroll is fired with the writing mode or with the `setCorrectionMode:` or when calling
 *`scrollWordToTop:` or a `scrollWordToCenter:`
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 */
- (void)multiLineViewAutoScrollDidEnd:(MLTWMultiLineView *)view;

#pragma mark - Scroll

/**
 *  Called just before a manual scroll.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 */
- (void)multiLineViewScrollWillBegin:(MLTWMultiLineView *)view;

/**
 *  Called after a manual scroll.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 *  @param offsetY The new offset Y of the scroll bar
 */
- (void)multiLineView:(MLTWMultiLineView *)view scrollDidMove:(CGFloat)offsetY;

/**
 *  Called after a manual scroll has stopped.
 *
 *  @param view The current MLTWMultiLineView, managing the delegate
 */
- (void)multiLineViewScrollDidEnd:(MLTWMultiLineView *)view;

@end