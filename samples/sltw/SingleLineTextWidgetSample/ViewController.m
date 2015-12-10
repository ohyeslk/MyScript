// Copyright MyScript. All rights reserved.

#import "ViewController.h"

#import "MyCertificate.h"

//================================================================================
#pragma mark - Configuration
//================================================================================

@interface ViewController ()

- (void)refreshCandidatesBar;

@end

@implementation ViewController

//================================================================================
#pragma mark - Properties
//================================================================================

@synthesize meetingsField = _meetingsField;
@synthesize candidatesBar = _candidatesBar;
@synthesize barAction = _barAction;
@synthesize indexCursor = _indexCursor;
@synthesize isRecognizerBusy = _isRecognizerBusy;
@synthesize textInField = _textInField;
@synthesize scrollView = _scrollView;

//================================================================================
#pragma mark - View controller life cycle
//================================================================================

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load handwriting certificate
    
    _certificate = [NSData dataWithBytes:myCertificate.bytes length:myCertificate.length];
    
    _indexCursor = -1;
    _isRecognizerBusy = NO;
    _textInField = [[NSMutableString alloc] initWithString:@""];
    
    _parentView = self.view;
    _parentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_parentView setAutoresizesSubviews:YES];
    
    _candidatesBar = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 40)];
    _candidatesBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _candidatesBar.backgroundColor = [UIColor blackColor];
    
    _barAction = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 84)];
    _barAction.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _barAction.backgroundColor = [UIColor blackColor];
    
    _textWidget = [[SLTWTextWidget alloc] init];
    _textWidget.delegate = self;
    
    [_textWidget setWritingAreaBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sltw_bg_pattern.png"]]];

    // configure text widget
    
    [_textWidget configureWithLocale:@"en_US"
                           resources:[self resourcesForLocale:@"en_US"]
                             lexicon:NULL
                         certificate:_certificate];
    
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    _meetingsField.delegate = self;
    
    [_barAction addSubview:[self keyboardToolBar]];
    [_barAction addSubview:_candidatesBar];
    
    _firstNameField.inputAccessoryView = _barAction;
    _lastNameField.inputAccessoryView = _barAction;
    _meetingsField.inputAccessoryView = _barAction;
    
    [self _setInputView:_textWidget.view forTextField:_firstNameField];
    [self _setInputView:_textWidget.view forTextField:_lastNameField];
    
    [_meetingsField setInputView:_textWidget.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_textWidget willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)viewDidLayoutSubviews
{
    [self refreshCandidatesBar];
}

//================================================================================
#pragma mark - Internal functions
//================================================================================

- (IBAction)resizeSizeWidget:(id)sender
{
    NSString *text = _textInField;
    [_textWidget setText:@""];
    
    if (_textWidget.view.frame.size.height == 250) {
        [_textWidget setWidgetHeight:180];
        [_textWidget setBaselinePosition:100];
    } else {
        [_textWidget setWidgetHeight:250];
        [_textWidget setBaselinePosition:150];
    }
    
    if ([_meetingsField isFirstResponder]) {
        _meetingsField.inputView = nil;
        [_meetingsField resignFirstResponder];
        [_meetingsField setInputView:_textWidget.view];
        [_meetingsField becomeFirstResponder];
        [_meetingsField reloadInputViews];
        [self _updateTextViewWithText:text];
    } else {
        _lastNameField.inputView = nil;
        [_lastNameField resignFirstResponder];
        [self _setInputView:_textWidget.view forTextField:_lastNameField];
        [_lastNameField becomeFirstResponder];
        [_lastNameField reloadInputViews];
        [self _updateTextFieldWithText:text];
    }
    [_textWidget setText:text];
    [self refreshCandidatesBar];
    [_meetingsField reloadInputViews];
    [self.view setNeedsLayout];
}

- (void)refreshCandidatesBar
{
    [[_candidatesBar subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat x = (self.view.frame.size.width - 100 * _selectedWordLabels.count) / 2;
    NSUInteger index = 0;
    for (NSString *label in _selectedWordLabels) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(selectCandidate:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:label forState:UIControlStateNormal];
        button.frame = CGRectMake(x, 10, 100, 25);
        [button setBackgroundColor:[UIColor blackColor]];
        [button setTitleColor:[UIColor colorWithRed:0.239f green:0.416f blue:0.855f alpha:1.0f] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTag:index];
        if (index == _selectedIndex) {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
        [_candidatesBar addSubview:button];
        index++;
        x += 100;
    }
}

- (NSArray *)resourcesForLocale:(NSString *)locale
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSArray *en_US = [NSArray arrayWithObjects:
                      [mainBundle pathForResource:@"en_US-ak-cur.lite" ofType:@"res"],
                      [mainBundle pathForResource:@"en_US-lk-text.lite" ofType:@"res"],
                      nil];
    
    return en_US;
}

- (NSArray *)fields
{
    return [NSArray arrayWithObjects:
            _firstNameField,
            _lastNameField,
            _meetingsField,
            nil];
}

- (UIToolbar *)keyboardToolBar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil action:nil];
    UIBarButtonItem *buttonClear = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                    style:UIBarButtonItemStyleBordered target:self action:@selector(clearWidget:)];
    UIBarButtonItem *buttonSpace = [[UIBarButtonItem alloc] initWithTitle:@"Space"
                                                                    style:UIBarButtonItemStyleBordered target:self action:@selector(addSpace:)];
    UIBarButtonItem *buttonDelete = [[UIBarButtonItem alloc] initWithTitle:@"Backspace"
                                                                     style:UIBarButtonItemStyleBordered target:self action:@selector(deleteCharacter:)];
    UIBarButtonItem *resizeWidget = [[UIBarButtonItem alloc] initWithTitle:@"Resize Widget"
                                                                     style:UIBarButtonItemStyleBordered target:self action:@selector(resizeSizeWidget:)];

    
    NSArray *buttons = [NSArray arrayWithObjects: flexibleSpaceLeft, buttonClear, buttonSpace, buttonDelete, resizeWidget, nil];
    
    [toolbar setItems: buttons animated:NO];
    
    return toolbar;
}

