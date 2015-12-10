//
//  SJSEdgeNode.m
//  GraphVisualizer
//
//  Created by Kai Lu on 2/16/15.
//  Copyright (c) 2015 Kai Lu. All rights reserved.
//

#import "SJSEdgeNode.h"
#import "SJSGraphScene.h"

@implementation SJSEdgeNode {
    SJSWordNode *_nodeA;
    SJSWordNode *_nodeB;
}

- (id)initWithNodeA:(SJSWordNode *)nodeA withNodeB:(SJSWordNode *)nodeB
{
    self = [super init];
    
    if (self) {
        _nodeA = nodeA;
        _nodeB = nodeB;
        [self update];
    }
    
    return self;
}

- (void)update
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, _nodeA.position.x, _nodeA.position.y);
    CGPathAddLineToPoint(path, nil, _nodeB.position.x, _nodeB.position.y);
    self.path = path;
    CGPathRelease(path);
    
    self.lineWidth = [SJSGraphScene.theme lineWidth];
    self.strokeColor = [SJSGraphScene.theme edgeColor];
}

@end
