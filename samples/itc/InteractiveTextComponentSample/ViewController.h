// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import "InkCaptureView.h"
#import "ITFFilesViewController.h"
#import "SelectPageInterpreterViewController.h"
#import "GesturesTableViewController.h"
#import "PenTableViewController.h"
#import "ITCSampleWord.h"
#import "GestureManager.h"
#import "DisplayViewController.h"
#import "SelectionView.h"
#import "PageView.h"

@class DisplayViewController;

@interface ViewController : UIViewController<InkCaptureDelegate, ITFFilesViewControllerDelegate, SelectPageInterpreterViewControllerDelegate, PenSelectionDelegate, SelectionViewDelegate, PageViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITextView *resultTextView;
@property (nonatomic, assign) NSInteger indexCurrentPageInterpreter;
@property (nonatomic, assign) BOOL isRecoPen;
@property (nonatomic, strong) GestureManager *gestureManager;
@property (strong, nonatomic) DisplayViewController *displayViewController;

@property (nonatomic, strong) NSString *wordterm;


- (void)changeColor;
- (void)clear;
- (BOOL)checkWords:(NSArray *)smartWords insideBoundsoffsetX:(float)x offsetY:(float)y;

- (void)guidelinesChangedAction:(bool)isOn;
- (void)candidateChangedAction:(bool)isOn;
- (void)ITFDebugChangedAction:(bool)isOn;
- (void)saveCurrentPageToITFWithName:(NSString*)aFilename;
- (void)typesetPage;

- (void)showNotification:(NSString*)aNotification;

- (void)configureCurrentPageInterpreterWithLanguage:(NSString*)aLanguageName andResources:(NSArray*)resources;

@end
