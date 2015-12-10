// Copyright MyScript. All rights reserved.

#import <AtkSltw/SLTWTextWidget.h>

@interface ViewController : UIViewController<SLTWTextWidgetDelegate, UITextViewDelegate, UITextFieldDelegate>
{
  SLTWTextWidget *_textWidget;
  UITextView *_meetingsField;
  UIView *_activeField;
  UIView *_nextField;
  UIView *_parentView;
  UIView *_candidatesBar;
  UIView *_barAction;
  NSUInteger _indexCursor;
  BOOL _isRecognizerBusy;
  NSMutableString *_textInField;
    
  NSData *_certificate;

  NSUInteger _selectedIndex;
  NSRange _selectedWordRange;
  NSArray *_selectedWordLabels;
}

@property (nonatomic, weak) IBOutlet UITextField    *firstNameField;
@property (nonatomic, weak) IBOutlet UITextField    *lastNameField;
@property (nonatomic, strong) IBOutlet UITextView   *meetingsField;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView                *candidatesBar;
@property (strong, nonatomic) UIView                *barAction;
@property (nonatomic, assign) NSUInteger            indexCursor;
@property (nonatomic, assign) BOOL                  isRecognizerBusy;
@property (nonatomic) NSMutableString               *textInField;


- (IBAction)selectCandidate:(id)sender;

@end
