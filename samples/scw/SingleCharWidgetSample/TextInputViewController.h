// Copyright MyScript

#import <UIKit/UIKit.h>

#import <AtkScw/SingleCharWidget.h>

@class TextInputViewController;

@protocol TextInputViewControllerDelegate <NSObject>

- (void)textInputViewController:(TextInputViewController *)sender didChangeText:(NSString *)text;
- (void)textInputViewControllerReturnButtonTap:(TextInputViewController *)sender;

@end

@interface TextInputViewController : UIViewController <SCWSingleCharViewDelegate>

@property (nonatomic, weak) id<TextInputViewControllerDelegate> delegate;

@property (nonatomic, readwrite) NSArray        *languages;
@property (nonatomic, readwrite) NSString       *languageSelected;

@property (nonatomic, readonly) BOOL            isRecognizing;

@property (nonatomic) IBOutlet UIScrollView     *candidateLayout;
@property (nonatomic) IBOutlet SCWSingleCharView *singleCharWidget;

- (void)setText:(NSString *)text;
- (NSString *)text;
- (void)setInsertIndex:(NSUInteger)index;
- (NSUInteger)insertIndex;

- (IBAction)languageButtonTap:(id)sender;
- (IBAction)deleteButtonTap:(id)sender;
- (IBAction)spaceButtonTap:(id)sender;
- (IBAction)returnButtonTap:(id)sender;

@end
