// Copyright MyScript. All right reserved.

#import "ViewController.h"
#import "StrokeView.h"
#import "PageView.h"
#import "MyCertificate.h"
#import "MenuTableViewController.h"
#import "DataFormatRecognizer.h"
#import "CandidateView.h"

#import <AtkItc/ITC.h>
#import "UserParamSample.h"
#import "ITCSamplePoint.h"
#import "WordUserParamsFactorySample.h"
#import "StrokeUserParamsFactorySample.h"
#import "ITCSampleGestureData.h"
#import "UnderlineStrokesView.h"
#import "WordView.h"

#import "SJSMainViewController.h"




@interface ViewController () <ITCPageInterpreterDelegate, ITCSmartPageRecognitionDelegate>

/**
 *  Go the previous page of the current page intrepreter
 *  @param sender The button sender.
 */
- (IBAction)previousPage:(id)sender;

/**
 *  Go the next page of the current page intrepreter
 *  @param sender The button sender.
 */
- (IBAction)nextPage:(id)sender;

@end

@implementation ViewController
{
    // Page interpreter and pages
    ITCPageInterpreter* _currentPageInterpreter;
    NSMutableArray *_pageInterpreters;
    NSMutableArray *_pagesData;
    NSInteger _currentPageIndex;
    
    // Factories
    ITCStrokeFactory *_strokeFactory;
    ITCWordFactory *_wordFactory;
    
    // User params
    UserParamSample *_userParams;
    StrokeUserParamsFactorySample *_strokeUserParams;
    WordUserParamsFactorySample *_wordUserParams;
    
    // Capture
    InkCaptureView *_inkCaptureView;
    
    // Popover
    UIPopoverController *_popoverController;
    
    // Change page buttons and page number label
    IBOutlet UIButton* _nextPageButton;
    IBOutlet UIButton* _previousPageButton;
    IBOutlet UILabel* _pageNumberLabel;
    IBOutlet UILabel* _notificationLabel;
    
    // Value to show or not guidelines and candidates
    BOOL _isGuidelinesShowed;
    BOOL _isCandidateShowed;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Input";
    
    [self.view setBackgroundColor:APP_BACKGROUND_COLOR];
    
    _isGuidelinesShowed = NO;
    _isCandidateShowed = YES;
    _isRecoPen = YES;
    
    _displayViewController = [[DisplayViewController alloc] init];
    _displayViewController.viewController = self;
    [_containerView addSubview:_displayViewController.view];
    CGSize viewSize = [self viewSize];
    _displayViewController.view.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    [self addChildViewController:_displayViewController];
    
    [self initITC];
    
    // Init the toolbar
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
    [self.navigationItem setLeftBarButtonItem:menuItem];
    
    // Init the toolbar
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(pushGraph)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    UIImage *image = [UIImage imageNamed:@"IC_LeftArrow"];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)])
    {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [_previousPageButton setImage:image forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:@"IC_RightArrow"];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)])
    {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [_nextPageButton setImage:image forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initITC
{
    // get real dpi
    float scale = [[UIScreen mainScreen] scale];
    float dpi = 0.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        dpi = 132 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        dpi = 163 * scale;
    }
    
    NSString *akCur = [[NSBundle mainBundle] pathForResource:@"en_US-ak-cur.lite" ofType:@"res"];
    NSString *lkText = [[NSBundle mainBundle] pathForResource:@"en_US-lk-text.lite" ofType:@"res"];
    NSArray *resources = @[akCur, lkText];
    
    // get valid certificate
    NSData *certificate = [NSData dataWithBytes:myCertificate.bytes length:myCertificate.length];
    
    // init page managers
    _pageInterpreters = [NSMutableArray array];
    ITCPageInterpreter* pageInterpreter;
    
    _strokeUserParams = [[StrokeUserParamsFactorySample alloc] init];
    _wordUserParams = [[WordUserParamsFactorySample alloc] init];
    
    _strokeFactory = [ITCStrokeFactory strokeFactory:_strokeUserParams];
    _wordFactory = [ITCWordFactory wordFactoryWithStrokeFactory:_strokeFactory wordUserParamFactory:_wordUserParams];
    
    _gestureManager = [[GestureManager alloc] init];
    [_gestureManager setWordFactory:_wordFactory];
    [_gestureManager setViewController:self];
    
    {
        pageInterpreter = [ITCPageInterpreter pageInterpreter];
        pageInterpreter.delegate = self;
        [_gestureManager applyGestureOnPageInterpreter:pageInterpreter];
        
        // launch itc config
        [pageInterpreter configurePageInterpreter:@"en_US" resources:resources lexicon:nil certificate:certificate density:dpi freezeTimeout:650];
        [_pageInterpreters addObject:pageInterpreter];
        ITCSmartPage *page = [ITCSmartPage smartPageWithWordFactory:_wordFactory];
        page.changeDelegate = _displayViewController;
        page.recognitionDelegate = self;
        page.gestureDelegate = _gestureManager;
        [pageInterpreter setPage:page];
        [_displayViewController setPage:page];
        
        _indexCurrentPageInterpreter = 0;
        _currentPageInterpreter = pageInterpreter;
        [_gestureManager setPageInterpreter:_currentPageInterpreter];
    }
    {
        pageInterpreter = [ITCPageInterpreter pageInterpreter];
        pageInterpreter.delegate = self;
        
        // launch itc config
        [pageInterpreter configurePageInterpreter:@"en_US" resources:resources lexicon:nil certificate:certificate density:dpi freezeTimeout:650];
        [_pageInterpreters addObject:pageInterpreter];
        ITCSmartPage *page = [ITCSmartPage smartPageWithWordFactory:_wordFactory];
        page.changeDelegate = _displayViewController;
        page.recognitionDelegate = self;
        page.gestureDelegate = _gestureManager;
        [pageInterpreter setPage:page];
    }
    {
        pageInterpreter = [ITCPageInterpreter pageInterpreter];
        pageInterpreter.delegate = self;
        
        // launch itc config
        [pageInterpreter configurePageInterpreter:@"en_US" resources:resources lexicon:nil certificate:certificate density:dpi freezeTimeout:650];
        [_pageInterpreters addObject:pageInterpreter];
        ITCSmartPage *page = [ITCSmartPage smartPageWithWordFactory:_wordFactory];
        page.changeDelegate = _displayViewController;
        page.recognitionDelegate = self;
        page.gestureDelegate = _gestureManager;
        [pageInterpreter setPage:page];
    }
    {
        pageInterpreter = [ITCPageInterpreter pageInterpreter];
        pageInterpreter.delegate = self;
        
        // launch itc config
        [pageInterpreter configurePageInterpreter:@"en_US" resources:resources lexicon:nil certificate:certificate density:dpi freezeTimeout:650];
        [_pageInterpreters addObject:pageInterpreter];
        ITCSmartPage *page = [ITCSmartPage smartPageWithWordFactory:_wordFactory];
        page.changeDelegate = _displayViewController;
        page.recognitionDelegate = self;
        page.gestureDelegate = _gestureManager;
        [pageInterpreter setPage:page];
    }
    
    // Initialise the pages data array
    _pagesData = [NSMutableArray array];
    [_pagesData addObject:[NSMutableArray arrayWithObject:[[_pageInterpreters[0] page] data]]];
    [_pagesData addObject:[NSMutableArray arrayWithObject:[[_pageInterpreters[1] page] data]]];
    [_pagesData addObject:[NSMutableArray arrayWithObject:[[_pageInterpreters[2] page] data]]];
    [_pagesData addObject:[NSMutableArray arrayWithObject:[[_pageInterpreters[3] page] data]]];
    [_pageNumberLabel setText:[NSString stringWithFormat:@"%ld", (long)_currentPageIndex+1]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _inkCaptureView = [[InkCaptureView alloc] initWithFrame:_containerView.frame];
    _inkCaptureView.backgroundColor = [UIColor clearColor];
    _inkCaptureView.delegate = self;
    [_containerView addSubview:_inkCaptureView];
    
    [_containerView bringSubviewToFront:_previousPageButton];
    [_containerView bringSubviewToFront:_nextPageButton];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self setupViewFrameForOrientation:@(orientation)];
}


- (void)loadPage:(ITCSmartPage *)page
{
    if (page)
    {
        [_displayViewController setPage:page];
    }
}

/**
 * Get size for scroll view
 * Use the bigger size for height. In landscape, let an empty room to ease the scroll
 *  @return concrete size for scroll view
 */
- (CGSize)viewSize
{
    CGFloat width = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        width = [[UIScreen mainScreen] bounds].size.height;
    else
        width = 375;
    return CGSizeMake(width, _containerView.frame.size.height);
}

//----------------------------------
#pragma mark Orientation
//----------------------------------

- (void)setupViewFrameForOrientation:(NSNumber *)interfaceOrientation
{
    CGSize viewSize = self.view.window.frame.size;
    CGFloat value = MAX(viewSize.width, viewSize.height);

    
    // Landscape
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation.integerValue))
    {
        [_resultTextView setFrame:CGRectMake(_containerView.frame.size.width, 0,
                                             value - _containerView.frame.size.width, self.view.frame.size.height)];
    }
    else
    {
        CGFloat height = _containerView.frame.size.height;
        height = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 270 : height;
        [_resultTextView setFrame:CGRectMake(0, _containerView.frame.size.height+_containerView.frame.origin.y,
                                             _containerView.frame.size.width, value - _containerView.frame.size.height)];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self setupViewFrameForOrientation:@([[UIApplication sharedApplication] statusBarOrientation])];
}

