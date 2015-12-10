// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import <AtkItc/ITC.h>

@interface ITCSampleGestureData : NSObject

@property (nonatomic, assign) ITCGestureType gestureType;
@property (nonatomic, assign) BOOL isEnable;
@property (nonatomic, assign) BOOL isDefaultProcessing;

@end
