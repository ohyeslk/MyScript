// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCSmartWord.h"

/**
 *  Object representing a range of `ITCSmartWord`s.
 *
 *  Do not inherit
 */
@interface ITCWordRange : NSObject

/** words referenced by ranges. */
@property (nonatomic, strong, readonly) NSArray *words;
/** Indexes of the first point of a range within a word. */
@property (nonatomic, strong, readonly) NSArray *beginIndexes;
/** Indexes of the last point of a range within a word. */
@property (nonatomic, strong, readonly) NSArray *endIndexes;

/**
 * Creates a word range from the given word.
 * @param aWord Word used to create the word range.
 */
+ (ITCWordRange*)wordRangeWithWord:(ITCSmartWord*)aWord;

/**
 * Creates a word range from the entire given ITCSmartWord array.
 * @param words A word array used to ceate the word range.
 */
+ (ITCWordRange*)wordRangeWithWords:(NSArray*)words;

/**
 * Creates a word range from the given ITCSmartWord array.
 * @param words A stroke array used to ceate the word range.
 * @param begin Start indexes to consider among word points.
 * @param end End index to consider among word points.
 */
+ (ITCWordRange*)wordRangeWithWord:(ITCSmartWord*)aWord beginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;

/**
 * Creates a word range from the given ITCSmartWord array.
 * @param words A stroke array to create the stroke range with.
 * @param begin Start indexes to consider among word points.
 * @param end End index to consider among word points.
 */
+ (ITCWordRange*)wordRangeWithWords:(NSArray*)words beginIndexes:(NSArray*)beginIndexes endIndexes:(NSArray*)endIndexes;


/**
 *  Add a word in the word range.
 *
 *  @param word The word to add.
 */
- (void)addWord:(ITCSmartWord*)aWord;

/**
 *  Add a word in the word range.
 *
 *  @param word       The word to add.
 *  @param beginIndex Begin index of teh word to add.
 *  @param endIndex   End index of the word to add.
 */
- (void)addWord:(ITCSmartWord*)aWord beginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;

/**
 *  Clear the word range.
 */
- (void)clear;

@end
