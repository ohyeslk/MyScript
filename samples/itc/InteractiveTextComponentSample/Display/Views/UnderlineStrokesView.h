// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import "StrokeView.h"
#import "WordView.h"

@interface UnderlineStrokesView : UIView

@property (nonatomic, strong) NSArray *strokeViews;
@property (nonatomic, strong) WordView *wordView;

- (void)updateFrameWithBaseline:(float)baseline;
- (BOOL)containsStrokeView:(StrokeView *)strokeView;
- (BOOL)containsWordView:(WordView *)strokeView;

@end
