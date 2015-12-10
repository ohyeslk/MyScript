// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCError.h"

@class ITCPageInterpreter;

/**
 * The IOSPageInterpreterDelegate protocol defines the methods you can implement to be notified of
 * the activity of a IOSPageInterpreter object.
 * These methods allow to monitor configuration events.
 *
 * All the methods in this protocol are optional.
 **/
@protocol ITCPageInterpreterDelegate <NSObject>

@optional

/**
 *  Indicates that the configuration will start
 *
 *  @param pageManager The involved object
 */
- (void)pageInterpreterWillStartConfiguration:(ITCPageInterpreter *)pageInterpreter;

/**
 *  Indicates that the configuration is over
 *
 *  @param pageInterpreter  The involved object
 *  @param succeed          If the configuration is OK
 *  @param error            Error if an error occurred
 */
- (void)pageInterpreter:(ITCPageInterpreter *)pageInterpreter didConfigureEnded:(BOOL)succeed error:(ITCError *)error locale:(NSString *)locale;

@end
