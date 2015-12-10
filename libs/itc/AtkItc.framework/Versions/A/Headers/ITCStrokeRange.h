// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCSmartStroke.h"

/**
 *  Object representing a range of `ITCSmartStroke`s.
 *
 *  Do not inherit
 */
@interface ITCStrokeRange : NSObject

/** Strokes referenced by ranges. */
@property (nonatomic, strong, readonly) NSArray *strokes;
/** Indexes of the first point of a range within a stroke. */
@property (nonatomic, strong, readonly) NSArray *beginIndexes;
/** Indexes of the last point of a range within a stroke. */
@property (nonatomic, strong, readonly) NSArray *endIndexes;

/**
 * Creates a `ITCSmartStroke` range from the given Stroke.
 * @param stroke A `ITCSmartStroke` to create the stroke range with.
 */
+ (ITCStrokeRange*)strokeRangeWithStroke:(ITCSmartStroke*)aStroke;

/**
 * Creates a stroke range from the entire given `ITCSmartStroke` array.
 * @param strokes A stroke array used to create the stroke range.
 */
+ (ITCStrokeRange*)strokeRangeWithStrokes:(NSArray*)strokes;

/**
 * Creates a stroke range from the given `ITCSmartStroke` array.
 * @param strokes A stroke array used to create the stroke range.
 * @param begin Start indexes to consider among stroke points.
 * @param end End index to consider among stroke points.
 */
+ (ITCStrokeRange*)strokeRangeWithStrokes:(NSArray*)strokes beginIndexes:(NSArray*)beginIndexes endIndexes:(NSArray*)endIndexes;

/**
 *  Adds a `ITCSmartStroke` in the stroke range.
 *
 *  @param aStroke The `ITCSmartStroke` to add.
 */
- (void)addStroke:(ITCSmartStroke*)aStroke;

/**
 *  Adds a `ITCSmartStroke` in the stroke range.
 *
 *  @param aStroke       The `ITCSmartStroke` to add.
 *  @param beginIndex Begin index of the stroke to add.
 *  @param endIndex   End index of the stroke to add.
 */
- (void)addStroke:(ITCSmartStroke*)aStroke beginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;

/**
 *  Clears the stroke range.
 */
- (void)clear;

@end
