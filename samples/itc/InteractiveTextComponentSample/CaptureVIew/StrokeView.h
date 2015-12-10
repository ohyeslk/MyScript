// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import <AtkItc/ITC.h>

@class StrokeView;

@interface StrokeView : UIView

@property (nonatomic, strong) ITCSmartStroke *stroke;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) float lineWidth;

- (void)draw;
- (void)addPoints:(NSArray *)points;

@end