- (IBAction)clearWidget:(id)sender
{
    NSString *clear = @"";
    [self updateTextInField:clear];
    [_textWidget setText:clear];
    if ([_meetingsField isFirstResponder]) {
        [self _updateTextViewWithText:clear];
    } else {
        [self _updateTextFieldWithText:clear];
    }
    _indexCursor = -1;
}

- (IBAction)addSpace:(id)sender
{
    if ((_indexCursor <= [_textInField length]) && ([_textInField length] > 0))
    {
        [_textInField insertString:@" " atIndex:_indexCursor];
        _indexCursor++;
        NSUInteger i = _indexCursor;
        [_textWidget replaceCharactersInRange:NSMakeRange(i, 0) replacementString:@" "];
        [_textWidget setText:_textInField];
        if ([_meetingsField isFirstResponder]) {
            [self _updateTextViewWithText:_textInField];
            NSRange range = NSMakeRange(i, 0);
            [self setSelectedRange:range];
        } else {
            [self _updateTextFieldWithText:_textInField];
        }
    }
}

- (IBAction)deleteCharacter:(id)sender
{
    if ((_indexCursor > 0) && (_indexCursor <= [_textInField length]) && ([_textInField length] > 0))
    {
        _indexCursor--;
        NSUInteger i = _indexCursor;
        [_textInField deleteCharactersInRange:NSMakeRange(_indexCursor, 1)];
        [_textWidget setText:_textInField];
        if ([_meetingsField isFirstResponder]) {
            [self _updateTextViewWithText:_textInField];
            NSRange range = NSMakeRange(i, 0);
            [self setSelectedRange:range];
            [_textWidget selectWordAtIndex:range.location];
        } else {
            [self _updateTextFieldWithText:_textInField];
        }
    }
}

- (void)updateTextInField:(NSString *)text
{
    if ([text length] > 0)
    {
        [_textInField setString:text];
    }
}

//================================================================================
#pragma mark - Input view management
//================================================================================

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[_candidatesBar subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_textWidget setText:textField.text];
    [self updateTextInField:textField.text];
    _indexCursor = [textField.text length];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [[_candidatesBar subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_textWidget setText:textView.text];
    [self updateTextInField:textView.text];
    _indexCursor = [textView.text length];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        NSRange range = textView.selectedRange;
       
        [_textWidget centerTo:range.location];
        [_textWidget selectWordAtIndex:range.location];
        _indexCursor = range.location;
    }
}

- (void)_setInputView:(UIView *)inputView forTextField:(UITextField *)textField
{
    //Reset
    [_lastNameField resignFirstResponder];
    [_firstNameField resignFirstResponder];
    
    BOOL isFirstResponder = [textField isFirstResponder];
    
    if (isFirstResponder)
    {
        [textField resignFirstResponder];
    }
    
    textField.inputView = inputView;
    
    if (isFirstResponder)
    {
        [textField becomeFirstResponder];
    }
}

//================================================================================
#pragma mark - Candidates management
//================================================================================

