// Copyright MyScript. All right reserved.

#import "DisplayViewController.h"

#import "UserParamSample.h"
#import "StrokeView.h"
#import "WordView.h"
#import "UnderlineStrokesView.h"
#import "PageView.h"
#import "SelectionView.h"
#import "Stroker.h"
#import "ViewController.h"

#define MIN_CANDIDATE_VIEW_WIDTH 80

@interface DisplayViewController ()

@end

@implementation DisplayViewController
{
    PageView *_pageView;
    SelectionView *_selectionView;
    NSMutableArray *_itcSampleWords;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageView = [[PageView alloc] initWithFrame:self.view.bounds];
    _pageView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    
    _itcSampleWords = [NSMutableArray array];
    _pageView.isCandidateShowed = YES;
    _pageView.delegate = _viewController;
    [self.view addSubview:_pageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGuidelines:(BOOL)showGuidelines
{
    [_pageView showGuidelines:showGuidelines];
}

- (void)showCandidate:(BOOL)showCandidate
{
    [_pageView showCandidate:showCandidate];
}

- (void)setViewController:(ViewController *)viewController
{
    _viewController = viewController;
    _pageView.delegate = viewController;
}

- (void)setPage:(ITCSmartPage *)page
{
    _page = page;
    if (_page)
    {
        [_pageView removeAllViews];
        [_itcSampleWords removeAllObjects];
        [self drawStrokes:page.strokes];
        [self drawWords:page.words];
    }
}

- (NSInteger)lineCount
{
    return _pageView.lineCount;
}

//----------------------------------
#pragma mark ITCSmartPageChangeDelegate
//----------------------------------

- (void)pageChanged:(ITCSmartPage *)smartPage withAddedStrokes:(NSArray*)addedStrokes andRemovedStrokes:(NSArray*)removedStrokes
{
    // keep strokes list up to date
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        // Added strokes
        [self drawStrokes:addedStrokes];
        
        // removed strokes
        [self removeStrokes:removedStrokes];
    }];
}

- (void)pageChanged:(ITCSmartPage *)smartPage withAddedWords:(NSArray*)addedWords andRemovedWords:(NSArray*)removedWords
{
    // keep words list up to date
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        // remove data format
        [self removeDataFormatsFromUserParams];
        
        // add data format
        [self addDataFormat];
        
        [self removeSelectionView];
        
        // added words
        [self drawWords:addedWords];
        
        // removed words
        [self removeWords:removedWords];
    }];
}

//----------------------------------
#pragma mark Drawing
//----------------------------------

- (void)drawStrokes:(NSArray*)strokes
{
    NSUInteger addedStrokesCount = strokes.count;
    
    // remove selection view
    if (addedStrokesCount > 0)
        [self removeSelectionView];
    
    // added strokes
    for (int i = 0; i < addedStrokesCount;  i++)
    {
        ITCSmartStroke *stroke = [strokes objectAtIndex:i];
        UserParamSample *userParam = (UserParamSample *)stroke.userParams;
        
        StrokeView *strokeView;
        float lineWidth;
        if (userParam != nil && userParam.itcPoints)
        {
            // do some UI stuff
            CGRect strokeViewFrame = userParam.frame;
            
            lineWidth = userParam.lineWidth;
            
            strokeView = [[StrokeView alloc] initWithFrame:strokeViewFrame];
            strokeView.userInteractionEnabled = YES;
            [strokeView addPoints:userParam.itcPoints];
        }
        else
        {
            // default line thickness value
            lineWidth = 2;
            
            // recalcul points. Needed for insert gesture
            ITCSampleStroke *itcSampleStroke = [self calculPointsWithXPoints:stroke.x yPoints:stroke.y andLineWidth:lineWidth];
            
            // update user param
            userParam.frame = itcSampleStroke.frame;
            userParam.itcPoints = itcSampleStroke.points;
            
            strokeView = [[StrokeView alloc] initWithFrame:itcSampleStroke.frame];
            [strokeView addPoints:itcSampleStroke.points];
        }
        if (userParam)
        {
            [strokeView setColor:userParam.color];
        }
        
        strokeView.lineWidth = lineWidth;
        strokeView.stroke = stroke;
        
        // attach stroke to view
        [_pageView addStrokeView:strokeView];
    }
}

