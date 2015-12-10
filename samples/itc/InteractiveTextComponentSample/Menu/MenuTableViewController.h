// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>

@class ViewController;

@interface MenuTableViewController : UITableViewController

@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) UIPopoverController *parentPopopController;
@property (nonatomic, assign) BOOL isGuidelinesShowed;
@property (nonatomic, assign) BOOL isCandidateShowed;
@property (nonatomic, assign) BOOL isITFDebug;
@property (nonatomic, strong) NSArray *itcGesturesSampleData;

@end
