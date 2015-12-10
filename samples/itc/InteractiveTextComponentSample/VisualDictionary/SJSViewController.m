//
//  SJSViewController.m
//  GraphVisualizer
//
//  Created by Kai Lu on 2/9/15.
//  Copyright (c) 2015 Kai Lu. All rights reserved.
//

#import "SJSViewController.h"

@implementation SJSViewController {
    SJSGraphScene *_graphScene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *skView = (SKView *) self.view;
    skView.ignoresSiblingOrder = YES;

    _graphScene = [SJSGraphScene sceneWithSize:skView.bounds.size];
    [skView presentScene:_graphScene];
}

- (SJSGraphScene*)graphScene
{
    return _graphScene;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake) {
        [_graphScene createSceneForRandomWord];
    }
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"Panning!");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
