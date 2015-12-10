//
//  SJSDefinitionsView.h
//  GraphVisualizer
//
//  Created by Kai Lu on 2/17/15.
//  Copyright (c) 2015 Kai Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJSDefinitionsView : UIView

- (void)setText:(NSAttributedString *)text;

- (void)update;

- (void)open;

- (void)close;

@end
