// Copyright MyScript

#import <UIKit/UIKit.h>

/**
 * Class SCWSingleCharView.
 */
@class SCWSingleCharView;

/**
 * Protocol SCWSingleCharViewDelegate.
 */
@protocol SCWSingleCharViewDelegate <NSObject>

@optional

/**
 * Called when the text changes.
 * <p>
 * The text returned by this callback may be intermediate, which
 * means that it can change again in the near future. Text is
 * intermediate when the widget has some ink that has not been
 * processed yet.
 *
 * @param sender SingleCharWidget
 * @param text NSString representation of the text.
 * @param intermediate <code>YES</code> if the text is an
 * intermediate handwriting recognition result, <code>NO</code>
 * if the text is stable.
 */
- (void)singleCharWidget:(SCWSingleCharView *)sender didChangeText:(NSString*)text intermediate:(BOOL)intermediate;

/**
 * Called when handwriting configuration starts.
 *
 * @param sender SingleCharWidget
 */
- (void)singleCharWidgetDidBeginConfiguration:(SCWSingleCharView*)sender;

/**
 * Called when handwriting configuration ends.
 * <p>
 *
 * @param sender SingleCharWidget
 * @param success <code>YES</code> if configuration succeeded,
 * <code>NO</code> otherwise.
 */
- (void)singleCharWidget:(SCWSingleCharView*)sender didEndConfigurationWithSuccess:(BOOL)success;

/**
 * Called when a recognition session starts.
 * <p>
 * A recognition session starts when the user starts writing on the
 * screen.
 * <p>
 * During a recognition session, the text may change as the user is
 * writing. A text changed event is triggered each time the text is
 * updated by the user.
 *
 * @param sender SingleCharWidget
 */
- (void)singleCharWidgetDidBeginRecognition:(SCWSingleCharView*)sender;

/**
 * Called when a recognition session ends.
 * <p>
 * The text does not change anymore after a recognition session is
 * finished.
 *
 * @param sender SingleCharWidget
 */
- (void)singleCharWidgetDidEndRecognition:(SCWSingleCharView*)sender;

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
 * @param sender SingleCharWidget
 * @param point CGPoint position of the single tap in widget coordinates.
 */
- (BOOL)singleCharWidget:(SCWSingleCharView*)sender didDetectSingleTapAtPoint:(CGPoint)point;

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
 * @param sender SingleCharWidget
 * @param point CGPoint position of the long press in widget coordinates.
 */
- (BOOL)singleCharWidget:(SCWSingleCharView *)sender didDetectLongPressAtPoint:(CGPoint)point;

/**
 * Called when a backspace gesture is detected.
 * <p>
 * The gesture should be applied at the current insert index.
 *
 * @param sender SingleCharWidget
 * @param count NSUInteger of consecutive detected backspace gestures.
 *
 */
- (void)singleCharWidget:(SCWSingleCharView*)sender didDetectBackspaceGesture:(NSUInteger)count;

/**
 * Called when a return gesture is detected.
 * <p>
 * The gesture should be applied at the current insert index.
 *
 * @param sender SingleCharWidget
 */
- (void)singleCharWidgetDidDetectReturnGesture:(SCWSingleCharView*)sender;

@end
