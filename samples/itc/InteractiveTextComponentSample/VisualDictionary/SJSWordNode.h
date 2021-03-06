//
//  SJSWordNode.h
//  GraphVisualizer
//
//  Created by Kai Lu on 2/13/15.
//  Copyright (c) 2015 Kai Lu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SJSTheme.h"
#import "SJSEnums.h"

@interface SJSWordNode : SKLabelNode

@property enum NodeType type;
@property NSInteger distance;
@property (readonly) NSArray *neighbourNames;

- (id)initWordWithName:(NSString *)name;
- (id)initMeaningWithName:(NSString *)name;

- (void)update;

- (void)updateDistances;

- (void)disableDynamic;

- (void)enableDynamic;

- (void)promoteToRoot;

- (NSArray *)neighbourNodes;

- (BOOL)isConnectedTo:(SJSWordNode *)node;

- (void)grow;

- (NSMutableAttributedString *)getDefinition;

- (void)setRemove:(BOOL)remove;
- (BOOL)remove;

- (void)highlight;
- (void)reset;

@end
