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
    if (self) { // initialization
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[3] = { 0.20, 0.50, 0.80 };
    
    NSArray *colors = @[(id)[UIColor cyanColor].CGColor,
                        (id)[UIColor yellowColor].CGColor,
                        (id)[UIColor magentaColor].CGColor];
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    CGPoint startPoint, endPoint;
    startPoint.x = 160; startPoint.y = 0.0;
    endPoint.x = 160; endPoint.y = 568;
    CGContextDrawLinearGradient(context, gradient,
                                startPoint, endPoint, 0);
    
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 10, 200);
    CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);
    CGContextStrokePath(context);
}

@end
