//
//  ViewController.h
//  functionWords
//
//  Created by Michelle Cortese on 2014-01-28.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Slt/Slt.h>

@class PocketsphinxController;
@class FliteController;
#import <OpenEars/OpenEarsEventsObserver.h>

@interface ViewController : UIViewController <OpenEarsEventsObserverDelegate> {
	Slt *slt;
	OpenEarsEventsObserver *openEarsEventsObserver; // observational class
	PocketsphinxController *pocketsphinxController; // voice recognition controller
	FliteController *fliteController; // tts controller

    IBOutlet UIButton *stopButton;
    IBOutlet UIButton *startButton;
    IBOutlet UITextView *statusTextView;
    IBOutlet UITextView *heardTextView;
	IBOutlet UILabel *pocketsphinxDbLabel;
	IBOutlet UILabel *fliteDbLabel;
    
}

// ui
- (IBAction) stopButtonAction;
- (IBAction) startButtonAction;

@property (nonatomic, strong) Slt *slt;
@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;
@property (nonatomic, strong) FliteController *fliteController;

// ui
@property (nonatomic, strong) IBOutlet UIButton *stopButton;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) IBOutlet UITextView *heardTextView;
@property (nonatomic, strong) IBOutlet UILabel *pocketsphinxDbLabel;
@property (nonatomic, strong) IBOutlet UILabel *fliteDbLabel;

@end

