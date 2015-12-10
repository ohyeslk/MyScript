// Copyright MyScript. All right reserved.

#import "Stroker.h"
#import "ITCSamplePoint.h"

@interface Stroker ()

@end

@implementation Stroker
{
    // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    CGPoint _pts[5];
    uint _ctr;
    
    NSMutableArray *_internPoints;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        _path = [UIBezierPath bezierPath];
        [_path setLineWidth:2.0];
        
        _strokeColor = [UIColor blackColor];
    }
    return self;
}

//----------------------------------
#pragma mark Getter
//----------------------------------

- (CGFloat)lineWidth
{
    return _path.lineWidth;
}

//----------------------------------
#pragma mark Methods
//----------------------------------

- (NSMutableArray *)samplePoints
{
    return [self calculateRealPointsWithFrame:[self frameFromCurrentDrawing]];
}

- (void)beginStrokeWithPoint:(CGPoint)point
{
    [_path removeAllPoints];
    
    _ctr = 0;
    
    _pts[0] = point;
    _internPoints = [NSMutableArray array];
    
    _points = [NSMutableArray array];
    [_points addObject:[NSValue valueWithCGPoint:_pts[0]]];
}

//----------------------------------
#pragma mark Utils
//----------------------------------

- (void)continueStrokeWithPoint:(CGPoint)point
{
    _ctr++;
    
    _pts[_ctr] = point;
    [_points addObject:[NSValue valueWithCGPoint:point]];
    if (_ctr == 4)
    {
        _pts[3] = CGPointMake((_pts[2].x + _pts[4].x)/2.0, (_pts[2].y + _pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        [_path moveToPoint:_pts[0]];
        [_path addCurveToPoint:_pts[3] controlPoint1:_pts[1] controlPoint2:_pts[2]];
        
        ITCSamplePoint *itcPoint = [[ITCSamplePoint alloc] init];
        itcPoint.points = [self transformPointsToArray];
        [_internPoints addObject:itcPoint];
        
        // replace points and get ready to handle the next segment
        _pts[0] = _pts[3];
        _pts[1] = _pts[4];
        
        _ctr = 1;
    }
}

- (void)endStrokeWithPoint:(CGPoint)point
{
    [_points addObject:[NSValue valueWithCGPoint:point]];
    
    // if counter at 0, none moved touches, so make it a point (or a small line)
    if (_ctr < 4)
    {
        // add some room to make a point
        _pts[1] = CGPointMake(point.x + 1, point.y + 1);
        
        [_path moveToPoint:_pts[0]];
        [_path addLineToPoint:_pts[1]];
        
        _ctr += 2;
        
        ITCSamplePoint *itcPoint = [[ITCSamplePoint alloc] init];
        itcPoint.points = [self transformPointsToArray];
        [_internPoints addObject:itcPoint];
    }
    _ctr = 0;
}

- (void)draw
{
    if (!CGPathIsEmpty(_path.CGPath))
    {
        [_strokeColor setStroke];
        [_path stroke];
    }
}

- (void)clear
{
    [_path removeAllPoints];
}

- (CGRect)frameFromCurrentDrawing
{
    return CGRectMake(_path.bounds.origin.x - (_path.lineWidth/2), _path.bounds.origin.y - (_path.lineWidth/2), _path.bounds.size.width + _path.lineWidth, _path.bounds.size.height + _path.lineWidth);
}

//----------------------------------
#pragma mark Utils
//----------------------------------

- (NSMutableArray *)transformPointsToArray
{
    NSMutableArray *localPoints = [NSMutableArray array];
    for (int i =0; i < _ctr; i++)
    {
        NSValue *value = [NSValue valueWithCGPoint:_pts[i]];
        [localPoints addObject:value];
    }
    
    return localPoints;
}

- (NSMutableArray *)calculateRealPointsWithFrame:(CGRect)frame
{
    NSMutableArray *newPoints = [NSMutableArray array];
    ITCSamplePoint *newITCPoint;
    for (ITCSamplePoint *itcPoint in _internPoints)
    {
        newITCPoint = [[ITCSamplePoint alloc] init];
        
        NSMutableArray *cgPoints = [NSMutableArray array];
        for (NSValue *value in itcPoint.points)
        {
            CGPoint point = [value CGPointValue];
            CGPoint newPoint = CGPointMake(point.x - frame.origin.x, point.y - frame.origin.y);
            [cgPoints addObject:[NSValue valueWithCGPoint:newPoint]];
        }
        
        newITCPoint.points = cgPoints;
        [newPoints addObject:newITCPoint];
    }
    
    return newPoints;
}

@end
