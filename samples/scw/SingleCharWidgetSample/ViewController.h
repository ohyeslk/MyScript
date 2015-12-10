// Copyright MyScript

#import <UIKit/UIKit.h>

#import "TextInputViewController.h"

@interface ViewController : UIViewController <UITextViewDelegate, TextInputViewControllerDelegate>

@property (nonatomic) UITextView *activeView;

@property (nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) IBOutlet UITextView *emailView;
@property (nonatomic) IBOutlet UITextView *numberView;

@property (nonatomic) TextInputViewController *textInputViewController;

- (IBAction)backgroundTap:(id)sender;

@end
