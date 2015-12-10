// Copyright MyScript

#import "ViewController.h"

@interface ViewController ()

- (void)nextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textInputViewController = [[TextInputViewController alloc] initWithNibName:@"InputView-iphone" bundle:[NSBundle mainBundle]];
    self.textInputViewController.delegate = self;
    
    self.textView.inputView = self.textInputViewController.view;
    self.emailView.inputView = self.textInputViewController.view;
    self.numberView.inputView = self.textInputViewController.view;
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender {
    NSLog(@"Background tap");
    
    [self.view endEditing:YES];
}

- (void)nextView {
    UITextView *nextView = nil;
    
    if (self.activeView == self.textView) {
        nextView = self.emailView;
    } else if (self.activeView == self.emailView) {
        nextView = self.numberView;
    } else if (self.numberView == self.numberView) {
        nextView = self.textView;
    }
    
    [nextView becomeFirstResponder];
}

// ----------------------------------------------------------------------
#pragma mark - UITextView delegate methods
// ----------------------------------------------------------------------

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSUInteger index = textView.text.length;
    self.activeView = textView;
    self.textInputViewController.text = textView.text;
    self.textInputViewController.insertIndex = index;
    textView.selectedRange = NSMakeRange(index, 0);
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (!self.textInputViewController.isRecognizing) {
        NSUInteger index = textView.selectedRange.location + textView.selectedRange.length;
        self.textInputViewController.insertIndex = index;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!self.textInputViewController.isRecognizing) {
        NSUInteger index = textView.selectedRange.location + textView.selectedRange.length;
        self.textInputViewController.text = textView.text;
        self.textInputViewController.insertIndex = index;
        textView.selectedRange = NSMakeRange(index, 0);
    }
}

// ----------------------------------------------------------------------
#pragma mark - Input view controller delegate methods
// ----------------------------------------------------------------------

- (void)textInputViewController:(TextInputViewController *)sender didChangeText:(NSString *)text {
    self.activeView.text = text;
    self.activeView.selectedRange = NSMakeRange(sender.insertIndex, 0);
}

- (void)textInputViewControllerReturnButtonTap:(TextInputViewController *)sender {
    [self nextView];
}

@end
