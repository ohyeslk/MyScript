// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import <AtkItc/ITC.h>

@class GesturesTableViewController;

@protocol GesturesTableViewControllerDelegate <NSObject>

- (void)gestureType:(ITCGestureType)gestureType didEnable:(BOOL)isEnable;

- (void)gestureType:(ITCGestureType)gestureType didDefaultProcessing:(BOOL)isDefaultProcessing;

@end

@interface GesturesTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *itcGesturesSampleData;
@property (nonatomic, weak) id<GesturesTableViewControllerDelegate> delegate;

@end