- (IBAction)selectCandidate:(id)sender
{
    UIButton* btn = (UIButton *) sender;
    NSUInteger index = 0;
    for (UIButton *button in _candidatesBar.subviews)
    {
        if (index == [sender tag]) {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
        index++;
    }
    // Replace the candidate
    [_textWidget replaceCharactersInRange:_selectedWordRange replacementString:_selectedWordLabels[btn.tag]];
}

//================================================================================
#pragma mark - TextPanel delegate
//================================================================================

- (void)textWidget:(SLTWTextWidget *)sender didSelectWordInRange:(NSRange)range labels:(NSArray *)labels selectedIndex:(NSUInteger)selectedIndex
{
    NSLog(@"textWidget:didSelectWordInRange:labels:selectedIndex: (range=%d-%d, selectedIndex=%d)",
          (int) range.location,
          (int) range.location + (int) range.length,
          (int) selectedIndex);
    
    if (selectedIndex > (range.location + range.length))
    {
        return;
    }
    
    _selectedIndex = selectedIndex;
    _selectedWordRange = range;
    _selectedWordLabels = labels;

    for (int i=0; i<[labels count]; i++)
    {
        NSLog(@"labels[%d]='%@'", i, [labels objectAtIndex:i]);
    }

    [[_candidatesBar subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat x = (self.view.frame.size.width - 100 * labels.count) / 2;
    NSUInteger index = 0;
    for (NSString *label in labels) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(selectCandidate:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:label forState:UIControlStateNormal];
        button.frame = CGRectMake(x, 10, 100, 25);
        [button setBackgroundColor:[UIColor blackColor]];
        [button setTitleColor:[UIColor colorWithRed:0.239f green:0.416f blue:0.855f alpha:1.0f] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTag:index];
        if (index == selectedIndex)
        {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
        [_candidatesBar addSubview:button];
        index++;
        x += 100;
    }
    _indexCursor = range.location + range.length;
}

- (void)textWidget:(SLTWTextWidget *)sender didUpdateText:(NSString *)text intermediate:(BOOL)intermediate
{
    NSLog(@"textWidgetDidUpdateTextIntermediate (text='%@', intermediate=%@)", text, (intermediate ? @"YES" : @"NO"));
    
    if ([_meetingsField isFirstResponder]) {
        [self _updateTextViewWithText:text];
    } else {
        [self _updateTextFieldWithText:text];
    }
    _indexCursor = [text length];
    [self updateTextInField:text];
}

- (void)textWidgetDidBeginRecognition:(SLTWTextWidget *)sender
{
    NSLog(@"textWidgetDidBeginRecognition");
    _isRecognizerBusy = YES;
}

- (void)textWidgetDidEndRecognition:(SLTWTextWidget *)sender
{
    NSLog(@"textWidgetDidEndRecognition");
    _isRecognizerBusy = NO;
}

- (void)textWidgetDidBeginConfiguration:(SLTWTextWidget *)sender
{
    NSLog(@"textWidgetDidBeginConfiguration");
}

- (void)textWidgetDidEndConfiguration:(SLTWTextWidget *)sender
{
    NSLog(@"textWidgetDidEndConfiguration");
}

- (void)textWidget:(SLTWTextWidget *)sender didDetectSingleTapAtIndex:(NSUInteger)index
{
    NSLog(@"Single tap gesture detected at index %d", (int) index);
    _indexCursor = index;
}

- (void)textWidget:(SLTWTextWidget *)sender didDetectJoinGestureAtIndex:(NSUInteger)index
{
    NSLog(@"Join gesture detected at index %d", (int) index);
    // compute range of spaces to remove
    NSString *text = _textWidget.text;
    NSUInteger left;
    NSUInteger right;
    for (left=index; left>0; left--) {
        if ([text characterAtIndex:left-1] != ' ') {
            break;
        }
    }
    for (right=index; right<text.length; right++) {
        if ([text characterAtIndex:right] != ' ') {
            break;
        }
    }
    
    [_textWidget replaceCharactersInRange:NSMakeRange(left, right-left) replacementString:@""];

}

- (void)textWidget:(SLTWTextWidget *)sender didDetectInsertGestureAtIndex:(NSUInteger)index
{
    NSLog(@"Insert gesture detected at index %d", (int) index);
    [_textWidget replaceCharactersInRange:NSMakeRange(index, 0) replacementString:@" "];
    _indexCursor = index;
}

- (void)textWidget:(SLTWTextWidget *)sender didDetectReturnGestureAtIndex:(NSUInteger)index
{
    NSLog(@"Return gesture detected at index %d", (int) index);
    
    if ([_firstNameField isFirstResponder]) {
        [_lastNameField becomeFirstResponder];
    } else if ([_lastNameField isFirstResponder]) {
        [_meetingsField becomeFirstResponder];
    } else {
        [_firstNameField becomeFirstResponder];
    }
    [[_candidatesBar subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

}

//================================================================================
#pragma mark - TextView utility
//================================================================================

- (void) setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = _meetingsField.beginningOfDocument;
    
    UITextPosition* startPosition = [_meetingsField positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [_meetingsField positionFromPosition:beginning offset:_meetingsField.text.length];
    UITextRange* selectionRange = [_meetingsField textRangeFromPosition:startPosition toPosition:endPosition];
    
    [_meetingsField setSelectedTextRange:selectionRange];
}

//================================================================================
#pragma mark - TextField utility
//================================================================================

- (void)_updateTextFieldWithText:(NSString *)text
{
    if ([_firstNameField isFirstResponder])
    {
        if (![text isEqualToString:_firstNameField.text])
        {
            _firstNameField.text = text;
        }
    } else if ([_lastNameField isFirstResponder])
    {
        if (![text isEqualToString:_lastNameField.text])
        {
            _lastNameField.text = text;
        }
    }
    if ([text length] == 0)
    {
        [[_candidatesBar subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    _indexCursor = [text length];
    [self updateTextInField:text];
}

- (void)_updateTextViewWithText:(NSString *)text
{
    if (_meetingsField)
    {
        _meetingsField.text = text;
    }
    if ([text length] == 0)
    {
        [[_candidatesBar subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    _indexCursor = [text length];
    [self updateTextInField:text];
}

@end
