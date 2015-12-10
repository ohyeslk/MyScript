//
//  ViewController.h
//  GeometryWidgetTest
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import <AtkGew/GeometryWidget.h>
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <GWGeometryViewDelegate>

@property (strong, nonatomic) GWGeometryView *geometryView;

@end