// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>

@class ITFFilesViewController;

@protocol ITFFilesViewControllerDelegate <NSObject>

- (void)itfFilesViewController:(ITFFilesViewController*)itfFilesViewController didChooseFile:(NSString*)filePath;

@end

@interface ITFFilesViewController : UITableViewController

@property (nonatomic, weak) id<ITFFilesViewControllerDelegate>delegate;
@property (nonatomic, strong) UIPopoverController *parentPopopController;

@end
