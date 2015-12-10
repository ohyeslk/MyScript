// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>

@class PenTableViewController;
@protocol PenSelectionDelegate <NSObject>

@required
/**
 *  Fire when the pen change
 *
 *  @param penTableViewController the current PenTableViewController
 *  @param recoPen YES if the reco pen is used, NO otherwise
 */
- (void)penTableViewController:(PenTableViewController *)penTableViewController didChangePen:(BOOL)recoPen;

@end

@interface PenTableViewController : UITableViewController

@property (nonatomic, assign) BOOL isRecoPen;
@property (nonatomic, weak) id<PenSelectionDelegate> delegate;

@end
