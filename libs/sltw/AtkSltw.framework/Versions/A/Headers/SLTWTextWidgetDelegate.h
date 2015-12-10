// Copyright MyScript. All rights reserved.

@class SLTWTextWidget;

@protocol SLTWTextWidgetDelegate <NSObject>

@optional

/**
 * Called when the text changes.
 * <p>
 * The text returned by this callback may be intermediate, which
 * means that it can change again in the near future. Text is
 * intermediate when there is some ink left in the writing area
 * that has not been processed yet.
 *
 * @param sender TextWidget.
 * @param text String representation of the text.
 * @param intermediate <code>true</code> if the text is an intermediate
 * handwriting recognition result, <code>false</code> if the text is
 * stable.
 */
- (void)textWidget:(SLTWTextWidget *)sender didUpdateText:(NSString *)text intermediate:(BOOL)intermediate;

/**
 * Called when the text selection changes.
 *
 * @param sender TextWidget.
 * @param range Characters indexs of the first character and the last character of the
 * selection or -1 if selection is empty.
 *
 * @param labels NSArray of candidate labels for this selection range or
 * <code>null</code> if selection is empty.
 *
 * @param selectedIndex Index of the currently selected candidate
 * label or -1 if selection is empty.
 */
- (void)textWidget:(SLTWTextWidget *)sender didSelectWordInRange:(NSRange)range labels:(NSArray *)labels selectedIndex:(NSUInteger)selectedIndex;

/**
 * Called when configuration starts.
 * @param sender TextWidget.
 */
- (void)textWidgetDidBeginConfiguration:(SLTWTextWidget *)sender;

/**
 * Called when configuration ends.
 * <p>
 * In case of failure, you may retrieve more information by calling
 * {@link #(BOOL)failed}.
 * @param sender TextWidget.
 */
- (void)textWidgetDidEndConfiguration:(SLTWTextWidget *)sender;

/**
 * Called when a recognition session starts.
 * <p>
 * A recognition session starts when the user starts writing on the
 * screen.
 * <p>
 * During a recognition session, the text may change as the user is
 * writing and editing using gestures. A text changed events is
 * triggered each time text is updated by the user.
 * @param sender TextWidget.
 */
- (void)textWidgetDidBeginRecognition:(SLTWTextWidget *)sender;

/**
 * Called when a recognition session ends.
 * <p>
 * The text does not change anymore after a recognition session is
 * finished.
 * @param sender TextWidget.
 */
- (void)textWidgetDidEndRecognition:(SLTWTextWidget *)sender;

/**
 * Called when a single tap gesture is detected.
 * @param sender TextWidget.
 * @param index Index of the character tapped by the user.
 */
- (void)textWidget:(SLTWTextWidget *)sender didDetectSingleTapAtIndex:(NSUInteger)index;

/**
 * Called when a join gesture is detected.
 * @param sender TextWidget.
 * @param index Character index before which join gesture is detected.
 */
- (void)textWidget:(SLTWTextWidget *)sender didDetectJoinGestureAtIndex:(NSUInteger)index;

/**
 * Called when a return gesture is detected.
 * @param sender TextWidget.
 * @param index Character index before which return gesture is detected.
 */
- (void)textWidget:(SLTWTextWidget *)sender didDetectReturnGestureAtIndex:(NSUInteger)index;

/**
 * Called when an insert gesture is detected.
 * @param sender TextWidget.
 * @param index Character index before which insert gesture is detected.
 */
- (void)textWidget:(SLTWTextWidget *)sender didDetectInsertGestureAtIndex:(NSUInteger)index;

/**
 * Called when a single tap gesture is detected.
 * <p>
 * The application may choose to take action when a single tap
 * gesture is detected, in this case this callback shall return
 * <code>YES</code> to indicate that it handled the event.
 * <p>
 * If this callback returns <code>NO</code>, then the single
 * tap gesture is considered by the widget as a genuine dot and
 * passed to the handwriting recognizer.
 *
 * @param sender TextWidget
 * @param point CGPoint position of the single tap in widget coordinates.
 */
- (BOOL)textWidget:(SLTWTextWidget *)sender didDetectSingleTapAtPoint:(CGPoint)point;

/**
 * Called when a long press gesture is detected.
 * <p>
 * The application may choose to take action when a long press
 * gesture is detected, in this case this callback shall return
 * <code>YES</code> to indicate that it handled the event and the
 * current stroke is cancelled.
 * <p>
 * If this callback returns <code>NO</code>, then the long
 * press gesture is discarded by the widget and the widget resumes
 * capturing the current stroke.
 *
 * @param sender TextWidget
 * @param point CGPoint position of the long press in widget coordinates.
 */
- (BOOL)textWidget:(SLTWTextWidget *)sender didDetectLongPressAtPoint:(CGPoint)point;

@end
