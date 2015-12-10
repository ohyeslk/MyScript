//
//  SJSEdgeNode.h
//  GraphVisualizer
//
//  Created by Kai Lu on 2/16/15.
//  Copyright (c) 2015 Kai Lu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SJSWordNode.h"

@interface SJSEdgeNode : SKShapeNode

- (id)initWithNodeA:(SJSWordNode *)nodeA withNodeB:(SJSWordNode *)nodeB;

- (void)update;

@end
