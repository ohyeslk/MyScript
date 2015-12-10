// Copyright MyScript. All right reserved.

#import "PageView.h"

@implementation PageView
{
    BOOL _isGuidelinesShowed;
    BOOL _isInit; // used to know if the PageView is already init (for drawRect:)
    NSInteger _numberOfLines;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _strokeViews = [NSMutableArray array];
        _candidatesViews = [NSMutableArray array];
        _underlineStrokesViews = [NSMutableArray array];
        _wordViews = [NSMutableArray array];
        _isGuidelinesShowed = NO;
        _isCandidateShowed = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_isGuidelinesShowed)
    {
        CGRect targetRect = self.bounds;
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 1.0/ [[UIScreen mainScreen] scale]);
        CGContextSetStrokeColorWithColor(context, ITC_GUIDELINE_COLOR.CGColor);
        CGFloat pxLineSpacing = ITC_GUIDELINE_SPACING;
        CGFloat marginTop = ITC_GUIDELINE_MARGIN_TOP;
        
        int i;
        for (i = 0; i <= _numberOfLines; i ++)
        {
            CGContextMoveToPoint(context, targetRect.origin.x, roundf(targetRect.origin.y + i * pxLineSpacing) + 0.5 + marginTop);
            CGContextAddLineToPoint(context, targetRect.origin.x + targetRect.size.width, roundf(targetRect.origin.y + i * pxLineSpacing) + 0.5 + marginTop);
            CGContextStrokePath(context);
        }
    }
    
    _isInit = YES;
}

- (NSInteger)lineCount
{
    CGFloat pxLineSpacing = ITC_GUIDELINE_SPACING;
    CGFloat marginTop = ITC_GUIDELINE_MARGIN_TOP;
    _numberOfLines = (self.bounds.size.height-marginTop) / pxLineSpacing;
    
    return _numberOfLines;
}

//----------------------------------
#pragma mark StrokeViews
//----------------------------------

- (void)addStrokeView:(StrokeView *)strokeView
{
    [_strokeViews addObject:strokeView];
    [self addSubview:strokeView];
}

