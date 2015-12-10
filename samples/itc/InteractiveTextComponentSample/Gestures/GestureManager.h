// Copyright MyScript. All right reserved.

#import <Foundation/Foundation.h>
#import <AtkItc/ITC.h>
#import "GestureChangeTableViewController.h"

@class ViewController;

@interface GestureManager : NSObject<ITCSmartPageGestureDelegate, GesturesTableViewControllerDelegate>

@property (nonatomic, strong) ITCPageInterpreter *pageInterpreter;
@property (nonatomic, strong) ITCWordFactory *wordFactory;
@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) NSMutableArray *itcSampleGestureData;
@property (nonatomic, assign) BOOL guidelinesActivated;

- (void)applyGestureOnPageInterpreter:(ITCPageInterpreter *)pageInterpreter;

@end
