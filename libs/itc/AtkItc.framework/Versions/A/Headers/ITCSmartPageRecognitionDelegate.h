// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCSmartPage.h"

/**
 * The ITCSmartPageRecognitionDelegate protocol defines the methods you can implement to be notified of
 * the activity of a ITCSmartPage.
 * These methods allow to monitor events related to the recognition.
 *
 * All the methods in this protocol are optional.
 **/
@protocol ITCSmartPageRecognitionDelegate <NSObject>

@optional

/**
 * Event fired when the recognition starts.
 * @param smartPage the Page involved in the recognition process.
 */
- (void)pageWillStartRecognition:(ITCSmartPage *)page;

/**
 * Event fired when the recognition ends.
 * @param smartPage the Page involved in the recognition process.
 */
- (void)pageDidRecognitionEnd:(ITCSmartPage *)page;

/**
 * Event fired when the recognition ends before the end of the freeze timeout.
 * @param smartPage the Page involved in the recognition process.
 */
- (void)recognizerIntermediate:(ITCSmartPage *)page;

@end
