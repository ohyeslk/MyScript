// Copyright MyScript. All right reserved.

#import "StrokeUserParamsFactorySample.h"
#import "UserParamSample.h"

@implementation StrokeUserParamsFactorySample

- (id<ITCUserParams>)createUserParamsForStroke:(ITCSmartStroke *)newStroke oldStroke:(ITCSmartStroke *)oldStroke
{
    // return nil or at least remove userParam.itcPoints
    UserParamSample *userParam = [(UserParamSample *)oldStroke.userParams clone];
    userParam.itcPoints = nil;
    return userParam;
}

- (id<ITCUserParams>)createUserParamsForSubStroke:(ITCSmartStroke *)newStroke oldStroke:(ITCSmartStroke *)oldStroke begin:(NSInteger)begin end:(NSInteger)end
{
    // return nil or at least remove userParam.itcPoints
    UserParamSample *userParam = [(UserParamSample *)oldStroke.userParams clone];
    userParam.itcPoints = nil;
    return userParam;
}

- (id<ITCUserParams>)createUserParamsForTransformedStroke:(ITCSmartStroke *)newStroke oldStroke:(ITCSmartStroke *)oldStroke transform:(ITCTransform *)transform
{
    // return nil or at least remove userParam.itcPoints
    UserParamSample *userParam = [(UserParamSample *)oldStroke.userParams clone];
    userParam.itcPoints = nil;
    return userParam;
}

@end
