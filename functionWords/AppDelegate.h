//
//  AppDelegate.h
//  functionWords
//
//  Created by Michelle Cortese on 2014-01-28.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CGFloat globalWordCount;
    CGFloat happy;
    CGFloat sad;
    CGFloat angry;
    bool power;
    bool truth;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CGFloat globalWordCount;
@property (nonatomic) CGFloat globalHappy;
@property (nonatomic) CGFloat globalSad;
@property (nonatomic) CGFloat globalAngry;
@property (nonatomic) bool globalPower;
@property (nonatomic) bool globalTruth;

@end