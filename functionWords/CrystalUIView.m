//
//  CrystalUIView.m
//  functionWords
//
//  Created by Michelle Cortese on 2014-03-19.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//

#import "CrystalUIView.h"
#import "AppDelegate.h"

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
    // access global data
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    // gradient initialization
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[4] = { 0.05, 0.45, 0.55, 0.95 };
    // allocation of gradient alpha
    float sadAlpha = appDelegate.globalSad;
    float happyAlpha = appDelegate.globalHappy;
    float angryyAlpha = appDelegate.globalAngry;
    // rgb colors
    UIColor *sadColor = [UIColor colorWithRed:0.43 green:0.38 blue:0.68 alpha:sadAlpha];
    UIColor *happyColor = [UIColor colorWithRed:0.96 green:0.84 blue:0.51 alpha:happyAlpha];
    UIColor *angryColor = [UIColor colorWithRed:0.89 green:0.26 blue:0.44 alpha:angryyAlpha];
    // gradient color order
    NSArray *colors = @[(id) sadColor.CGColor,
                        (id) happyColor.CGColor,
                        (id) happyColor.CGColor,
                        (id) angryColor.CGColor];
    // draw gradient
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    CGPoint startPoint, endPoint;
    startPoint.x = 160; startPoint.y = 0.0; endPoint.x = 160; endPoint.y = 568;
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // allocation of truth/power variables
    float powerAmount = (appDelegate.globalPower)*100; // amount of points
    bool truthCurve = appDelegate.globalTruth; // bezier curves on/off
    
    // draw shape
    if(truthCurve == false){
        // draw with angles
    } else {
        // draw with curves
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(redraw) userInfo:nil repeats:YES];
}

- (void)redraw // update draw loop
{
    [self setNeedsDisplay];
}


/*
 
 // generate random points
 CGPoint randomPoint;
 randomPoint.x = arc4random() % 320;
 randomPoint.y = arc4random() % 568;
 
 // crystal tests
 CGContextSetLineWidth(context, 0.75);
 CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
 
 CGContextMoveToPoint(context, randomPoint.x, randomPoint.y);
 CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);
 CGContextMoveToPoint(context, 100, 400);
 CGContextAddQuadCurveToPoint(context, 250, 110, 200, 400);
 CGContextStrokePath(context);

}*/

@end
