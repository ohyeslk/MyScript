// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>

/**
 * Object representing a transformation applied on the strokes.
 * Do not inherit
 */
@interface ITCTransform : NSObject

+ (ITCTransform*)smartPageWithWordFactoryWithScaleX:(float)xSc scaleY:(float)ySc translateX:(float)xTr translateY:(float)yTr;

+ (ITCTransform*)smartPageWithWordFactoryWithScaleX:(float)xSc scaleY:(float)ySc translateX:(float)xTr translateY:(float)yTr shearingX:(float)xSh shearingY:(float)ySh;

@property (nonatomic, assign) float xScale;
@property (nonatomic, assign) float yScale;
@property (nonatomic, assign) float xTranslation;
@property (nonatomic, assign) float yTranslation;
@property (nonatomic, assign) float xShear;
@property (nonatomic, assign) float yShear;


/**
 *  Combines this transform with a translation.
 *
 *  @param dx The x translation
 *  @param dy The y translation
 */
- (void)translateWithX:(float)dx y:(float)dy;

/**
 *  Combines this transform with a scale.
 *
 *  @param dx The x scale
 *  @param dy The y scale
 */
- (void)scaleWithX:(float)dx y:(float)dy;

/**
 *  Combines this transform with a shearing.
 *
 *  @param dx The x shear
 *  @param dy The y shear
 */
- (void)shearWithX:(float)dx y:(float)dy;

/**
 *  Combines this transform with a rotation.
 *
 *  @param angle The angle to rotate
 */
- (void)rotationWithAngle:(float)angle;

/**
 *
 *  @return Gives the x/y scale ratio coefficient multiplicator for a slope.
 */
- (float)scaleRatio;

/**
 *
 *  @return YES if it is a matrix identity
 */
- (BOOL)isIdentity;

/**
 *
 *  @return YES if this transfom is invertible (i.e. its determinant is not null).
 */
- (BOOL)isInvertible;

/**
 *  Returns a transform which is the inverse of this transform.
 */
- (void)inverted;

/**
 *  Returns this transform applied to the given transform.
 *
 *  @param itcTransform The other matrix to applied to the current one.
 */
- (void)appliedTransform:(ITCTransform *)itcTransform;


@end
