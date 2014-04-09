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
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]; // allocation of speech data
    [self backgroundGradient:context];
    [self backgroundFrame:context];
    
    /*
    float sadAlpha = appDelegate.globalSad;
    float happyAlpha = appDelegate.globalHappy;
    float angryAlpha = appDelegate.globalAngry;
    float wordCount = appDelegate.globalWordCount;
    bool powerRotate = appDelegate.globalPower; bool truthFill = appDelegate.globalTruth; */
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
    
    UIColor *whiteGrad = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    UIColor *blackGrad = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    NSArray *gradColors =    @[(id) whiteGrad.CGColor, (id) blackGrad.CGColor ];
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorspace,(CFArrayRef)gradColors, locations);
    
    CGPoint startPoint, endPoint;
    startPoint.x = 400;startPoint.y = 0;
    endPoint.x = 0;endPoint.y = 580;
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}

@end
