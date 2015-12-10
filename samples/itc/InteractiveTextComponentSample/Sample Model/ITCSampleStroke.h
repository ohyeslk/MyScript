// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>

@interface ITCSampleStroke : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSDate *startStrokeDate;
@property (nonatomic, strong) NSDate *endStrokeDate;
@property (nonatomic, assign) CGRect frame;

@end
