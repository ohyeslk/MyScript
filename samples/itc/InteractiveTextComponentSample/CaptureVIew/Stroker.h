// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>

@interface Stroker : NSObject

@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic, assign, readonly) CGFloat lineWidth;
@property (nonatomic, strong, readonly) NSMutableArray *samplePoints;
@property (nonatomic, strong, readonly) NSMutableArray *points;
@property (nonatomic, strong, readonly) UIBezierPath *path;


- (void)beginStrokeWithPoint:(CGPoint)point;

- (void)continueStrokeWithPoint:(CGPoint)point;

- (void)endStrokeWithPoint:(CGPoint)point;

- (void)draw;

- (void)clear;

- (CGRect)frameFromCurrentDrawing;

@end
