// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCSmartPageDelegate.h"
#import "ITCSmartPageRecognitionDelegate.h"
#import "ITCSmartPageGestureDelegate.h"

@class ITCSmartStroke;
@class ITCSmartWord;
@class ITCStrokeRange;
@class ITCWordRange;
@class ITCWordFactory;

/**
 *  This class handles everything related to strokes and words management.
 *
 *  Do not inherit
 */
@interface ITCSmartPage : NSObject

/** @name Getting and Setting the Delegates */

/**
 *  Delegate to be notified for strokes/words added/removed.
 */
@property (nonatomic, weak) id<ITCSmartPageChangeDelegate> changeDelegate;

/**
 *  Delegate to be notified for the progress of recognition.
 */
@property (nonatomic, weak) id<ITCSmartPageRecognitionDelegate> recognitionDelegate;

/**
 *  Delegate to be notified when a gesture is detected.
 */
@property (nonatomic, weak) id<ITCSmartPageGestureDelegate> gestureDelegate;

//==================================================================================================
#pragma mark - Creation
//==================================================================================================

/** @name Creation */

/**
 *  Creates a new ITCSmartPage.
 *  @param wordFactory Word factory to be used for word creation. Can not be `nil`.
 *  @return The new ITCSmartPage
 */
+ (ITCSmartPage*)smartPageWithWordFactory:(ITCWordFactory *)wordFactory;

/**
 *  Creates a new ITCSmartPage. Mandatory for the creation of a new ITCSmartPage
 *  @param wordFactory Word factory to be used for word creation. Can not be `nil`.
 *  @param data        Data from a previous page serialisation.
 *  @return The new ITCSmartPage.
 */
+ (ITCSmartPage*)smartPageWithWordFactory:(ITCWordFactory *)wordFactory fromData:(NSData*)data;

//==================================================================================================
#pragma mark - Getter
//==================================================================================================

/** @name Getter */

/**
 *  Returns the wordFactory associated to the page.
 *  @return The associated wordFactory.
 */
- (ITCWordFactory*)wordFactory;

/**
 * Returns the text of the whole page including line break characters.
 * @return String representation of the text of the whole page.
 */
- (NSString*)text;

/**
 * @return The list of strokes in the page.
 */
- (NSArray*)strokes;

/**
 * @return The list of drawing strokes in the page.
 */
- (NSArray*)drawingStrokes;

/**
 * @return The list of pending strokes in the page.
 * @discussion A pending stroke is a stroke whose recognition by the engine is
 * pending or ongoing
 */
- (NSArray*)pendingStrokes;

/**
 * @return The list of recognition strokes that were recognized (and thus not pending anymore)
 */
- (NSArray*)recognizedStrokes;

/**
 * @return The list of words in the page.
 */
- (NSArray*)words;

/**
 * Returns the `ITCStrokeRange` corresponding to the specified `ITCWordRange`.
 * @param wordRange A word range object.
 * @return Stroke range object or `nil` if the word range is fontified.
 */
- (ITCStrokeRange*)strokeRange:(ITCWordRange*)aWordRange;

/**
 * Returns the `ITCStrokeRange` corresponding to the given page text interval.
 * @param begin Beginning of the interval in the page text.
 * @param end End of the interval in the page text.
 * @return Stroke range associated to the given interval.
 */
- (ITCStrokeRange*)strokeRangeBeginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;

/**
 * Returns the `ITCWordRange` limited to a single character whose bounding box contains the specified point.
 * Some margin is applied to character bounding boxes to be more permissive to users when selecting
 * characters following a single tap.
 * @param x X coordinate of the point.
 * @param y Y coordinate of the point.
 * @return Word range within the page or -1 if the point is outside of any character bounding
 * boxes of a word or falls within a space.
 */
- (ITCWordRange*)wordRangeAtX:(float)anX y:(float)anY;

/**
 * Returns the `ITCWordRange` selected by the specified `ITCStrokeRange`.
 * @param strokeRange A stroke range.
 * @param allowPartialCharacter Boolean that will, if set to `YES`, return a word range even if the stroke range doesn't fully cover a whole character.
 * @return Word range object representing the recognized given stroke range.
 */
- (ITCWordRange*)wordRangeFromStrokeRange:(ITCStrokeRange*)aStrokeRange allowPartialCharacter:(BOOL)allowPartialCharacter;

/**
 * Returns the line number that contains the specified `ITCWordRange`.
 * @param wordRange A word range within the page.
 * @return Line number or -1 if the `ITCWordRange` is corrupted or
 * does not fit on one line only.
 */
