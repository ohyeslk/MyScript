// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import "StrokeView.h"
#import "ITCSampleStroke.h"

@class InkCaptureView;

@protocol InkCaptureDelegate <NSObject>

@required
- (void)inkCaptureViewDidTouchBegan:(InkCaptureView *)inkCaptureView;
- (void)inkCaptureViewDidTouchEnd:(InkCaptureView *)inkCaptureView;
- (void)inkCaptureView:(InkCaptureView *)inkCaptureView didCreatePoints:(NSArray *)points stroke:(ITCSampleStroke *)itcStroke startReco:(BOOL)startReco;

@end

@interface InkCaptureView : UIView

@property (nonatomic, strong) id<InkCaptureDelegate> delegate;
@property (nonatomic, strong) UIColor *strokeColor;

- (void)strokeBeganForPoint:(CGPoint)point withDraw:(BOOL)isDraw;
- (void)strokeMovedForPoint:(CGPoint)point withDraw:(BOOL)isDraw;
- (void)strokeEndedForPoint:(CGPoint)point withDraw:(BOOL)isDraw;
- (ITCSampleStroke *)createStrokeView:(BOOL)startReco;

@end
