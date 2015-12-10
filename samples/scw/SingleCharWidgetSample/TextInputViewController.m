// Copyright MyScript

#import "TextInputViewController.h"

#import "LanguageManager.h"

#import "MyCertificate.h"

#define CANDIDATE_LAYOUT_MARGIN             10
#define CANDIDATE_BUTTON_MARGIN             10
#define CANDIDATE_BUTTON_HEIGHT             30
#define CANDIDATE_FONT_SIZE                 15
#define CANDIDATE_LABEL_COLOR               [UIColor colorWithRed:0.200f green:0.710f blue:0.898f alpha:1.0f]
#define CANDIDATE_COMPLETION_COLOR          [UIColor colorWithRed:0.000f green:0.000f blue:0.000f alpha:1.0f]

#define TOAST_HORIZONTAL_MARGIN             5
#define TOAST_VERTICAL_MARGIN               5

@interface TextInputViewController ()

@property (nonatomic, readwrite) BOOL isRecognizing;

@property (nonatomic, readwrite) SCWCandidateInfo *candidateInfo;

- (void)triggerUpdateCandidatesTimer;
- (void)updateCandidates;
- (UIButton *)candidateButtonWithTag:(NSInteger)i label:(NSString *)label completion:(NSString *)completion;
- (void)candidateButtonTap:(UIView *)sender;
- (UIButton *)candidateButtonAtPoint:(CGPoint)point;

- (void)configureWithResources:(NSArray*)paths;

@end

@implementation TextInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SCWSingleCharView class];
    
    self.singleCharWidget.delegate = self;
    self.singleCharWidget.completionEnabled = YES;
    
    self.languages = [LanguageManager availableLanguages];
    self.languageSelected = self.languages[0];
    
    NSArray *resources = [LanguageManager resourcesForLanguage:self.languageSelected];
    NSArray *paths = [LanguageManager pathsForResources:resources];
    
    [self configureWithResources:paths];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setText:(NSString *)text {
    self.singleCharWidget.text = text;
}

- (NSString *)text {
    return self.singleCharWidget.text;
}

- (void)setInsertIndex:(NSUInteger)index {
    self.singleCharWidget.insertIndex = index;
    [self triggerUpdateCandidatesTimer];
}

- (NSUInteger)insertIndex {
    return self.singleCharWidget.insertIndex;
}

// ----------------------------------------------------------------------
#pragma mark - Toolbar
// ----------------------------------------------------------------------

- (IBAction)languageButtonTap:(id)sender {
    NSLog(@"Single tap on language button");
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSUInteger tag = button.tag;
    
    tag += 1;
    if (tag > self.languages.count - 1) {
        tag = 0;
    }
    [button setTag:tag];
    
    // Get next language
    self.languageSelected = [self.languages objectAtIndex:tag];
    [button setTitle:self.languageSelected];
    
    NSArray *resources = [LanguageManager resourcesForLanguage:self.languageSelected];
    NSArray *paths = [LanguageManager pathsForResources:resources];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(configureWithResources:) withObject:paths afterDelay:0.3f];
}

- (IBAction)deleteButtonTap:(id)sender {
    NSLog(@"Single tap on delete button");
    
    NSString *text = self.singleCharWidget.text;
    NSUInteger index = self.singleCharWidget.insertIndex;
    
    if (text.length == 0) {
        NSLog(@"Widget text is empty, canceling delete");
        return;
    }
    if (index == 0) {
        NSLog(@"Widget insert index at start of text, canceling delete");
        return;
    }
    
    NSRange range = [text rangeOfComposedCharacterSequenceAtIndex:(index - 1)];
    [self.singleCharWidget replaceCharactersInRange:range withText:nil];
}

- (IBAction)spaceButtonTap:(id)sender {
    NSLog(@"Single tap on space button");
    
    NSUInteger index = self.singleCharWidget.insertIndex;
    [self.singleCharWidget replaceCharactersInRange:NSMakeRange(index, 0) withText:@" "];
}

- (IBAction)returnButtonTap:(id)sender {
    NSLog(@"Single tap on return button");
    
    [self.delegate textInputViewControllerReturnButtonTap:self];
}

// ----------------------------------------------------------------------
#pragma mark - Candidates bar
// ----------------------------------------------------------------------

- (void)triggerUpdateCandidatesTimer {
    NSLog(@"Trigger candidates update");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateCandidates) object:nil];
    [self performSelector:@selector(updateCandidates) withObject:nil afterDelay:0.3f];
}