- (NSInteger)lineNumberFromWordRange:(ITCWordRange*)aWordRange;

/**
 * Returns the ordered array of words at the specified line number.
 * @param lineNumber A line number in the `ITCSmartPage`
 * @return An array of `ITCSmartWord` objects representing the line words or null for a wrong line number.
 */
- (NSArray*)wordsAtLineNumber:(NSInteger)aLineNumber;

/**
 * Returns the number of lines in the page
 * @return Line number
 */
- (NSInteger)lineCount;

/**
 *  @return Returns the most recent timeStamp in the page
 */
- (NSDate*)endTimeStamp;

//==================================================================================================
#pragma mark - Strokes Management
//==================================================================================================

/** @name Strokes Management */

/**
 * Adds a stroke to the page
 * @discussion If the stroke already belongs to the page, this method does nothing
 * @param stroke The stroke to add
 */
- (void)addStroke:(ITCSmartStroke*)aStroke;

/**
 * Adds a list of strokes to the page
 * @discussion Strokes that already belong to the page will not be added again
 * @param strokes The strokes to add
 */
- (void)addStrokes:(NSArray*)strokes;

/**
 * Removes a stroke from the page
 * @discussion If the stroke is not in the page, this method does nothing
 */
- (void)removeStroke:(ITCSmartStroke*)aStroke;

/**
 * Removes some strokes from the page
 * @discussion The strokes that are not in the page will be ignored
 */
- (void)removeStrokes:(NSArray*)strokes;

//==================================================================================================
#pragma mark - Words Management
//==================================================================================================

/** @name Words Management */

/**
 * Adds a word to the page
 *
 * @param word Word to add to the page.
 */
- (void)addWord:(ITCSmartWord*)word;

/**
 * Adds an array of words to the page
 *
 * @param word NSArray of words to add to the page.
 */
- (void)addWords:(NSArray*)words;

/**
 * Removes a word from the page.
 *
 * @param word Word to remove from the page.
 */
- (void)removeWord:(ITCSmartWord*)word;
/**
 * Removes several words from the page at once.
 *
 * @param words An array of words to remove from the page.
 */
- (void)removeWords:(NSArray*)words;

/**
 * Replace a word with another word in the current page
 *
 * @param oldWord ITCSmartWord to remove from the page.
 * @param newWord ITCSmartWord to add to the page.
 */
- (void)replaceWord:(ITCSmartWord*)oldWord withNewWord:(ITCSmartWord *)newWord;

/**
 * Replace an array of words by another array of words in the current page
 *
 * @param oldWord array of ITCSmartWord to remove from the page.
 * @param newWord array of ITCSmartWord to add to the page.
 */
- (void)replaceWords:(NSArray*)oldWords withNewWords:(NSArray *)newWords;

//==================================================================================================
#pragma mark - ITF management
//==================================================================================================

/** @name ITF Management */

/**
 * Loads an ITF file from a given path
 * @param aPath The path to the file to load
 * @return `YES` if the file could be properly loaded, `NO` otherwise
 */
- (BOOL)loadITFAtPath:(NSString *)aPath;

/**
 * Loads an ITF file from a given path
 * @param aPath The path to the file to load
 * @param isGestureITF `YES`, to load the gesture of the ITF, `NO` otherwise
 * @return `YES` if the file was properly loaded, `NO` otherwise
 */
- (BOOL)loadITFAtPath:(NSString *)aPath isGestureITF:(BOOL)isGestureITF;

/**
 *  Saves the current page as ITF file at the specified path.
 *  @param aFilepath The path where the file is saved.
 *  @return An error if any, nil otherwise.
 */
- (ITCError *)saveITFAtPath:(NSString *)aPath;

//==================================================================================================
#pragma mark - Clear
//==================================================================================================

/** @name Clear */

/**
 * Removes all page content
 */
- (void)clear;

//==================================================================================================
#pragma mark - Gestures helpers
//==================================================================================================

/** @name Gestures helpers */

/**
 *  Uses in the gesture algorithm (Only use with a `ITCPageInterpreter`).
 */
- (void)penDown;

/**
 *  Uses in the gesture algorithm (Only use with a `ITCPageInterpreter`).
 */
- (void)penAbort;

//==================================================================================================
#pragma mark - Serialisation
//==================================================================================================

/** @name Serialisation */

/**
 * Serialises
 */
- (NSData*)data;

@end
