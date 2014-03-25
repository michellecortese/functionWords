//
//  CrystalViewController.h
//  functionWords
//
//  Created by Michelle Cortese on 2014-03-18.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//

#import <UIKit/UIKit.h>//

@class CrystalViewController;

@protocol CrystalViewControllerDelegate <NSObject>
@required
- (void)crystalViewControllerDidFinish:(CrystalViewController *)viewController;
@end

@interface CrystalViewController : UIViewController
@property (nonatomic, weak) id<CrystalViewControllerDelegate> dismissDelegate;
- (IBAction)dismiss:(id)sender;
@end