- (void)removeStrokes:(NSArray*)strokes
{
    for (int i = 0; i < strokes.count;  i++)
    {
        // get removed stroke
        ITCSmartStroke *stroke = [strokes objectAtIndex:i];
        
        // get stroke view from stroke
        StrokeView *strokeView =  [_pageView strokeViewFromStroke:stroke];
        
        // remove underline view if showed for removed stroke
        [_pageView removeUnderlineViewFromStrokeView:strokeView];
        
        // remove stroke to view
        [_pageView removeSrokeViewFromStroke:stroke];
    }
}

- (void)drawWords:(NSArray*)words
{
    // add words
    NSMutableArray *outdatedWords = [NSMutableArray array];
    NSMutableArray *newWords = [NSMutableArray array];
    for (ITCSmartWord *word in words)
    {
        // if out dated, need to create a new typeset / mix word
        if (word.isOutdatedTypeset)
        {
            ITCSmartWord *newWord;
            if (word.type == ITCWordTypeTypeset)
            {
                [_page.wordFactory.defaultCharBoxFactory setFont:[self fontUsedInWord:word]];
                newWord = [_page.wordFactory createTypeSetWord:word xPosition:word.leftBound yPosition:word.baseLine spaceBefore:word.spaceBefore];
            }
            else // Mix words
            {
                [_page.wordFactory.defaultCharBoxFactory setFont:[self fontUsedInWord:word]];
                NSArray *indexTypesetChars = [self indexTypesetCharsForMixWords:word];
                newWord = [_page.wordFactory createMixWordFromWord:word charIndexTypeset:indexTypesetChars andSpaceBefore:word.spaceBefore];
            }
            [(UserParamSample *)[newWord userParamsForCharacterAtIndex:0] setCharacterFont:_page.wordFactory.defaultCharBoxFactory.font];
            [outdatedWords addObject:word];
            [newWords addObject:newWord];
            
        }
        else
        {
            NSMutableArray *strokeViews = [NSMutableArray array];
            
            CGRect boundingRect = CGRectMake(word.boundingRect.cgRect.origin.x, word.boundingRect.cgRect.origin.y, word.boundingRect.cgRect.size.width, word.boundingRect.cgRect.size.height);
            WordView *wordView = [[WordView alloc] initWithFrame:boundingRect];
            wordView.font = [self fontUsedInWord:word];
            wordView.word = word;
            [_pageView addWordView:wordView];
            
            NSArray *strokes = [word strokes];
            NSUInteger strokesCount = strokes.count;
            // Strokes word
            for (int i = 0; i < strokesCount;  i++)
            {
                ITCSmartStroke *stroke = strokes[i];
                UserParamSample *userParam = (UserParamSample *)stroke.userParams;
                
                StrokeView *strokeView = [_pageView strokeViewFromStroke:stroke];
                if (userParam && ![userParam.dataFormatLabel isEqualToString:@""])
                    [strokeView setColor:TINT_COLOR];
                else
                    if (userParam)
                    {
                        userParam.color = ITC_RECOGNIZED_COLOR;
                        [strokeView setColor:userParam.color];
                        [strokeView setNeedsDisplay];
                    }
                // load itf (no user param)
                    else
                        [strokeView setColor:ITC_RECOGNIZED_COLOR];
                
                if (strokeView)
                    [strokeViews addObject:strokeView];
            }
            
            // get word bounding rect
            CandidateView *candidateView = [self createCandidateViewWithWord:word];
            
            // create new ITCSample word (keep the sample up-to-date)
            ITCSampleWord *itcSampleWord = [[ITCSampleWord alloc] init];
            itcSampleWord.candidateView = candidateView;
            itcSampleWord.strokeViews = strokeViews;
            itcSampleWord.smartWord = word;
            [_itcSampleWords addObject:itcSampleWord];
            
            // check if word was previously underlined
            [self checkUnderline:word];
        }
    }
    
    if (outdatedWords.count > 0)
        [_page replaceWords:outdatedWords withNewWords:newWords];
}

- (void)removeWords:(NSArray*)words
{
    for (ITCSmartWord *word in words)
    {
        // find SampleWord from list
        ITCSampleWord *itcSampleWord = [self iTCSampleWordFromWord:word];
        
        // remove previous candidate if present
        [_pageView removeCandidate:itcSampleWord.candidateView];
        
        [_pageView removeWordViewFromWord:word];
        
        // remove ITCSample word from the list
        [_itcSampleWords removeObject:itcSampleWord];
    }
}

//----------------------------------
#pragma mark Underline
//----------------------------------

