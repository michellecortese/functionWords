//
//  LogUIView.m
//  functionWords
//
//  Created by Michelle Cortese on 2014-04-08.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//

#import "LogUIView.h"
#import "AppDelegate.h"

@implementation LogUIView

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]; // allocation of speech data
    bool truthFill = appDelegate.globalTruth;
    bool powerRotate = appDelegate.globalPower;
    float sadAlpha = appDelegate.globalSad;float happyAlpha = appDelegate.globalHappy;
    float angryAlpha = appDelegate.globalAngry;
    
    UIColor *sadColor = [UIColor colorWithRed:0.32 green:0.93 blue:0.78 alpha:0.01+sadAlpha];
    UIColor *happyColor = [UIColor colorWithRed:1.0 green:0.58 blue:0.00 alpha:0.01+happyAlpha];
    UIColor *angryColor = [UIColor colorWithRed:1.0 green:0.37 blue:0.23 alpha:0.01+angryAlpha];
    
    [self colorCircles:context colSad:sadColor colHap:happyColor colAng:angryColor];
    [self backgroundGradient:context];
    [self backgroundFrame:context];
    
    if (powerRotate == true) {
        [self confidenceArrowUp:context];
    } else if (powerRotate == false) {
        [self confidenceArrowDown:context];
    } else {
        [self confidenceArrowUp:context];
    }
    
    if (truthFill == true) {
        [self honestyCircle:context];
    } else if (truthFill == false) {
        [self disHonestyCircle:context];
    } else {
        [self honestyCircle:context];
    }
    
    // timed refresh
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(redraw) userInfo:nil repeats:YES];
}

- (void)redraw // update draw loop on interval determined in drawrect
{
    [self setNeedsDisplay];
}

- (void)confidenceArrowUp:(CGContextRef)context
{
    CGContextSetLineWidth(context, 0.75);
    CGContextSetAlpha(context, 1.0);
    CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, 235, 404);
    CGContextAddLineToPoint(context, 235, 446);
    CGContextMoveToPoint(context, 205, 442);
    CGContextAddLineToPoint(context, 235, 404);
    CGContextAddLineToPoint(context, 265, 442);
    CGContextStrokePath(context);
}

- (void)confidenceArrowDown:(CGContextRef)context
{
    CGContextSetLineWidth(context, 0.75);
    CGContextSetAlpha(context, 1.0);
    CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, 235, 404);
    CGContextAddLineToPoint(context, 235, 446);
    CGContextMoveToPoint(context, 210, 408);
    CGContextAddLineToPoint(context, 235, 446);
    CGContextAddLineToPoint(context, 260, 408);
    CGContextStrokePath(context);
}

- (void)colorCircles:(CGContextRef)context colSad:(UIColor*)sadColor colHap:(UIColor*)happyColor colAng:(UIColor*)angryColor {
    CGContextSetFillColorWithColor(context,sadColor.CGColor);
    CGRect sad = CGRectMake(147,268,10,10);
    CGContextAddEllipseInRect(context, sad);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context,happyColor.CGColor);
    CGRect hap = CGRectMake(147,290,10,10);
    CGContextAddEllipseInRect(context, hap);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context,angryColor.CGColor);
    CGRect ang = CGRectMake(147,311,10,10);
    CGContextAddEllipseInRect(context, ang);
    CGContextFillPath(context);
}

-(void)honestyCircle: (CGContextRef)context {
    CGContextSetAlpha(context, 1.0);
    CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
    CGRect rectangle = CGRectMake(197,254,82,82);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextFillPath(context);
}

-(void)disHonestyCircle: (CGContextRef)context {
    CGContextSetAlpha(context, 1.0);
    CGContextSetLineWidth(context, 0.75);
    CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);
    CGRect rectangle = CGRectMake(197,254,82,82);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);
}

-(void)backgroundFrame: (CGContextRef)context
{
    CGContextSetLineWidth(context, 0.25);
    CGContextSetAlpha(context, 1.0);
    CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, 35, 140);
    CGContextAddLineToPoint(context, 290, 140);
    CGContextMoveToPoint(context, 35, 185);
    CGContextAddLineToPoint(context, 290, 185);
    CGContextStrokePath(context);
}

- (void)backgroundGradient:(CGContextRef)context
{
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[2] = { 0.2, 0.9 };
    
    UIColor *whiteGrad = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.15];
    UIColor *blackGrad = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
    NSArray *gradColors =    @[(id) whiteGrad.CGColor, (id) blackGrad.CGColor ];
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorspace,(CFArrayRef)gradColors, locations);
    
    CGPoint startPoint, endPoint;
    startPoint.x = 400;startPoint.y = 0;
    endPoint.x = 0;endPoint.y = 580;
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}

@end
