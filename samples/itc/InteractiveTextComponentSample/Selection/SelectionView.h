// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import "StrokeView.h"
#import "ITCSampleWord.h"

@class SelectionView;

@protocol SelectionViewDelegate <NSObject>

@optional
- (void)selectionView:(SelectionView *)selectionView changeCandidateIndex:(int)candidateIndex ForSampleWord:(ITCSampleWord *)sampleWord;
- (void)selectionView:(SelectionView *)selectionView typesetForSampleWord:(ITCSampleWord *)sampleWord;

@end

@interface SelectionView : UIView

//@property (nonatomic, strong) NSMutableArray *strokeViews;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, strong) NSMutableArray *sampleWords;
@property (nonatomic, weak) id<SelectionViewDelegate> delegate;

- (void)draw;
//- (void)addStrokeView:(StrokeView *)strokeView;
- (void)addSampleWord:(ITCSampleWord *)sampleWord;

@end