- (BOOL)isStrokeViewPresent:(StrokeView *)strokeView
{
    for (StrokeView *currentStrokeView in _strokeViews)
    {
        if ([currentStrokeView isEqual:strokeView])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)removeSrokeViewFromStroke:(ITCSmartStroke *)smartStroke;
{
    StrokeView *strokeView = [self strokeViewFromStroke:smartStroke];
    
    if (strokeView != nil)
    {
        [strokeView removeFromSuperview];
        [_strokeViews removeObject:strokeView];
    }
}

- (StrokeView *)strokeViewFromStroke:(ITCSmartStroke *)smartStroke
{
    for (StrokeView *strokeView in _strokeViews)
    {
        if ([strokeView.stroke isEqual:smartStroke])
        {
            return strokeView;
        }
    }
    
    return nil;
}

- (StrokeView *)strokeViewForPosition:(CGPoint)point
{
    for (StrokeView *strokeView in _strokeViews)
    {
        if (CGRectContainsPoint(strokeView.frame, point))
        {
            return strokeView;
        }
    }
    
    return nil;
}

- (void)removeAllStrokesView
{
    for (StrokeView *strokeView in _strokeViews)
    {
        [strokeView removeFromSuperview];
    }
    
    [_strokeViews removeAllObjects];
}

//----------------------------------
#pragma mark CandidateViews
//----------------------------------

- (void)addCandidateView:(CandidateView *)candidateView
{
    [_candidatesViews addObject:candidateView];
    
    if (_isCandidateShowed)
        [self addSubview:candidateView];
}

- (void)removeAllCandidatesView
{
    [self hideAllCandidatesView];
    
    [_candidatesViews removeAllObjects];
}

- (void)hideAllCandidatesView
{
    for (CandidateView *candidateView in _candidatesViews)
    {
        [candidateView removeFromSuperview];
    }
}

- (void)removeCandidate:(CandidateView *)candidateView
{
    [candidateView removeFromSuperview];
    [_candidatesViews removeObject:candidateView];
}

//----------------------------------
#pragma mark Guide lines
//----------------------------------
- (void)showGuidelines:(BOOL)showGuidelines
{
    _isGuidelinesShowed = showGuidelines;
    CGFloat pxLineSpacing = ITC_GUIDELINE_SPACING;
    CGFloat marginTop = ITC_GUIDELINE_MARGIN_TOP;
    _numberOfLines = (self.bounds.size.height-marginTop) / pxLineSpacing;
    
    if (_isGuidelinesShowed)
    {
        if (_delegate && _isInit)
            [_delegate pageView:self DidShowGuidelines:YES firstLinePosition:ITC_GUIDELINE_MARGIN_TOP gap:ITC_GUIDELINE_SPACING numberLines:_numberOfLines];
    }
    else
    {
        [_delegate pageView:self DidShowGuidelines:NO firstLinePosition:0 gap:0 numberLines:0];
    }

    [self setNeedsDisplay];
}

- (void)showCandidate:(BOOL)showCandidate
{
    _isCandidateShowed = showCandidate;
    
    for (CandidateView *candidateView in _candidatesViews)
    {
        if (!_isCandidateShowed)
            [candidateView removeFromSuperview];
        else
            [self addSubview:candidateView];
    }
}

//----------------------------------
#pragma mark UnderlineStrokeViews
//----------------------------------
- (void)addUnderlineStrokeView:(UnderlineStrokesView *)underlineStrokeView
{
    [_underlineStrokesViews addObject:underlineStrokeView];
    [self addSubview:underlineStrokeView];
}

- (BOOL)removeUnderlineViewFromStrokeView:(StrokeView *)strokeView
{
    for (UnderlineStrokesView *underlineStrokeView in _underlineStrokesViews)
    {
        if ([underlineStrokeView containsStrokeView:strokeView])
        {
            [underlineStrokeView removeFromSuperview];
            [_underlineStrokesViews removeObject:underlineStrokeView];
            return YES;
        }
    }
    return NO;
}

- (void)removeAllUnderlineStrokeView
{
    for (UnderlineStrokesView *underlineStrokeView in _underlineStrokesViews)
    {
        [underlineStrokeView removeFromSuperview];
    }
    
    [_underlineStrokesViews removeAllObjects];
}


//----------------------------------
#pragma mark WordViews
//----------------------------------
- (void)addWordView:(WordView *)wordView
{
    [_wordViews addObject:wordView];
    
    [self addSubview:wordView];
}

- (BOOL)removeWordViewFromWord:(ITCSmartWord *)smartWord
{
    for (WordView *currentWordView in _wordViews)
    {
        if ([currentWordView.word isEqual:smartWord])
        {
            // remove underline for typeset word
            [self removeUnderlineViewFromWordView:currentWordView];
            
            // remove view
            [currentWordView removeFromSuperview];
            [_wordViews removeObject:currentWordView];
            return YES;
        }
    }
    return NO;
}

- (void)removeAllWordViews
{
    for (WordView *wordView in _wordViews)
    {
        [wordView removeFromSuperview];
    }
    
    [_wordViews removeAllObjects];
}

- (WordView *)wordViewForSmartWord:(ITCSmartWord *)word
{
    for (WordView *wordView in _wordViews)
    {
        if ([wordView.word isEqual:word])
            return wordView;
    }
    
    return nil;
}

- (BOOL)removeUnderlineViewFromWordView:(WordView *)wordView
{
    for (UnderlineStrokesView *underlineStrokeView in _underlineStrokesViews)
    {
        if ([underlineStrokeView containsWordView:wordView])
        {
            [underlineStrokeView removeFromSuperview];
            [_underlineStrokesViews removeObject:underlineStrokeView];
            return YES;
        }
    }
    return NO;
}


//----------------------------------
#pragma mark Utils
//----------------------------------
- (void)removeAllViews
{
    [self removeAllStrokesView];
    [self removeAllCandidatesView];
    [self removeAllUnderlineStrokeView];
    [self removeAllWordViews];
}

@end
