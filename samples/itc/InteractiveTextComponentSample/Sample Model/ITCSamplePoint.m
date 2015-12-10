// Copyright MyScript. All right reserved.

#import "ITCSamplePoint.h"

@implementation ITCSamplePoint

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    int index = 0;
    for (NSValue *value in _points)
    {
        NSString *key = [NSString stringWithFormat:@"point%d",index];
        [aCoder encodeObject:value forKey:key];
        index++;
    }
    [aCoder encodeObject:@(index) forKey:@"pointsCount"];
}

- (instancetype)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self)
    {
        _points = [NSMutableArray array];
        
        int pointsCount = [[aCoder decodeObjectForKey:@"pointsCount"] intValue];
        
        for (int index = 0; index < pointsCount; index++)
        {
            NSString *key = [NSString stringWithFormat:@"point%d",index];
            [_points addObject:[aCoder decodeObjectForKey:key]];
        }
        
    }
    return self;
}

@end
