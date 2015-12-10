// Copyright MyScript. All right reserved.

#import "CandidateView.h"

@implementation CandidateView
{
  UILabel *_lblCandidate;
  NSString *_candidate;
}

- (id)initWithCandidate:(NSString *)candidateWord
{
    self = [super init];
    if (self) {
        _candidate = candidateWord;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initView
{
    _lblCandidate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_lblCandidate setText:_candidate];
    [_lblCandidate setTextColor:TOOLBAR_TINT_COLOR];
    [_lblCandidate setBackgroundColor:[UIColor clearColor]];
    [_lblCandidate setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_lblCandidate];
}

@end
