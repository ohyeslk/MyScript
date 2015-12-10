// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ITCRect.h"

/**
 *  This protocols needs to be implemented when you want to use your own CharBoxFactory.
 *  All methods are required.
 */
@protocol ITCCharBoxFactoryProtocol <NSObject>

@required

/**
 *
 * Returns the distance above the baseline based on the current typeface and text size.
 *
 * @return the distance above the baseline based on the current typeface and text size.
 */
- (float)ascent;

/**
 *
 * Returns in bounds the smallest rectangle that encloses all of the characters, with an
 * implied origin at (0,0).
 *
 * @param label String to measure and return its bounds
 * @param index Index of the first char in the string to measure
 * @param count
 * @return bounds
 */
- (CGRect)textBoundsWithLabel:(NSString *)label index:(NSInteger)index count:(NSInteger)count;

/**
 * Returns the midline shift for the given text.
 * @return float The midline shift for the given text.
 */
- (float)midlineShift;

/**
 *
 * Returns the space width for the given text.
 * @return The space width for the given text.
 */
- (float)spaceWidth;

@end
