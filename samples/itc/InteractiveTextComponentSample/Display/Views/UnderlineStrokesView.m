// Copyright MyScript. All right reserved.

#import "UnderlineStrokesView.h"

#define UNDERLINE_HEIGHT 2

@implementation UnderlineStrokesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateFrameWithBaseline:(float)baseline
{
    CGRect totalFrame = CGRectNull;
    if (_strokeViews)
    {
        for (StrokeView *strokeView in _strokeViews)
        {
            totalFrame = CGRectUnion(totalFrame, strokeView.frame);
        }
    }
    if (_wordView)
        totalFrame = CGRectUnion(totalFrame, _wordView.frame);
    
    // recalcul frame to remove the height of the stroke views
    totalFrame = CGRectMake(totalFrame.origin.x, baseline - UNDERLINE_HEIGHT, totalFrame.size.width, UNDERLINE_HEIGHT);
    
    [self setFrame:totalFrame];
    [self setBackgroundColor:ITC_UNDERLINE_COLOR];
}

- (BOOL)containsStrokeView:(StrokeView *)strokeView
{
    for (StrokeView *currentStrokeView in _strokeViews)
    {
        if ([currentStrokeView isEqual:strokeView])
            return YES;
    }
    return NO;
}

- (BOOL)containsWordView:(WordView *)wordView;
{
    if ([_wordView isEqual:wordView])
        return YES;
    return NO;
}

@end
