// Copyright MyScript. All right reserved.

#import "InkCaptureView.h"
#import "ITCSamplePoint.h"
#import "Stroker.h"

@implementation InkCaptureView
{
    NSTimer *_timerBeforeCreatingStrokeView;
    
    NSDate *_startStrokeDate;
    NSDate *_endStrokeDate;
    Stroker *_stroker;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _stroker = [[Stroker alloc]init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _stroker = [[Stroker alloc]init];
    }
    return self;
}

//----------------------------------
#pragma mark Getter/Setter
//----------------------------------

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _stroker.strokeColor = strokeColor;
}

- (UIColor *)strokeColor
{
    return _stroker.strokeColor;
}

//----------------------------------
#pragma mark Touches events
//----------------------------------

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self strokeBeganForPoint:[touch locationInView:self] withDraw:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(inkCaptureViewDidTouchBegan:)])
        [_delegate inkCaptureViewDidTouchBegan:self];
}

- (void)strokeBeganForPoint:(CGPoint)point withDraw:(BOOL)isDraw
{
    _startStrokeDate = [NSDate date];
    
    [_stroker beginStrokeWithPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self strokeMovedForPoint:p withDraw:YES];
}

- (void)strokeMovedForPoint:(CGPoint)point withDraw:(BOOL)isDraw
{
    [_stroker continueStrokeWithPoint:point];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self strokeEndedForPoint:p withDraw:YES];
    [self createStrokeView:YES];
    
    [self setNeedsDisplay];
    
    if (_delegate && [_delegate respondsToSelector:@selector(inkCaptureViewDidTouchEnd:)])
        [_delegate inkCaptureViewDidTouchEnd:self];
}

- (void)strokeEndedForPoint:(CGPoint)point withDraw:(BOOL)isDraw
{
    [_stroker endStrokeWithPoint:point];

    _endStrokeDate = [NSDate date];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

//----------------------------------
#pragma mark Draw rect methods
//----------------------------------

- (void)drawRect:(CGRect)rect
{
    [_stroker draw];
}

- (ITCSampleStroke *)createStrokeView:(BOOL)startReco
{
    CGRect frame = [_stroker frameFromCurrentDrawing];
    
    ITCSampleStroke *stroke = [[ITCSampleStroke alloc] init];
    stroke.path = [UIBezierPath bezierPathWithCGPath:_stroker.path.CGPath];
    stroke.color = _stroker.strokeColor;
    stroke.lineWidth = _stroker.lineWidth;
    stroke.frame = frame;
    stroke.points = _stroker.samplePoints;
    stroke.startStrokeDate = _startStrokeDate;
    stroke.endStrokeDate = _endStrokeDate;
    
    if (_delegate && startReco)
    {
        [_delegate inkCaptureView:self didCreatePoints:_stroker.points stroke:stroke startReco:startReco];
    }
    
    [_stroker clear];
    
    return stroke;
}

@end
