// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * This class is a wrapper above the `CGRect`.
 * This class can be stored in array.
 */
@interface ITCRect : NSObject

@property (nonatomic, assign, readonly) float x;
@property (nonatomic, assign, readonly) float y;
@property (nonatomic, assign, readonly) float width;
@property (nonatomic, assign, readonly) float height;
@property (nonatomic, assign, readonly) CGRect cgRect;

/**
 *  Creates an ITCRect with the given values.
 *  @param x      The top left corner abcissa.
 *  @param y      The top left corner ordinate.
 *  @param width  The width of the rectangle.
 *  @param height The height of the rectangle.
 *  @return The new ITCRect created.
 */
- (id)initWithX:(float)x y:(float)y width:(float)width height:(float)height;

@end
