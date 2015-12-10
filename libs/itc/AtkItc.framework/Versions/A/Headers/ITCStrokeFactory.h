// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCSmartStroke.h"
#import "ITCUserParams.h"
#import "ITCStrokeUserParamsFactoryProtocol.h"
#import "ITCTransform.h"

/**
 * Object in charge of the creation of `ITCSmartStroke`.
 * Do not inherit
 */
@interface ITCStrokeFactory : NSObject

/**
 * Creates a new ITCStrokeFactory.
 *
 * @param userParamsFactory the strokeUserParamsFactory for the current word factory.
 * Object can be `nil` if you do not use `ITCUserParams`.
 *
 * @return The new ITCStrokeFactory
 */
+ (id)strokeFactory:(id<ITCStrokeUserParamsFactoryProtocol>)userParamsFactory;

/**
 *  Creates a new `ITCSmartStroke`
 *
 *  @param xPoints        An array of NSNumber of the x points
 *  @param yPoints        An array of NSNumber of the y points
 *  @param startTimestamp The timestamp (milliseconds since 1970) of the beginning of the drawing
 *  @param endTimestamp   The timestamp (milliseconds since 1970) of the end of the drawing
 *  @param userParams     The UserParams associated (custom objects)
 *  @param strokeType     The `ITCStrokeType`
 *
 *  @return The new `ITCSmartStroke`
 */
- (ITCSmartStroke *)createStrokeWithX:(NSArray *)xPoints y:(NSArray *)yPoints startTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp userParams:(id<ITCUserParams>)userParams strokeType:(ITCStrokeType)strokeType;

/**
 * Creates a sub `ITCSmartStroke` from the given stroke. This way of creating a stroke is mainly used
 *  when gestures occur but could also be used in case of copy(cut)/paste feature.
 * @param stroke The original stroke to copy
 * @param begin The index of start to create the new stroke from the old one
 * @param end The index of end to create the new stroke
 * @param strokeType The type of the stroke that will be created
 * @return The `ITCSmartStroke` created
 */
- (ITCSmartStroke *)createSubStroke:(ITCSmartStroke *)stroke beginIndex:(NSInteger)begin endIndex:(NSInteger)end strokeType:(ITCStrokeType)strokeType;

/**
 * Creates a copy of the given `ITCSmartStroke`. Be careful to choose the right stroke type depending on
 * whether this stroke shall be recognized or not, once added to a page
 * @param stroke     The original stroke to copy
 * @param strokeType The type of the stroke that will be created
 * @return The copied `ITCSmartStroke`
 */
- (ITCSmartStroke *)createCopyOfStroke:(ITCSmartStroke *)stroke strokeType:(ITCStrokeType)strokeType;

/**
 * Creates a `ITCSmartStroke` stroke with the given translation values.
 * to add it to the page. Be careful to choose the right ITCStrokeType to launch recognition.
 * @param dx Amount in the X direction to offset the stroke.
 * @param dy Amount in the Y direction to offset the stroke.
 * @param strokeType Type of the stroke to be created.
 * @return `ITCSmartStroke` moved.
 */
- (ITCSmartStroke *)createMovedStroke:(ITCSmartStroke *)stroke offsetX:(NSInteger)offsetX offsetY:(NSInteger)offsetY strokeType:(ITCStrokeType)strokeType;

/**
 * Creates a `ITCSmartStroke` with the given scale values to add it to the page. Be careful to choose the right SmartStroke to launch recognition.
 * @param SmartStroke The previous stroke used to create a copy.
 * @param scale The scale applied to the previous stroke.
 * @param strokeType Type of the stroke to be created.
 * @return `ITCSmartStroke` scaled.
 */
- (ITCSmartStroke *)createScaledStroke:(ITCSmartStroke *)stroke scaleX:(float)scaleX scaleY:(float)scaleY strokeType:(ITCStrokeType)strokeType;

/**
 * Creates a `ITCSmartStroke` with the given transformed values to add it to the page. Be careful to choose the right SmartStroke to launch recognition.
 * @param SmartStroke The previous stroke used to create a copy.
 * @param scale The transform applied to the previous stroke.
 * @param strokeType Type of the stroke to be created.
 * @return `ITCSmartStroke` transformed.
 */
- (ITCSmartStroke *)createTransformedStroke:(ITCSmartStroke *)stroke transform:(ITCTransform *)transform strokeType:(ITCStrokeType)strokeType;

/**
 * Creates a `ITCSmartStroke` with the new user params
 * @param SmartStroke The previous stroke used to create a copy.
 * @param userParams The User parameters to be associated with the new stroke
 * @return `ITCSmartStroke` created with the user params.
 */
- (ITCSmartStroke *)createStrokeWithUserParams:(ITCSmartStroke *)stroke userParams:(id<ITCUserParams>)userParams;

/**
 * Creates a `ITCSmartStroke` with the new user params
 * @param data The data serialized.
 * @return `ITCSmartStroke` created with the data.
 */
- (ITCSmartStroke *)createStrokeFromData:(NSData *)data;

@end
