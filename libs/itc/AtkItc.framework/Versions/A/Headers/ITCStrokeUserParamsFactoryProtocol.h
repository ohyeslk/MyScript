// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCUserParams.h"
#import "ITCSmartStroke.h"
#import "ITCTransform.h"

/**
 * This protocol is called from the `ITCStrokeFactory` and from gesture processing.
 * By implementing these methods, you can create a new user param for the new `ITCSmartStroke` from the previous one.
 * 
 * All methods are required.
 */
@protocol ITCStrokeUserParamsFactoryProtocol <NSObject>

@required

/**
 * Creates new user parameters from an old `ITCSmartStroke` for a new stroke.
 * @param newStroke New stroke.
 * @param oldStroke Original stroke.
 * @return Newly created `ITCUserParams`.
 */
- (id<ITCUserParams>)createUserParamsForStroke:(ITCSmartStroke *)newStroke oldStroke:(ITCSmartStroke *)oldStroke;

/**
 * Creates new user parameters from an old `ITCSmartStroke` for a new sub stroke.
 * @param newStroke New stroke.
 * @param oldStroke Original stroke.
 * @param begin The index of the first point within the stroke.
 * @param end The index one past the last point within the stroke.
 * @return Newly created `ITCUserParams`.
 */
- (id<ITCUserParams>)createUserParamsForSubStroke:(ITCSmartStroke *)newStroke oldStroke:(ITCSmartStroke *)oldStroke begin:(NSInteger)begin end:(NSInteger)end;

/**
 * Creates new user parameters from an old `ITCSmartStroke` for a new moved stroke.
 * @param newStroke New stroke.
 * @param oldStroke Original stroke.
 * @param transform The `ITCTransform` object to use for the transformation.
 * @return Newly created `ITCUserParams`.
 */
- (id<ITCUserParams>)createUserParamsForTransformedStroke:(ITCSmartStroke *)newStroke oldStroke:(ITCSmartStroke *)oldStroke transform:(ITCTransform *)transform;

@end