- (void)addUnderlineToSmartWord:(ITCSmartWord *)itcSmartWord
{
    NSMutableArray *strokeViews = [NSMutableArray array];
    
    ITCSampleWord *sampleWord = [self iTCSampleWordFromWord:itcSmartWord];
    [strokeViews addObjectsFromArray:sampleWord.strokeViews];
    
    if (sampleWord.smartWord)
    {
        WordView *wordView = [_pageView wordViewForSmartWord:sampleWord.smartWord];
        
        if (wordView)
        {
            // remove underline if exist and do not create a new one
            BOOL isUnderlineRemoved = [_pageView removeUnderlineViewFromWordView:wordView];
            
            // Update user prams for underline for each characters (of the word).
            NSUInteger charsCount = [sampleWord.smartWord charLabels].count;
            for (int i = 0; i < charsCount; i++)
            {
                UserParamSample *userParamSample = [sampleWord.smartWord userParamsForCharacterAtIndex:i];
                [userParamSample setIsUnderline:!isUnderlineRemoved];
            }
            
            if (!isUnderlineRemoved)
            {
                UnderlineStrokesView *underLineView = [[UnderlineStrokesView alloc] init];
                underLineView.wordView = wordView;
                
                float baseline = itcSmartWord.baseLine + (itcSmartWord.midlineShift / 2);
                [underLineView updateFrameWithBaseline:baseline];
                
                [_pageView addUnderlineStrokeView:underLineView];
            }
        }
        
        if ([sampleWord strokeViews].count > 0)
        {
            // remove underline if exist and do not create a new one
            BOOL isUnderlineRemoved = [_pageView removeUnderlineViewFromStrokeView:[[sampleWord strokeViews] objectAtIndex:0]];
            
            // Update user prams for underline for each stroke (of the word).
            for (ITCSmartStroke *stroke in [itcSmartWord strokes])
            {
                UserParamSample *userParamSample = stroke.userParams;
                [userParamSample setIsUnderline:YES];
            }
            
            if (!isUnderlineRemoved)
            {
                UnderlineStrokesView *underLineView = [[UnderlineStrokesView alloc] init];
                underLineView.strokeViews = strokeViews;
                
                float baseline = itcSmartWord.baseLine + (itcSmartWord.midlineShift / 2);
                [underLineView updateFrameWithBaseline:baseline];
                
                [_pageView addUnderlineStrokeView:underLineView];
            }
        }
    }
}

- (void)removeUnderlineToSmartWord:(ITCSmartWord *)word
{
    // Update user prams for underline for each stroke (of the word).
    NSArray *strokes = [word strokes];
    for (ITCSmartStroke *stroke in strokes)
    {
        UserParamSample *userParamSample = stroke.userParams;
        [userParamSample setIsUnderline:NO];
    }
    
    ITCSampleWord *sampleWord = [self iTCSampleWordFromWord:word];
    if (sampleWord.smartWord)
    {
        WordView *wordView = [_pageView wordViewForSmartWord:sampleWord.smartWord];
        
        if (wordView)
        {
            // remove underline if exist and do not create a new one
            [_pageView removeUnderlineViewFromWordView:wordView];
        }
        
        if ([sampleWord strokeViews].count > 0)
        {
            // remove underline if exist and do not create a new one
            [_pageView removeUnderlineViewFromStrokeView:[[sampleWord strokeViews] objectAtIndex:0]];
        }
    }
}

//----------------------------------
#pragma mark Selection
//----------------------------------

- (void)createSelectionForWordRange:(ITCWordRange *)wordRange
{
    // create a selecion rect
    {
        // remove previous selection view
        [self removeSelectionView];
        
        _selectionView = [[SelectionView alloc] init];
        _selectionView.delegate = _viewController;
        NSMutableArray *allFrames = [[NSMutableArray alloc] init];
        
        for (ITCSmartWord *itcSmartWord in wordRange.words)
        {
            
            ITCSampleWord *sampleWord = [self iTCSampleWordFromWord:itcSmartWord];
            for (StrokeView *strokeView in sampleWord.strokeViews)
            {
                [allFrames addObject:[NSValue valueWithCGRect:strokeView.frame]];
                //                [selectionView addStrokeView:strokeView];
            }
            
            
            WordView *wordView = [_pageView wordViewForSmartWord:sampleWord.smartWord];
            if (wordView)
                [allFrames addObject:[NSValue valueWithCGRect:wordView.frame]];
            
            [_selectionView addSampleWord:sampleWord];
        }
        [_selectionView setFrames:allFrames];
        
        [_selectionView becomeFirstResponder];
        [_pageView addSubview:_selectionView];
        [_selectionView draw];
    }
}

