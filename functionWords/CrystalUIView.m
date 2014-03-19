//
//  CrystalUIView.m
//  functionWords
//
//  Created by Michelle Cortese on 2014-03-19.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//

#import "CrystalUIView.h"

@implementation CrystalUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[4] = { 0.0, 0.25, 0.5, 0.75 };
    
    NSArray *colors = @[(id)[UIColor redColor].CGColor,
                        (id)[UIColor greenColor].CGColor,
                        (id)[UIColor blueColor].CGColor,
                        (id)[UIColor yellowColor].CGColor];
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColors(colorspace,
                                          (CFArrayRef)colors, locations);
    
    CGPoint startPoint, endPoint;
    startPoint.x = 0.0;
    startPoint.y = 0.0;
    
    endPoint.x = 500;
    endPoint.y = 500;
    
    CGContextDrawLinearGradient(context, gradient,
                                startPoint, endPoint, 0); 
}

@end
