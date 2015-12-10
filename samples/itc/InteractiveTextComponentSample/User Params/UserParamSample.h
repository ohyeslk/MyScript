// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import <AtkItc/ITC.h>
#import "ITCSampleStroke.h"
#import "DataFormatRecognizer.h"

@interface UserParamSample : NSObject<ITCUserParams>

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *idUserParam;
@property (nonatomic, strong) UIFont *characterFont;
@property (nonatomic, assign) int order;
@property (nonatomic, assign) float lineWidth;
@property (nonatomic, strong) NSArray *itcPoints;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) BOOL isUnderline;
@property (nonatomic, strong) NSString *dataFormatLabel;

- (UserParamSample *)clone;

@end
