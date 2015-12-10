// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import "StrokeView.h"
#import "CandidateView.h"
#import "UnderlineStrokesView.h"
#import "WordView.h"

@class PageView;

@protocol PageViewDelegate <NSObject>

@required
- (void)pageView:(PageView *)pageView DidShowGuidelines:(BOOL)showGuidelines firstLinePosition:(CGFloat)firstLinePosition gap:(CGFloat)gap numberLines:(int)lines;

@end

@interface PageView : UIView

@property (nonatomic, weak) id<PageViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *strokeViews;
@property (nonatomic, strong) NSMutableArray *candidatesViews;
@property (nonatomic, strong) NSMutableArray *underlineStrokesViews;
@property (nonatomic, strong) NSMutableArray *wordViews;
@property (nonatomic, assign) BOOL isCandidateShowed;
@property (nonatomic, assign, readonly) NSInteger lineCount;


//----------------------------------
#pragma mark StrokeViews
//----------------------------------

- (void)addStrokeView:(StrokeView *)strokeView;
- (BOOL)isStrokeViewPresent:(StrokeView *)strokeView;
- (void)removeSrokeViewFromStroke:(ITCSmartStroke *)smartStroke;
- (StrokeView *)strokeViewForPosition:(CGPoint)point;
- (StrokeView *)strokeViewFromStroke:(ITCSmartStroke *)smartStroke;
- (void)removeAllStrokesView;

//----------------------------------
#pragma mark CandidateViews
//----------------------------------

- (void)addCandidateView:(CandidateView *)candidateView;
- (void)removeAllCandidatesView;
- (void)hideAllCandidatesView;
- (void)removeCandidate:(CandidateView *)candidateView;

- (void)showGuidelines:(BOOL)showGuidelines;
- (void)showCandidate:(BOOL)showCandidate;

//----------------------------------
#pragma mark UnderlineStrokeViews
//----------------------------------

- (void)addUnderlineStrokeView:(UnderlineStrokesView *)underlineStrokeView;
- (BOOL)removeUnderlineViewFromStrokeView:(StrokeView *)strokeView;
- (void)removeAllUnderlineStrokeView;


//----------------------------------
#pragma mark WordViews
//----------------------------------

- (void)addWordView:(WordView *)wordView;
- (BOOL)removeWordViewFromWord:(ITCSmartWord *)smartWord;
- (void)removeAllWordViews;
- (WordView *)wordViewForSmartWord:(ITCSmartWord *)word;
- (BOOL)removeUnderlineViewFromWordView:(WordView *)wordView;

//----------------------------------
#pragma mark Utils
//----------------------------------

- (void)removeAllViews;

@end
