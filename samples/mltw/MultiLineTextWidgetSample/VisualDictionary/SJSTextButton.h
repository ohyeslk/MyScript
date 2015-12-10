//
//  SJSTextButton.h
//  VisualDictionary
//
//  Created by Kai Lu on 3/29/15.
//  Copyright (c) 2015 Kai Lu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SJSTheme.h"
#import "SJSEnums.h"

@interface SJSTextButton : SKShapeNode

- (SJSTextButton *)init;
- (void)update;
- (void)setFrame:(CGRect)frame;
- (void)setLabelText:(NSString *)text;
- (void)setIconText:(NSString *)text;
- (void)setIconFontName:(NSString *)fontName;

@end
