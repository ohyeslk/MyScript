//
//  GWBrush.h
//  GeometryWidget
//
//  Created by Simon Liotier on 19/06/2014.
//  Copyright (c) 2014 Vision Objects. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWBrush : NSObject

+ (GWBrush *)brushWithInkColor:(UIColor *)color
                      inkWidth:(CGFloat)width
                        dashed:(BOOL)dashed;

@property (strong, nonatomic) UIColor                *inkColor;
@property (assign, nonatomic) CGFloat                 inkWidth;
@property (assign, nonatomic, getter = isDashed) BOOL dashed;

@end