//----------------------------------
#pragma mark Utils Strokes
//----------------------------------

- (void)removeSelectionView
{
    if (_selectionView)
    {
        [_selectionView removeFromSuperview];
        _selectionView = nil;
    }
}

- (ITCSampleStroke *)calculPointsWithXPoints:(NSArray *)xPoints yPoints:(NSArray *)yPoints andLineWidth:(float)lineWidth
{
    
    Stroker *stroker = [[Stroker alloc] init];
    
    NSUInteger strokeCount = xPoints.count;
    
    CGPoint firstPoint = [self calculPointFromX:[xPoints objectAtIndex:0] y:[yPoints objectAtIndex:0]];
    [stroker beginStrokeWithPoint:firstPoint];
    for (int i = 1; i < strokeCount - 1; i++)
    {
        CGPoint point = [self calculPointFromX:[xPoints objectAtIndex:i] y:[yPoints objectAtIndex:i]];
        [stroker continueStrokeWithPoint:point];
    }
    CGPoint finalPoint = [self calculPointFromX:[xPoints objectAtIndex:strokeCount-1] y:[yPoints objectAtIndex:strokeCount-1]];
    [stroker endStrokeWithPoint:finalPoint];
    
    ITCSampleStroke *stroke = [[ITCSampleStroke alloc] init];
    stroke.path = [UIBezierPath bezierPathWithCGPath:stroker.path.CGPath];
    stroke.color = stroker.strokeColor;
    stroke.lineWidth = stroker.lineWidth;
    stroke.frame = [stroker frameFromCurrentDrawing];;
    stroke.points = stroker.samplePoints;
    stroke.startStrokeDate = [NSDate date];
    stroke.endStrokeDate = [NSDate date];
    
    return stroke;
}

- (CGPoint)calculPointFromX:(NSNumber*)x y:(NSNumber*)y
{
    float xPoint = (float)[x floatValue];
    float yPoint = (float)[y floatValue];
    
    return CGPointMake(xPoint, yPoint);
}

//----------------------------------
#pragma mark Utils Words
//----------------------------------

- (void)checkUnderline:(ITCSmartWord*)word
{
    NSArray *strokes = word.strokes;
    if (strokes.count > 0)
    {
        BOOL isWholeWordUndeline = NO;
        for (ITCSmartStroke *stroke in strokes)
        {
            UserParamSample *userParam = (UserParamSample *)[stroke userParams];
            if (userParam.isUnderline)
            {
                isWholeWordUndeline = YES;
                break;
            }
        }
        if (isWholeWordUndeline)
            [self addUnderlineToSmartWord:word];
        else
            [self removeUnderlineToSmartWord:word];
    }
    else
    {
        BOOL isWholeWordUndeline = NO;
        NSInteger charCount = word.charBoxes.count;
        for (NSInteger index = 0; index < charCount; index++)
        {
            UserParamSample *userParam = (UserParamSample *)[word userParamsForCharacterAtIndex:index];
            if (userParam.isUnderline)
            {
                isWholeWordUndeline = YES;
                break;
            }
        }
        if (isWholeWordUndeline)
            [self addUnderlineToSmartWord:word];
        else
            [self removeUnderlineToSmartWord:word];
    }
}

- (void)removeDataFormatsFromUserParams
{
    for (ITCSmartStroke *stroke in _page.strokes)
    {
        UserParamSample *userParam = (UserParamSample *)stroke.userParams;
        [userParam setDataFormatLabel:@""];
    }
}

