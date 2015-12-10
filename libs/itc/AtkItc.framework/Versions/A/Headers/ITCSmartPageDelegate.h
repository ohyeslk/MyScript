// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCError.h"

@class ITCSmartPage;

/**
 * The ITCSmartPageDelegate protocol defines the methods you can implement to be notified of
 * the activity of a ITCSmartPage.
 * These methods allow to monitor events such as added strokes, words, ...
 *
 * All the methods in this protocol are optional.
 **/
@protocol ITCSmartPageChangeDelegate <NSObject>

@optional

/**
 *  Indicates that the strokes of the page changed
 *
 *  @param smartPage      The involved object
 *  @param addedStrokes   The new added strokes
 *  @param removedStrokes The removed strokes
 */
- (void)pageChanged:(ITCSmartPage *)smartPage withAddedStrokes:(NSArray*)addedStrokes andRemovedStrokes:(NSArray*)removedStrokes;

/**
 *  Indicates that the words of the page changed
 *
 *  @param smartPage      The involved object
 *  @param addedStrokes   The new added words
 *  @param removedStrokes The removed words
 */
- (void)pageChanged:(ITCSmartPage *)smartPage withAddedWords:(NSArray*)addedWords andRemovedWords:(NSArray*)removedWords;

@end
