//
//  MCCrystalViewController.h
//  functionWords
//
//  Created by Michelle Cortese on 2014-03-18.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//

#import <UIKit/UIKit.h>//

@class MCCrystalViewController;

@protocol MCCrystalViewControllerDelegate <NSObject>
@required
- (void)crystalViewControllerDidFinish:(MCCrystalViewController *)viewController;
@end

@interface MCCrystalViewController : UIViewController
@property (nonatomic, weak) id<MCCrystalViewControllerDelegate> dismissDelegate;
- (IBAction)dismiss:(id)sender;
@end
