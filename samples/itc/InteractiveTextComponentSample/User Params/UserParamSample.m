// Copyright MyScript. All right reserved.

#import "UserParamSample.h"

@implementation UserParamSample

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self)
    {
        _color = [aCoder decodeObjectForKey:@"color"];
        _idUserParam = [aCoder decodeObjectForKey:@"idUserPrams"];
        _order = [[aCoder decodeObjectForKey:@"order"] intValue];
        _lineWidth = [[aCoder decodeObjectForKey:@"lineWidth"] floatValue];
        _itcPoints = [aCoder decodeObjectForKey:@"itcPoints"];
        _frame = CGRectFromString([aCoder decodeObjectForKey:@"frame"]);
        _isUnderline = [[aCoder decodeObjectForKey:@"isUnderline"] boolValue];
        _characterFont = [aCoder decodeObjectForKey:@"characterFont"];
        _dataFormatLabel = [aCoder decodeObjectForKey:@"dataFormatLabel"];
    }
    return self;
}

- (UserParamSample *)clone
{
    UserParamSample *userParamSample = [[UserParamSample alloc] init];
    userParamSample.color = [self color];
    userParamSample.idUserParam = [self idUserParam];
    userParamSample.order = [self order];
    userParamSample.lineWidth = [self lineWidth];
    userParamSample.itcPoints = [self itcPoints];
    userParamSample.frame = [self frame];
    userParamSample.isUnderline = [self isUnderline];
    userParamSample.characterFont = [self characterFont];
    userParamSample.dataFormatLabel = [self dataFormatLabel];
    return userParamSample;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_color forKey:@"color"];
    [aCoder encodeObject:_idUserParam forKey:@"idUserParams"];
    [aCoder encodeObject:@(_order) forKey:@"order"];
    [aCoder encodeObject:@(_lineWidth) forKey:@"lineWidth"];
    [aCoder encodeObject:_itcPoints forKey:@"itcPoints"];
    [aCoder encodeObject:NSStringFromCGRect(_frame) forKey:@"frame"];
    [aCoder encodeObject:@(_isUnderline) forKey:@"isUnderline"];
    [aCoder encodeObject:_characterFont forKey:@"characterFont"];
    [aCoder encodeObject:_dataFormatLabel forKey:@"dataFormatLabel"];
}

- (void)setIsUnderline:(BOOL)isUnderline
{
    _isUnderline = isUnderline;
}

- (void)dealloc
{
//    NSLog(@"dealloc %@", self);
}

@end
