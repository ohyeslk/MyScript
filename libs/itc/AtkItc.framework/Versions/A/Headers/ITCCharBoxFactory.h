// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

#import "ITCCharBoxFactoryProtocol.h"

/**
 *  Default implementation of the `ITCCharBoxFactoryProtocol`.
 */
@interface ITCCharBoxFactory : NSObject<ITCCharBoxFactoryProtocol>

/**
 *  The font used by ITC to calculate the boxes of characters.
 */
@property (nonatomic, strong) UIFont *font;

@end
