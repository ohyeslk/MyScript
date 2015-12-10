// Copyright MyScript. All right reserved.

#import "StrokeView.h"
#import "ITCSamplePoint.h"
#import "UserParamSample.h"

#define STROKE_VIEW_DBG NO

@implementation StrokeView
{
    UIBezierPath *_path;
    UILabel *_lblWord;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initStrokeView];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        [self initStrokeView];
    }
    return self;
}

- (void)initStrokeView
{
    // init logic
    _path = [UIBezierPath bezierPath];
    
    _lineWidth = 1.0;
    
    // init view
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    [_color setStroke];
    [_path setLineWidth:_lineWidth];
    [_path stroke];
}

- (void)draw
{
    if (STROKE_VIEW_DBG)
        [self setBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:0.3]];
    
    [self setNeedsDisplay];
}

- (void)underlineBarStroke
{
    
}

- (void)addPoints:(NSArray *)points
{
    for (ITCSamplePoint *pointCluster in points)
    {
        NSUInteger size = pointCluster.points.count;
        if (size > 3)
        {
            CGPoint firstPoint = [[pointCluster.points objectAtIndex:0] CGPointValue];
            CGPoint controlPoint1 = [[pointCluster.points objectAtIndex:1] CGPointValue];
            CGPoint controlPoint2 = [[pointCluster.points objectAtIndex:2] CGPointValue];
            CGPoint point = [[pointCluster.points objectAtIndex:3] CGPointValue];
            
            [_path moveToPoint:firstPoint];
            [_path addCurveToPoint:point controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        }
        else if (size > 1)
        {
            CGPoint firstPoint = [[pointCluster.points objectAtIndex:0] CGPointValue];
            CGPoint lastPoint = [[pointCluster.points objectAtIndex:1] CGPointValue];
            [_path moveToPoint:firstPoint];
            [_path addLineToPoint:lastPoint];
        }
    }
}

@end
