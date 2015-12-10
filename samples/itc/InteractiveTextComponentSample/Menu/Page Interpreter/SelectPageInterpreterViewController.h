// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>

@class SelectPageInterpreterViewController;
@protocol SelectPageInterpreterViewControllerDelegate <NSObject>

@required
/**
 *  Fire when the page manager must be changed
 *
 *  @param selectPageViewController the current SelectPageViewController
 *  @param index                   the index of the new Page manager (index of an array)
 */
- (void)selectPageInterpreterViewController:(SelectPageInterpreterViewController *)selectPageInterpreterViewController didChangePageInterpreterIndex:(NSInteger)index;

@end

@interface SelectPageInterpreterViewController : UITableViewController

@property (nonatomic, strong) UIPopoverController *parentPopopController;
@property (nonatomic, weak) id<SelectPageInterpreterViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger indexCurrentPageInterpreter;

@end
