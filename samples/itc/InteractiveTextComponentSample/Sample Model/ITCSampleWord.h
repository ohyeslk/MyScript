// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import "CandidateView.h"
#import "DataFormatRecognizer.h"
#import <AtkItc/ITC.h>

@interface ITCSampleWord : NSObject

@property (nonatomic, strong) NSMutableArray *strokeViews;
@property (nonatomic, strong) CandidateView *candidateView;
@property (nonatomic, strong) ITCSmartWord *smartWord;

@end
