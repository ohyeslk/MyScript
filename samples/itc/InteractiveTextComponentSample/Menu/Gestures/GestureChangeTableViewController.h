// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import <AtkItc/ITC.h>
#import "ITCSampleGestureData.h"
#import "GesturesTableViewController.h"

@interface GestureChangeTableViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style andGestureType:(ITCGestureType)gestureType;

@property (nonatomic, strong) ITCSampleGestureData *gestureData;
@property (nonatomic, weak) id<GesturesTableViewControllerDelegate> delegate;

@end
