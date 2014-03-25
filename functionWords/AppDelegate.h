//
//  AppDelegate.h
//  functionWords
//
//  Created by Michelle Cortese on 2014-01-28.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CGFloat happy;
    CGFloat sad;
    CGFloat angry;
    CGFloat power;
    BOOL truth;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CGFloat globalHappy;
@property (nonatomic) CGFloat globalSad;
@property (nonatomic) CGFloat globalAngry;
@property (nonatomic) CGFloat globalPower;
@property (nonatomic) BOOL globalTruth;

@end