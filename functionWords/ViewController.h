//
//  ViewController.h
//  functionWords
//
//  Created by Michelle Cortese on 2014-01-28.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Slt/Slt.h>
#import "MCCrystalViewController.h"

@class PocketsphinxController;
@class FliteController;

#import <OpenEars/OpenEarsEventsObserver.h>

@interface ViewController : UIViewController <OpenEarsEventsObserverDelegate, MCCrystalViewControllerDelegate> {
	Slt *slt;
	OpenEarsEventsObserver *openEarsEventsObserver; // observational class
	PocketsphinxController *pocketsphinxController; // voice recognition controller
	FliteController *fliteController; // tts controller
    IBOutlet UILabel *statusTextView;
    IBOutlet UILabel *heardTextView;
	IBOutlet UILabel *pocketsphinxDbLabel;
	IBOutlet UILabel *fliteDbLabel;
    IBOutlet UILabel *outputDisplayBox;
    MCCrystalViewController *_crystalViewController;
    // output assets
    float happy; float sad; float angry; // mood alphas
    int disHonesty; int honesty;
    int lackConfidence; int confidence; // confidence #
    bool power;
    bool truth; // truth bool
}

// actions
- (IBAction)refreshButton:(id)sender;

@property (nonatomic, strong) Slt *slt;
@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;
@property (nonatomic, strong) FliteController *fliteController;
@property (nonatomic, strong) IBOutlet UILabel *statusTextView;
@property (nonatomic, strong) IBOutlet UILabel *heardTextView;
@property (nonatomic, strong) IBOutlet UILabel *pocketsphinxDbLabel;
@property (nonatomic, strong) IBOutlet UILabel *fliteDbLabel;
@property (nonatomic, strong) IBOutlet UILabel *outputDisplayBox;
@property (nonatomic, strong) MCCrystalViewController *crystalViewController;

- (IBAction)flip:(id)sender;

@end