- (void)addDataFormat
{
    NSString *textPage = _page.text;
    NSMutableArray *matches = [NSMutableArray arrayWithArray:[DataFormatRecognizer dataTypesFromString:textPage]];
    [matches sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSRange range1 = [obj1 range];
        NSRange range2 = [obj2 range];
        return range1.location >= range2.location;
    }];
    NSRange lastRange = NSMakeRange(0, 0);

    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = [match range];

        // Consider the data format with the max of text
        if (matchRange.length > 0 && (matchRange.location >= lastRange.location+lastRange.length || matchRange.location+matchRange.length < lastRange.location))
        {
            NSString *dataFormatText = [textPage substringWithRange:matchRange];
            ITCStrokeRange *strokeRange = [_page strokeRangeBeginIndex:matchRange.location endIndex:matchRange.length + matchRange.location - 1];
            
            NSArray *strokes = strokeRange.strokes;
            for (ITCSmartStroke *stroke in strokes)
            {
                UserParamSample *userParam = (UserParamSample *)stroke.userParams;
                [userParam setDataFormatLabel:dataFormatText];
            }
        }
        lastRange = matchRange;
    }
    
    NSArray *strokes = [_page strokes];
    NSUInteger strokesCount = [_page strokes].count;
    // Strokes word
    for (int i = 0; i < strokesCount;  i++)
    {
        ITCSmartStroke *stroke = strokes[i];
        UserParamSample *userParam = (UserParamSample *)stroke.userParams;
        
        StrokeView *strokeView = [_pageView strokeViewFromStroke:stroke];
        UIColor *oldColor = strokeView.color;
        if (userParam && ![userParam.dataFormatLabel isEqualToString:@""])
            [strokeView setColor:TINT_COLOR];
        else
            if (userParam)
                [strokeView setColor:userParam.color];
        // load itf (no user param)
            else
                [strokeView setColor:ITC_RECOGNIZED_COLOR];
        
        // force draw to change color if needed
        if (![oldColor isEqual:strokeView.color])
            [strokeView draw];
    }
}

- (NSArray *)indexTypesetCharsForMixWords:(ITCSmartWord *)word
{
    NSMutableArray *indexTypesetChars = [NSMutableArray array];
    
    NSUInteger count = word.charTypes.count;
    for (NSInteger index = 0; index < count; index++)
    {
        ITCWordType type = (ITCWordType) [[word.charTypes objectAtIndex:index] intValue];
        if (type == ITCWordTypeTypeset)
            [indexTypesetChars addObject:@(index)];
    }
    
    return [NSArray arrayWithArray:indexTypesetChars];
    
}



- (UIFont *)fontUsedInWord:(ITCSmartWord *)word
{
    NSUInteger charactersCount = word.charLabels.count;
    for (int i = 0; i < charactersCount; i++)
    {
        UIFont *font = [(UserParamSample *)[word userParamsForCharacterAtIndex:i] characterFont];
        if (font)
            return font;
    }
    
    return nil;
}

- (CandidateView *)createCandidateViewWithWord:(ITCSmartWord *)word
{
    ITCRect *wordRect = [word boundingRect];
    
    // create new candidate view
    NSString *candidate = [NSString stringWithFormat:@"%@ - %.02f", [word selectedCandidate], [word baseLine]];
    CandidateView *candidateView = [[CandidateView alloc] initWithCandidate:candidate];
    
    float midLine = (word.midlineShift / 2);
    if (midLine > wordRect.height)
        midLine = wordRect.height / 2;
    
    float baseline = word.baseLine + midLine;
    
    float width;
    if (wordRect.width < MIN_CANDIDATE_VIEW_WIDTH)
        width = MIN_CANDIDATE_VIEW_WIDTH;
    else
        width =  wordRect.width + 5;
    
    candidateView.frame = CGRectMake(wordRect.x, baseline + 5, width, 30);
    [candidateView initView];
    
    // attach candidate to super view
    [_pageView addCandidateView:candidateView];
    
    return candidateView;
}

- (ITCSampleWord *)iTCSampleWordFromWord:(ITCSmartWord *)smartWord
{
    for (ITCSampleWord *itcSampleWord in _itcSampleWords)
    {
        if ([itcSampleWord.smartWord isEqual:smartWord])
        {
            return itcSampleWord;
        }
    }
    return nil;
}

- (void)removeITCSampleWordFromWord:(ITCSmartWord *)smartWord
{
    ITCSampleWord *itcSampleWord = [self iTCSampleWordFromWord:smartWord];
    [_itcSampleWords removeObject:itcSampleWord];
    // remove previous candidate if present
    [_pageView removeCandidate:itcSampleWord.candidateView];
}

- (ITCSampleWord*)iTCSampleWordForX:(float)x andY:(float)y
{
    StrokeView *strokeView = [_pageView strokeViewForPosition:CGPointMake(x, y)];
    ITCSampleWord *itcSampleWord = [self iTCSampleWordFromStrokeView:strokeView];
    return itcSampleWord;
}

- (ITCSampleWord*)iTCSampleWordFromStrokeView:(StrokeView *)strokeView
{
    for (ITCSampleWord *itcSampleWord in _itcSampleWords)
    {
        for (StrokeView *currentStrokeView in itcSampleWord.strokeViews)
        {
            if ([currentStrokeView isEqual:strokeView])
            {
                return itcSampleWord;
            }
        }
    }
    return nil;
}

@end
