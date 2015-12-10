// Copyright MyScript. All right reserved.

#import "SelectionView.h"

@implementation SelectionView
{
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)initView
{
    [self setBackgroundColor:ITC_SELECTION_BACKGROUND_COLOR];
    
//    _strokeViews = [NSMutableArray array];
    _sampleWords = [NSMutableArray array];
}

- (void)draw
{
    CGRect previousFrame = CGRectNull;
    
    // concat frame from views
//    for (StrokeView *strokeView in _strokeViews)
//    {
//        previousFrame = CGRectUnion(previousFrame, strokeView.frame);
//    }

    
    for (NSValue *frame in _frames)
    {
        previousFrame = CGRectUnion(previousFrame, [frame CGRectValue]);
    }
    
    [self setFrame:CGRectMake(previousFrame.origin.x - 10, previousFrame.origin.y, previousFrame.size.width + 20, previousFrame.size.height)];
    
    // Available actions if only one word
    if (_sampleWords.count == 1)
    {
        UIMenuItem *menuShowCandidate = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Change candidate", @"") action:@selector(showCandidateAction:)];
        UIMenuItem *menuTypeset = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Typeset", @"") action:@selector(typesetAction:)];
        NSArray *menuItemArray = @[menuShowCandidate, menuTypeset];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuItemArray];
        [menu setTargetRect:self.frame inView:self.superview];
        menu.arrowDirection = UIMenuControllerArrowDown;
        [menu setMenuVisible:YES animated:YES];
    }
}

//- (void)addStrokeView:(StrokeView *)strokeView
//{
//    [_strokeViews addObject:strokeView];
//}

- (void)addSampleWord:(ITCSampleWord *)sampleWord
{
    [_sampleWords addObject:sampleWord];
}

# pragma mark Menu actions
- (void)showCandidateAction:(id)sender
{
    ITCSampleWord *sampleWord = [_sampleWords objectAtIndex:0];
    NSArray *candidates = sampleWord.smartWord.candidates;
    
    NSMutableArray *menuItemArray = [NSMutableArray array];
    
    int nbMenu = 5;
    for (int i = 0; i < nbMenu; i++)
    {
        if ([candidates count] > i)
        {
            // create dynamic selector
            NSString *selector = [NSString stringWithFormat:@"changeCandidate%d:", i];
            
            NSString *candidate = [candidates objectAtIndex:i];
            UIMenuItem *menuCandidate = [[UIMenuItem alloc] initWithTitle:candidate action:NSSelectorFromString(selector)];
            [menuItemArray addObject:menuCandidate];
        }
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:menuItemArray];
    [menu setTargetRect:self.frame inView:self.superview];
    menu.arrowDirection = UIMenuControllerArrowDown;
    [menu setMenuVisible:YES animated:YES];
}

- (void)changeCandidate0:(UIMenuController *)menu
{
    ITCSampleWord *sampleWord = [_sampleWords objectAtIndex:0];
    if (_delegate)
        [_delegate selectionView:self changeCandidateIndex:0 ForSampleWord:sampleWord];
}

- (void)changeCandidate1:(UIMenuController *)menu
{
    ITCSampleWord *sampleWord = [_sampleWords objectAtIndex:0];
    if (_delegate)
        [_delegate selectionView:self changeCandidateIndex:1 ForSampleWord:sampleWord];
}

- (void)changeCandidate2:(UIMenuController *)menu
{
    ITCSampleWord *sampleWord = [_sampleWords objectAtIndex:0];
    if (_delegate)
        [_delegate selectionView:self changeCandidateIndex:2 ForSampleWord:sampleWord];
}

- (void)changeCandidate3:(UIMenuController *)menu
{
    ITCSampleWord *sampleWord = [_sampleWords objectAtIndex:0];
    if (_delegate)
        [_delegate selectionView:self changeCandidateIndex:3 ForSampleWord:sampleWord];
}

- (void)changeCandidate4:(UIMenuController *)menu
{
    ITCSampleWord *sampleWord = [_sampleWords objectAtIndex:0];
    if (_delegate)
        [_delegate selectionView:self changeCandidateIndex:4 ForSampleWord:sampleWord];
}

- (void)typesetAction:(id)sender
{
    if (_delegate)
        [_delegate selectionView:self typesetForSampleWord:[_sampleWords objectAtIndex:0]];
    
}

@end
