// Copyright MyScript. All right reserved.

#import <UIKit/UIKit.h>
#import <AtkItc/ITC.h>

@class ITCSmartPage, ViewController;

@interface DisplayViewController : UIViewController <ITCSmartPageChangeDelegate>

@property (nonatomic, retain) ITCSmartPage *page;
@property (nonatomic, weak) ViewController *viewController;
@property (nonatomic, assign, readonly) NSInteger lineCount;


- (void)showGuidelines:(BOOL)showGuidelines;

- (void)showCandidate:(BOOL)showCandidate;


- (void)removeUnderlineToSmartWord:(ITCSmartWord *)word;
- (void)createSelectionForWordRange:(ITCWordRange *)wordRange;
- (void)addUnderlineToSmartWord:(ITCSmartWord *)itcSmartWord;


@end