- (void)updateCandidates {
    if (self.isRecognizing) {
        // do nothing if user is writing/widget is busy recognizing
        return;
    }
    
    NSLog(@"Update candidates");
    NSUInteger index = self.singleCharWidget.insertIndex;
    
    if ([self.languageSelected hasPrefix:@"zh"]) {
        self.candidateInfo = [self.singleCharWidget getCharacterCandidatesAtIndex:(index - 1)];
    } else {
        self.candidateInfo = [self.singleCharWidget getWordCandidatesAtIndex:(index - 1)];
    }
    
    for (int i=0; i<self.candidateInfo.labels.count; i++) {
        NSLog(@"labels[%d]=\"%@|%@\"%@", i,
              self.candidateInfo.labels[i],
              self.candidateInfo.completions[i],
              (i == self.candidateInfo.selectedIndex ? @" (*)" : @""));
    }
    
    for (UIView *view in self.candidateLayout.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat w = 0;
    CGFloat h = self.candidateLayout.bounds.size.height;
    
    if (self.candidateInfo != nil) {
        w += CANDIDATE_LAYOUT_MARGIN;
        
        for (int i=0; i<self.candidateInfo.labels.count; i++) {
            NSString *label = self.candidateInfo.labels[i];
            NSString *completion = self.candidateInfo.completions[i];
            UIButton *button = [self candidateButtonWithTag:i label:label completion:completion];
            
            CGFloat x = w;
            CGFloat y = (h - button.bounds.size.height) / 2;
            button.frame = CGRectMake(x, y, button.bounds.size.width, button.bounds.size.height);
            [self.candidateLayout addSubview:button];
            
            w += button.frame.size.width;
        }

        w += CANDIDATE_LAYOUT_MARGIN;
    }
    
    self.candidateLayout.contentSize = CGSizeMake(w, h);
}

- (UIButton *)candidateButtonWithTag:(NSInteger)tag label:(NSString *)label completion:(NSString *)completion {
    NSString *visibleLabel = [self replaceInvisibleCharactersWithString:label];
    NSString *visibleCompletion = [self replaceInvisibleCharactersWithString:completion];
    
    NSString *titleString = [visibleLabel stringByAppendingString:visibleCompletion];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:titleString];
    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:CANDIDATE_FONT_SIZE] range:NSMakeRange(0, visibleLabel.length)];
    [title addAttribute:NSForegroundColorAttributeName value:CANDIDATE_LABEL_COLOR range:NSMakeRange(0, visibleLabel.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:CANDIDATE_FONT_SIZE] range:NSMakeRange(visibleLabel.length, visibleCompletion.length)];
    [title addAttribute:NSForegroundColorAttributeName value:CANDIDATE_COMPLETION_COLOR range:NSMakeRange(visibleLabel.length, visibleCompletion.length)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = tag;
    button.bounds = CGRectMake(0, 0, title.size.width + CANDIDATE_BUTTON_MARGIN * 2, CANDIDATE_BUTTON_HEIGHT);
    [button setAttributedTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(candidateButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)candidateButtonTap:(UIView *)sender {
    NSString *label = self.candidateInfo.labels[sender.tag];
    NSString *completion = self.candidateInfo.completions[sender.tag];
    
    NSLog(@"Single tap on candidate \"%@|%@\"", label, completion);
    
    [self.singleCharWidget replaceCharactersInRange:self.candidateInfo.range withText:[label stringByAppendingString:completion]];
}

- (UIButton *)candidateButtonAtPoint:(CGPoint)point {
    UIView *target = [self.candidateLayout hitTest:point withEvent:nil];
    if ([target isKindOfClass:[UIButton class]]) {
        return (UIButton *)target;
    } else {
        return nil;
    }
}

// ----------------------------------------------------------------------
#pragma mark - Single char widget delegate
// ----------------------------------------------------------------------

- (void)singleCharWidget:(SCWSingleCharView *)sender didChangeText:(NSString*)text intermediate:(BOOL)intermediate {
    NSLog(@"singleCharWidgetDidChangeText=%@ intermediate=%@", text, intermediate ? @"YES" : @"NO");
    
    [self triggerUpdateCandidatesTimer];

    [self.delegate textInputViewController:self didChangeText:text];
}

- (void)singleCharWidgetDidBeginConfiguration:(SCWSingleCharView*)sender {
    NSLog(@"singleCharWidgetDidBeginConfiguration");
}

- (void)singleCharWidget:(SCWSingleCharView*)sender didEndConfigurationWithSuccess:(BOOL)success {
    NSLog(@"singleCharWidgetDidEndConfigurationWithSuccess:%@", success ? @"YES" : @"NO");
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSString *displayName = [locale displayNameForKey:NSLocaleIdentifier value:self.languageSelected];

    if (success) {
        [self toastWithMessage:[@"Language set to " stringByAppendingString:displayName]];
    } else {
        [self toastWithMessage:[@"Error setting language " stringByAppendingString:displayName]];
    }
}

- (void)singleCharWidgetDidBeginRecognition:(SCWSingleCharView*)sender {
    NSLog(@"singleCharWidgetDidBeginRecognition");
    self.isRecognizing = YES;
}

- (void)singleCharWidgetDidEndRecognition:(SCWSingleCharView*)sender {
    NSLog(@"singleCharWidgetDidEndRecognition");
    self.isRecognizing = NO;
}

- (BOOL)singleCharWidget:(SCWSingleCharView*)sender didDetectSingleTapAtPoint:(CGPoint)point {
    NSLog(@"singleCharWidgetDidDetectSingleTapAtPoint");
    
    UIButton *button = [self candidateButtonAtPoint:point];
    if (button != nil) {
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    if (button == nil) {
        return NO; // we did not handle the event
    } else {
        return YES; // we handled the event
    }
}

- (void)singleCharWidget:(SCWSingleCharView*)sender didDetectBackspaceGesture:(NSUInteger)count {
    NSLog(@"singleCharWidgetdidDetectBackspaceGesture");
    [self toastWithMessage:@"Backspace gesture detected"];
    
    // simulate a tap on the delete button
    [self deleteButtonTap:nil];
}

- (void)singleCharWidgetDidDetectReturnGesture:(SCWSingleCharView*)sender {
    NSLog(@"singleCharWidgetDidDetectReturnGesture");
    [self toastWithMessage:@"Return gesture detected"];
    
    // simulate a tap on the return button
    [self returnButtonTap:nil];
}

// ----------------------------------------------------------------------
#pragma mark - Helper functions
// ----------------------------------------------------------------------

- (void)configureWithResources:(NSArray*)paths {
    if ([self.languageSelected hasPrefix:@"zh"] || [self.languageSelected hasPrefix:@"ja"] || [self.languageSelected hasPrefix:@"ko"]) {
        self.singleCharWidget.gesturesEnabled = NO;
    } else {
        self.singleCharWidget.gesturesEnabled = YES;
    }
    
    NSData *certificate = [NSData dataWithBytes:myCertificate.bytes length:myCertificate.length];
    [self.singleCharWidget configureWithLanguage:self.languageSelected resources:paths certificate:certificate];
}

- (void)toastWithMessage:(NSString *)msg
{
    UIFont *font = [UIFont systemFontOfSize:14];

    // horizontally center toast and bottom align in single char widget view
    CGSize size = [msg sizeWithFont:font];
    NSUInteger width = size.width + TOAST_HORIZONTAL_MARGIN*2;
    NSUInteger height = size.height + TOAST_VERTICAL_MARGIN*2;
    NSUInteger x = (CGRectGetWidth(self.singleCharWidget.frame) - width) / 2;
    NSUInteger y = (CGRectGetMaxY(self.singleCharWidget.frame) - height) - 48;
    CGRect rect = CGRectMake(x, y, width, height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    
    [self.view addSubview:label];

    [UIView animateWithDuration:3.0f
                     animations:^{
                         label.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [label removeFromSuperview];
                     }];
}

- (NSString *)replaceInvisibleCharactersWithString:(NSString *)text {
    NSMutableString *result = [text mutableCopy];
  
    // replace regular spaces to make them visible
    [result replaceOccurrencesOfString:@" " withString:@"\u2423" options:0 range:NSMakeRange(0, result.length)];
    // replace regular carriage returns to make them visible
    [result replaceOccurrencesOfString:@"\n" withString:@"\u00B6" options:0 range:NSMakeRange(0, result.length)];

    // replace down-then-left gestures (LTR languages)
    [result replaceOccurrencesOfString:@"\U000F0004" withString:@"\u21B2" options:0 range:NSMakeRange(0, result.length)];
    // replace down-then-right gesture (RTL languages)
    [result replaceOccurrencesOfString:@"\U000F0008" withString:@"\u21B3" options:0 range:NSMakeRange(0, result.length)];
    
    // replace left-to-right gesture
    [result replaceOccurrencesOfString:@"\U000F0003" withString:@"\u2192" options:0 range:NSMakeRange(0, result.length)];
    // replace right-to-left gestures
    [result replaceOccurrencesOfString:@"\U000F0002" withString:@"\u2190" options:0 range:NSMakeRange(0, result.length)];
  
    return result;
}

@end
