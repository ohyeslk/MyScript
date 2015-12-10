// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "ITCUserParams.h"
#import "ITCRect.h"

/**
 *  The differents kinds of stroke.
 *
 */
typedef NS_ENUM(NSInteger, ITCStrokeType)
{
  /** Drawing stroke (will not be recognized) */
  ITCStrokeTypeDrawingStroke,
  /** Recognition stroke (will be recognized) */
  ITCStrokeTypeRecognitionStroke
};

/**
 *  This class is the representation of the stroke in Interactive Text Component.
 
 *  Do not inherit
 */
@interface ITCSmartStroke : NSObject

//==================================================================================================
#pragma mark - Type
//==================================================================================================

/** @name Type */

/**
 *  @return The type of stroke.
 */
- (ITCStrokeType)strokeType;

//==================================================================================================
#pragma mark - Geometry
//==================================================================================================

/** @name Geometry */

/**
 *  @return The array of x coordinates for this stroke.
 */
- (NSArray *)x;

/**
 *  @return The array of y coordinates for this stroke.
 */
- (NSArray *)y;

/**
 *  @return The count of the points array
 */
- (NSInteger)pointsCount;

/**
 *  @return The bounding rectangle of this stroke.
 */
- (ITCRect *)boundingRect;

//==================================================================================================
#pragma mark - TimeStamp
//==================================================================================================

/** @name TimeStamp */

/**
 *  @return The timeStamp (milliseconds) at the start of this stroke.
 */
- (NSTimeInterval)startTimeStamp;
/**
 *  @return The timeStamp (milliseconds) at the end of this stroke.
 */
- (NSTimeInterval)endTimeStamp;

//==================================================================================================
#pragma mark - User Params
//==================================================================================================

/** @name User Params */

/**
 *  @return The user params associated to this stroke
 */
- (id<ITCUserParams>)userParams;

//==================================================================================================
#pragma mark - Serialisation
//==================================================================================================

/** @name Serialisation */

/**
 *  Create a data object from the stroke
 *
 *  @return The serialized data from the stroke.
 */
- (NSData *)data;

//==================================================================================================
#pragma mark - Utils
//==================================================================================================

/** @name Utils */

/**
 *  @return `YES` if the stroke is empty
 */
- (BOOL)isEmpty;

@end