//----------------------------------
#pragma mark Navigation
//----------------------------------

- (void)showMenu:(id)sender
{
    // Show iPad menu (popover)
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (!_popoverController)
        {
            MenuTableViewController *menuViewController = [[MenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuViewController];
            
            _popoverController = [[UIPopoverController alloc] initWithContentViewController:nav];
            _popoverController.popoverContentSize = CGSizeMake(320, 510);
            menuViewController.viewController = self;
            [menuViewController setParentPopopController:_popoverController];
            [menuViewController setItcGesturesSampleData:_gestureManager.itcSampleGestureData];
        }
        UINavigationController *navController = (UINavigationController *)_popoverController.contentViewController;
        MenuTableViewController *menuViewController = (MenuTableViewController *) [navController.childViewControllers objectAtIndex:0];
        menuViewController.isGuidelinesShowed = _isGuidelinesShowed;
        menuViewController.isCandidateShowed = _isCandidateShowed;
        menuViewController.isITFDebug         = _currentPageInterpreter.ITFDebug;
        
        [_popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem*)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    // Show iPhone menu (full screen)
    else
    {
        MenuTableViewController *menuViewController = [[MenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
        menuViewController.viewController = self;
        menuViewController.isGuidelinesShowed = _isGuidelinesShowed;
        menuViewController.isCandidateShowed = _isCandidateShowed;
        //menuViewController.isITFDebug         = _currentPageInterpreter.ITFDebug;
        [menuViewController setItcGesturesSampleData:_gestureManager.itcSampleGestureData];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuViewController];
        nav.navigationBar.barStyle = UIBarStyleBlack;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

//----------------------------------
#pragma mark Recognition
//----------------------------------

- (void)inkCaptureViewDidTouchBegan:(InkCaptureView *)inkCaptureView
{
    [_currentPageInterpreter.page penDown];
}

- (void)inkCaptureViewDidTouchEnd:(InkCaptureView *)inkCaptureView
{
}


- (void)inkCaptureView:(InkCaptureView *)inkCaptureView didCreatePoints:(NSArray *)points stroke:(ITCSampleStroke *)itcStroke startReco:(BOOL)startReco
{
    // check if reco is ready and
    if (startReco)
    {
        ITCSmartPage *page = [_currentPageInterpreter page];
        NSMutableArray *x = [NSMutableArray array];
        NSMutableArray *y = [NSMutableArray array];

        for (NSValue *value in points)
        {
            [x addObject:@([value CGPointValue].x)];
            [y addObject:@([value CGPointValue].y)];
        }
        
        UserParamSample *userParamSample = [self createDefaultUserParam];
        [userParamSample setLineWidth:itcStroke.lineWidth];
        [userParamSample setItcPoints:itcStroke.points];
        [userParamSample setFrame:itcStroke.frame];
        [userParamSample setColor:itcStroke.color];
        
        ITCStrokeType strokeType = _isRecoPen ? ITCStrokeTypeRecognitionStroke : ITCStrokeTypeDrawingStroke;
        
        ITCSmartStroke *stroke = [_strokeFactory createStrokeWithX:x y:y startTimestamp:[itcStroke.startStrokeDate timeIntervalSince1970] endTimestamp:[itcStroke.endStrokeDate timeIntervalSince1970] userParams:userParamSample strokeType:strokeType];
        [page addStroke:stroke];
    }
}

- (UserParamSample *)createDefaultUserParam
{
    UserParamSample *userParamSample = [[UserParamSample alloc] init];
    [userParamSample setColor:[UIColor blueColor]];
    [userParamSample setOrder:1];
    [userParamSample setIdUserParam:@"Id Ninja o/\\o"];
    
    return userParamSample;
}

//----------------------------------
#pragma mark Button action
//----------------------------------

- (void)changeColor
{
    UIColor *strokeColor = [UIColor greenColor];
    _inkCaptureView.strokeColor = strokeColor;
}

- (void)clear
{
    [[_currentPageInterpreter page] clear];
}

- (void)clearUI
{
    // empty label
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_resultTextView setText:@""];
    }];
}

- (void)guidelinesChangedAction:(bool)isOn
{
    // show or clear guidelines (next in PageViewDelegate->DidShowGuidelines
    _isGuidelinesShowed = isOn;
    _gestureManager.guidelinesActivated = isOn;
    [_displayViewController showGuidelines:isOn];
}

- (void)candidateChangedAction:(bool)isOn
{
    // show or clear guidelines (next in PageViewDelegate->DidShowGuidelines
    _isCandidateShowed = isOn;
    [_displayViewController showCandidate:isOn];
}

- (void)ITFDebugChangedAction:(bool)isOn
{
    [_currentPageInterpreter setITFDebug:isOn];
}

- (void)saveCurrentPageToITFWithName:(NSString*)aFilename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);\
    NSString *documentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *filepath = [NSString stringWithFormat:@"%@/%@.itf",documentsDirectory,aFilename];
    ITCError *error = [_currentPageInterpreter.page saveITFAtPath:filepath];
    if (error)
    {
        [[[UIAlertView alloc] initWithTitle:@"Save failed!" message:error.messageError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (IBAction)previousPage:(id)sender
{
    NSMutableArray *currentPagesData = [_pagesData objectAtIndex:[_pageInterpreters indexOfObject:_currentPageInterpreter]];
    ITCSmartPage *currentPage = [_currentPageInterpreter page];
    NSData *currentPageData = [currentPage data];
    currentPagesData[_currentPageIndex] = currentPageData;
    
    if (_currentPageIndex > 0)
    {
        [self clearUI];
        NSLog(@"Go the previous page %ld",  (long)_currentPageIndex-1);
        // Go to the previous one
        NSData *prevPageData = currentPagesData[_currentPageIndex-1];
        ITCSmartPage *prevPage = [ITCSmartPage smartPageWithWordFactory:[[_currentPageInterpreter page] wordFactory] fromData:prevPageData];
        [self loadPage:prevPage];
        prevPage.changeDelegate = _displayViewController;
        prevPage.recognitionDelegate = self;
        prevPage.gestureDelegate = _gestureManager;
        [_currentPageInterpreter setPage:prevPage];
        _currentPageIndex--;
    }
    [_pageNumberLabel setText:[NSString stringWithFormat:@"%d",  _currentPageIndex+1]];
}

- (IBAction)nextPage:(id)sender
{
    NSMutableArray *currentPagesData = [_pagesData objectAtIndex:[_pageInterpreters indexOfObject:_currentPageInterpreter]];
    ITCSmartPage *currentPage = [_currentPageInterpreter page];
    NSData *currentPageData = [currentPage data];
    currentPagesData[_currentPageIndex] = currentPageData;
    
    [self clearUI];
    
    if (_currentPageIndex == currentPagesData.count - 1)
    {
        NSLog(@"Create a new the page %d", _currentPageIndex+1);
        // Create a new page
        ITCSmartPage *newPage = [ITCSmartPage smartPageWithWordFactory:[[_currentPageInterpreter page] wordFactory]];
        [self loadPage:newPage];
        newPage.changeDelegate = _displayViewController;
        newPage.recognitionDelegate = self;
        newPage.gestureDelegate = _gestureManager;
        [_currentPageInterpreter setPage:newPage];
        [currentPagesData addObject:[newPage data]];
    }
    else
    {
        NSLog(@"Go the next page %d",  _currentPageIndex+1);
        // Go to the next one
        NSData *nextPageData = currentPagesData[_currentPageIndex+1];
        ITCSmartPage *nextPage = [ITCSmartPage smartPageWithWordFactory:[[_currentPageInterpreter page] wordFactory] fromData:nextPageData];
        [self loadPage:nextPage];
        nextPage.changeDelegate = _displayViewController;
        nextPage.recognitionDelegate = self;
        nextPage.gestureDelegate = _gestureManager;
        [_currentPageInterpreter setPage:nextPage];
    }
    _currentPageIndex++;
    [_pageNumberLabel setText:[NSString stringWithFormat:@"%ld", (long)_currentPageIndex+1]];
}

//----------------------------------
#pragma mark Typeset
//----------------------------------

- (void)typesetPage
{
    NSMutableArray *typesetWords = [NSMutableArray array];
    for (ITCSmartWord *smartWord in _currentPageInterpreter.page.words)
    {
        UIFont *font = nil;
        if (smartWord.type == ITCWordTypeTypeset)
        {
            ITCSmartWord *typesetWord = [_wordFactory createCopyOfWord:smartWord spaceBefore:smartWord.spaceBefore];
            [typesetWords addObject:typesetWord];
        }
        else
        {
            font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
            [_wordFactory.defaultCharBoxFactory setFont:font];
            
            ITCSmartWord *typesetWord = [_wordFactory createTypeSetWord:smartWord xPosition:smartWord.leftBound yPosition:smartWord.baseLine spaceBefore:smartWord.spaceBefore];
            NSMutableArray *currentWordUserParams = [NSMutableArray array];
            for (NSInteger index = 0; index < typesetWord.charBoxes.count ; index++)
            {
                UserParamSample *wordUserParam = (UserParamSample*)[typesetWord userParamsForCharacterAtIndex:index];
                if (!wordUserParam)
                {
                    wordUserParam = [[UserParamSample alloc] init];
                    [currentWordUserParams addObject:wordUserParam];
                }
                [wordUserParam setCharacterFont:font];
            }
            
            if (currentWordUserParams.count > 0)
                typesetWord = [_wordFactory createWord:typesetWord userParams:currentWordUserParams spaceBefore:typesetWord.spaceBefore];
            [typesetWords addObject:typesetWord];
        }
    }
    [self clear];
    [_currentPageInterpreter.page addWords:typesetWords];
}

//----------------------------------
#pragma mark ITFFilesViewController delegate
//----------------------------------

- (void)itfFilesViewController:(ITFFilesViewController *)itfFilesViewController didChooseFile:(NSString *)filePath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [_popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [itfFilesViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    // Draw ITF
    [self clear];
    
    ITCSmartPage *page = [_currentPageInterpreter page];
    if (page)
        [page loadITFAtPath:filePath];
}

- (void)selectPageInterpreterViewController:(SelectPageInterpreterViewController *)selectPageViewController didChangePageInterpreterIndex:(NSInteger)index
{
    if (index < _pageInterpreters.count)
    {
        _indexCurrentPageInterpreter = index;
        
        [self clearUI];
        NSMutableArray *currentPagesData = [_pagesData objectAtIndex:[_pageInterpreters indexOfObject:_currentPageInterpreter]];
        currentPagesData[_currentPageIndex] = [[_currentPageInterpreter page] data];
        
        _currentPageInterpreter = [_pageInterpreters objectAtIndex:index];
        if (_isGuidelinesShowed)
            [_currentPageInterpreter setGuidelines:ITC_GUIDELINE_MARGIN_TOP gap:ITC_GUIDELINE_SPACING lineCount:_displayViewController.lineCount];
        else
            [_currentPageInterpreter clearGuidelines];
        
        _currentPageIndex = 0;
        currentPagesData = [_pagesData objectAtIndex:[_pageInterpreters indexOfObject:_currentPageInterpreter]];
        NSData *currentPageData = currentPagesData[_currentPageIndex];
        ITCSmartPage *currentPage = [ITCSmartPage smartPageWithWordFactory:[[_currentPageInterpreter page] wordFactory] fromData:currentPageData];
        [self loadPage:currentPage];
        currentPage.changeDelegate = _displayViewController;
        currentPage.recognitionDelegate = self;
        currentPage.gestureDelegate = _gestureManager;
        [_currentPageInterpreter setPage:currentPage];
        
        [_gestureManager setPageInterpreter:_currentPageInterpreter];
        [_gestureManager applyGestureOnPageInterpreter:_currentPageInterpreter];
        
        NSString *notification = [NSString stringWithFormat:@"Current locale : %@", [_currentPageInterpreter locale]];
        [self showNotification:notification];
    }
    [_pageNumberLabel setText:[NSString stringWithFormat:@"%ld", (long)_currentPageIndex+1]];
}

//----------------------------------
#pragma mark PageView delegate
//----------------------------------

- (void)pageView:(PageView *)pageView DidShowGuidelines:(BOOL)showGuidelines firstLinePosition:(CGFloat)firstLinePosition gap:(CGFloat)gap numberLines:(int)lines
{
    if (showGuidelines)
        [_currentPageInterpreter setGuidelines:ITC_GUIDELINE_MARGIN_TOP gap:ITC_GUIDELINE_SPACING lineCount:lines];
    else
        [_currentPageInterpreter clearGuidelines];
}

//----------------------------------
#pragma mark SelectionView delegate
//----------------------------------

- (void)selectionView:(SelectionView *)selectionView changeCandidateIndex:(int)candidateIndex ForSampleWord:(ITCSampleWord *)sampleWord
{
    ITCSmartWord *newSmartWord = [_wordFactory createWord:sampleWord.smartWord selectedCandidateIndex:candidateIndex spaceBefore:[sampleWord.smartWord spaceBefore]];
    [_currentPageInterpreter.page replaceWord:sampleWord.smartWord withNewWord:newSmartWord];
}


- (void)selectionView:(SelectionView *)selectionView typesetForSampleWord:(ITCSampleWord *)sampleWord
{
    ITCSmartWord *word = sampleWord.smartWord;
    if (word.type != ITCWordTypeTypeset)
    {
        [_wordFactory.defaultCharBoxFactory setFont:[UIFont systemFontOfSize:DEFAULT_FONT_SIZE]];
        ITCSmartWord *typesetWord = [_wordFactory createTypeSetWord:word xPosition:word.leftBound yPosition:word.baseLine spaceBefore:word.spaceBefore];
        [_currentPageInterpreter.page replaceWord:word withNewWord:typesetWord];
    }
}

//----------------------------------
#pragma mark PenSelection delegate
//----------------------------------

- (void)penTableViewController:(PenTableViewController *)penTableViewController didChangePen:(BOOL)recoPen
{
    _isRecoPen = recoPen;
    if (!_isRecoPen)
        [_inkCaptureView setStrokeColor:ITC_DRAWING_COLOR];
    else
        [_inkCaptureView setStrokeColor:[UIColor blackColor]];
}

//----------------------------------
#pragma mark IOSPageManager delegate
//----------------------------------

- (void)pageWillStartRecognition:(ITCSmartPage *)page
{
    
}

- (void)pageDidRecognitionEnd:(ITCSmartPage *)page
{
    NSString *text = page.text;
    _wordterm = text;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [_resultTextView setText:text];
        
    }];
}

- (void)recognizerIntermediate:(ITCSmartPage *)page
{
    
}

//----------------------------------
#pragma mark IOSPageManager delegate
//----------------------------------

- (void)pageInterpreterWillStartConfiguration:(ITCPageInterpreter *)pageInterpreter
{
    
}


- (void)pageInterpreter:(ITCPageInterpreter *)pageInterpreter didConfigureEnded:(BOOL)succeed error:(ITCError *)error locale:(NSString *)locale
{
    NSLog(@"ITCPageInterpreter configured in %@", locale);
    
    NSString *string = [pageInterpreter recognitionErrorString];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (error.codeError != 0)
        {
            NSString *message = [NSString stringWithFormat:@"The config failed for language : %@", locale];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Config Failed" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSString *notification = [NSString stringWithFormat:@"Current locale : %@", locale];
            [self showNotification:notification];
            
        }
    }];
}

