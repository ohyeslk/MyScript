//
//  SJSMainViewController.h
//  TheSaurus
//
//  Created by Kai Lu on 2015-05-22.
//  Copyright (c) 2015 Kai Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSViewController.h"

@interface SJSMainViewController : UIViewController<UISearchBarDelegate>
@property (nonatomic, strong) NSString *wordterm;

- (SJSGraphScene*)graphScene;
@end
