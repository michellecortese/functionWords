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
    CGContextRef context = UIGraphicsGetCurrentContext(); // graphics context

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]; // allocation of speech data
    float sadAlpha = appDelegate.globalSad;
    float happyAlpha = appDelegate.globalHappy;
    float angryAlpha = appDelegate.globalAngry;
    //float wordCount = appDelegate.globalWordCount;
    bool powerRotate = appDelegate.globalPower;
    bool truthFill = appDelegate.globalTruth;
    
    // rgb gradient colors
    UIColor *sadColor1 = [UIColor colorWithRed:0.32 green:0.93 blue:0.78 alpha:sadAlpha];
    UIColor *sadColor2 = [UIColor colorWithRed:0.35 green:0.78 blue:0.98 alpha:sadAlpha];
        NSArray *sadColors =    @[(id) sadColor1.CGColor, (id) sadColor2.CGColor ];
    UIColor *happyColor1 = [UIColor colorWithRed:1.0 green:0.58 blue:0.00 alpha:happyAlpha];
    UIColor *happyColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:0.45 alpha:happyAlpha];
        NSArray *happyColors =  @[(id) happyColor1.CGColor,(id) happyColor2.CGColor ];
    UIColor *angryColor1 = [UIColor colorWithRed:1.0 green:0.37 blue:0.23 alpha:angryAlpha];
    UIColor *angryColor2 = [UIColor colorWithRed:1.0 green:0.16 blue:0.40 alpha:angryAlpha];
        NSArray *angryColors =  @[(id) angryColor1.CGColor,(id) angryColor2.CGColor ];

    [self drawBackground:rect gradColSad:sadColors gradColHap:happyColors gradColAng:angryColors inContext:context];
    
    // draw truth as fill and power as rotation
    if(truthFill == true){
        CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
        if(powerRotate == true){
            [self drawTriangleUp:context];
        } else if(powerRotate == false) {
            [self drawTriangleDown:context];
        } CGContextFillPath(context);
    } else if (truthFill == false){
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
        if(powerRotate == true){
            [self drawTriangleUp:context];
        } else if(powerRotate == false) {
            [self drawTriangleDown:context];
        } CGContextStrokePath(context);
    }
    
    // timed refresh
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(redraw) userInfo:nil repeats:YES];
}

- (void)redraw // update draw loop on interval determined in drawrect
{
    [self setNeedsDisplay];
}

- (void)drawTriangleUp:(CGContextRef)context
{
    CGContextSetAlpha(context, 1.0);
    CGContextMoveToPoint(context, 168, 135);
    CGContextAddLineToPoint(context, 320, self.center.y);
    CGContextAddLineToPoint(context, 0, self.center.y);
    CGContextAddLineToPoint(context, 168, 135);
}

- (void)drawTriangleDown:(CGContextRef)context
{
    CGContextSetAlpha(context, 1.0);
    CGContextMoveToPoint(context, 152, 433);
    CGContextAddLineToPoint(context, 320, self.center.y);
    CGContextAddLineToPoint(context, 0, self.center.y);
    CGContextAddLineToPoint(context, 152, 433);
}

- (void)drawBackground:(CGRect)rect gradColSad:(NSArray*)sadColors gradColHap:(NSArray*)happyColors gradColAng:(NSArray*)angryColors inContext:(CGContextRef)context
{
    CGFloat sadLocations[2] = { 0.0, 0.45 };
    CGFloat happyLocations[2] = { 0.25, 0.75 };
    CGFloat angryLocations[2] = { 0.65, 1.0 };
    //sad gradient
    CGColorSpaceRef sadBaseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef sadGradient = CGGradientCreateWithColors(sadBaseSpace, (CFArrayRef)sadColors, sadLocations);
    CGContextSetLineWidth(context, 0.25);
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    CGColorSpaceRelease(sadBaseSpace), sadBaseSpace = NULL;
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextAddLineToPoint(context, 320, self.center.y);
    CGContextAddLineToPoint(context, 30, 0);
    CGContextClip(context);
    CGPoint sadStartPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint sadEndPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, sadGradient, sadStartPoint, sadEndPoint, 0);
    CGGradientRelease(sadGradient), sadGradient = NULL;
    CGContextRestoreGState(context);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextAddLineToPoint(context, 320, self.center.y);
    CGContextAddLineToPoint(context, 30, 0);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextStrokePath(context);
    //happy gradient
    CGColorSpaceRef happyBaseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef happyGradient = CGGradientCreateWithColors(happyBaseSpace,
                                  (CFArrayRef)happyColors, happyLocations);
    CGColorSpaceRelease(happyBaseSpace), happyBaseSpace = NULL;
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 320, self.center.y);
    CGContextAddLineToPoint(context, 320, 568);
    CGContextAddLineToPoint(context, 290, 568);
    CGContextAddLineToPoint(context, 0, self.center.y);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 30, 0);
    CGContextClip(context);
    CGPoint happyStartPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint happyEndPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, happyGradient, happyStartPoint, happyEndPoint, 0);
    CGGradientRelease(happyGradient), happyGradient = NULL;
    CGContextRestoreGState(context);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 320, self.center.y);
    CGContextAddLineToPoint(context, 320, 568);
    CGContextAddLineToPoint(context, 290, 568);
    CGContextAddLineToPoint(context, 0, self.center.y);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 30, 0);
    CGContextDrawPath(context, kCGPathStroke);
    //angry gradient
    CGColorSpaceRef angryBaseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef angryGradient = CGGradientCreateWithColors(angryBaseSpace,
                                  (CFArrayRef)angryColors, angryLocations);
    CGContextSetLineWidth(context, 0.25);
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    CGColorSpaceRelease(angryBaseSpace), angryBaseSpace = NULL;
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 0, self.center.y);
    CGContextAddLineToPoint(context, 290, 568);
    CGContextAddLineToPoint(context, 0, 568);
    CGContextAddLineToPoint(context, 0, self.center.y);
    CGContextClip(context);
    CGPoint angryStartPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint angryEndPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, angryGradient, angryStartPoint, angryEndPoint, 0);
    CGGradientRelease(angryGradient), angryGradient = NULL;
    CGContextRestoreGState(context);
    CGContextMoveToPoint(context, 0, self.center.y);
    CGContextAddLineToPoint(context, 290, 568);
    CGContextAddLineToPoint(context, 0, 568);
    CGContextAddLineToPoint(context, 0, self.center.y);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextStrokePath(context);
    // highlight top
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextSetAlpha(context, 0.1);
    CGContextMoveToPoint(context, 320, 0);
    CGContextAddLineToPoint(context, 0, self.center.y);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextFillPath(context);
    // highlight bottom
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextSetAlpha(context, 0.1);
    CGContextMoveToPoint(context, 320, self.center.y);
    CGContextAddLineToPoint(context, 320, 568);
    CGContextAddLineToPoint(context, 0, 568);
    CGContextAddLineToPoint(context, 320, self.center.y);
    CGContextFillPath(context);
}


@end