//----------------------------------
#pragma Underline & Selection
//----------------------------------

- (BOOL)checkWords:(NSArray *)smartWords insideBoundsoffsetX:(float)x offsetY:(float)y
{
    CGRect pageViewFrame = _displayViewController.view.frame;
    for (ITCSmartWord *word in smartWords)
    {
        ITCRect *rect = [word boundingRect];
        
        if (!CGRectContainsRect(pageViewFrame, rect.cgRect))
        {
            [self showNotification:@"No more space"];
            return NO;
        }
    }
    return YES;
}

//----------------------------------
#pragma Underline & Selection
//----------------------------------

- (void)configureCurrentPageInterpreterWithLanguage:(NSString*)aLanguageName andResources:(NSArray*)resources
{
    // get real dpi
    float scale = [[UIScreen mainScreen] scale];
    float dpi = 0.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        dpi = 132 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        dpi = 163 * scale;
    }
    
    // get valid certificate
    NSData *certificate = [NSData dataWithBytes:myCertificate.bytes length:myCertificate.length];
    [_currentPageInterpreter configurePageInterpreter:aLanguageName resources:resources lexicon:nil certificate:certificate density:dpi];
}

//----------------------------------
#pragma Notifications
//----------------------------------

- (void)showNotification:(NSString*)aNotification
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_notificationLabel setText:aNotification];
        [_notificationLabel setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [_notificationLabel setAlpha:1.];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_notificationLabel setAlpha:0.];
            } completion:^(BOOL finished) {
                [_notificationLabel setHidden:YES];
            }];
        }];
    }];
    
}

-(void)pushGraph
{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    SJSMainViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"Graph"];
    //myController.wordterm = _wordterm;
    //NSLog(@"push:%@",pushgraph);
    [[self navigationController] pushViewController:myController animated:YES];
    
}

@end
