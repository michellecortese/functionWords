//
//  ViewController.m
//  functionWords
//
//  Created by Michelle Cortese on 2014-01-28.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//


#import "ViewController.h"
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/FliteController.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/OpenEarsLogging.h>
#import <OpenEars/AcousticModel.h>

@implementation ViewController

@synthesize pocketsphinxController;
@synthesize startButton;
@synthesize stopButton;
@synthesize fliteController;
@synthesize statusTextView;
@synthesize heardTextView;
@synthesize pocketsphinxDbLabel;
@synthesize fliteDbLabel;
@synthesize openEarsEventsObserver;
@synthesize slt;

// dictionary building assets
NSDictionary *languageGeneratorResults = nil;
NSString *lmPath = nil;
NSString *dicPath = nil;

// word count assets
int pronoun;

#define kLevelUpdatesPerSecond 18 // ui update 18 times a second to hit the CPU gently

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	openEarsEventsObserver.delegate = nil;
}

#pragma mark -
#pragma mark Lazy Allocation

- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
        pocketsphinxController.outputAudio = TRUE;
#ifdef kGetNbest
        pocketsphinxController.returnNbest = TRUE;
        pocketsphinxController.nBestNumber = 5;
#endif
	}
	return pocketsphinxController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

- (void) startListening {
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.openEarsEventsObserver setDelegate:self]; // delegate of OpenEarsObserver class
    
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    
    NSArray *languageArray = [NSArray arrayWithObjects: @"I",
                                                        @"YOU",
                                                        @"ME",
                                                        @"US", nil];
    NSString *functionDict = @"FunctionDictionary";
    NSError *error = [lmGenerator generateLanguageModelFromArray:languageArray withFilesNamed:functionDict forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    

	
    if([error code] == noErr) {
        languageGeneratorResults = [error userInfo];
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    // start the continuous listening loop
    if(languageGeneratorResults) {
        [self startListening];
    }
    
    // ui shizz
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = TRUE;
}

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

// deliver text of speech heard and analyzed + accuracy score + utterance ID
// word counts will occur here
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
	if([hypothesis isEqualToString:@"I"]) { // if user says a category word, add to that category
        pronoun++;
        NSLog(@"Pronoun count= %d", pronoun);
	}
	self.heardTextView.text = [NSString stringWithFormat:@"Heard: \"%@\"", hypothesis]; // display in app
}

#ifdef kGetNbest
- (void) pocketsphinxDidReceiveNBestHypothesisArray:(NSArray *)hypothesisArray { // Pocketsphinx has an n-best hypothesis dictionary.
    NSLog(@"hypothesisArray is %@",hypothesisArray);
}
#endif
// informs that there was an interruption
- (void) audioSessionInterruptionDidBegin {
	NSLog(@"Interruption began.");
	self.statusTextView.text = @"Interruption began."; // display in app
	[self.pocketsphinxController stopListening]; // stop listening
}

// informs that the interruption ended
- (void) audioSessionInterruptionDidEnd {
	NSLog(@"Interruption ended.");
	self.statusTextView.text = @"Interruption ended."; // display in app
    [self startListening]; // restart
	
}

// informs that audio input became unavailable
- (void) audioInputDidBecomeUnavailable {
	NSLog(@"Audio input has become unavailable");
	self.statusTextView.text = @"Audio input has become unavailable"; // display in app
	[self.pocketsphinxController stopListening]; // stop listening
}

// informs that audio input became available again
- (void) audioInputDidBecomeAvailable {
	NSLog(@"Audio input is available");
	self.statusTextView.text = @"Audio input is available"; // display in app
    [self startListening]; // restart
}

// informs change of route (if bluetooth necklace disconnects)
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute {
	NSLog(@"Audio source change. You are now using %@", newRoute);
	self.statusTextView.text = [NSString stringWithFormat:@"Audio source change. You are now using %@",newRoute]; // display in app
    
	[self.pocketsphinxController stopListening];
    [self startListening];  // shut down and restart listening loop on the new route
}

// calibration is on
- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
	self.statusTextView.text = @"Calibration is on."; // display in app
}

// calibration complete
- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
	self.statusTextView.text = @"Calibration is complete."; // display in app
	self.fliteController.duration_stretch = .9; // change speed
	self.fliteController.target_mean = 1.2; // change pitch
	self.fliteController.target_stddev = 1.5; // change variance
    [self.fliteController say:@"Welcome to function words." withVoice:self.slt]; // welcome greeting
	self.fliteController.duration_stretch = 1.0; // reset speed
	self.fliteController.target_mean = 1.0; // reset pitch
	self.fliteController.target_stddev = 1.0; // reset variance
}

// informs that the listening loop began
- (void) pocketsphinxRecognitionLoopDidStart {
	NSLog(@"Pocketsphinx is starting up.");
	self.statusTextView.text = @"Listening."; // display in app
}

// informs that we are now looking for words
- (void) pocketsphinxDidStartListening {
	NSLog(@"Listening.");
	self.statusTextView.text = @"Listening..."; // display in app
    // UI changes
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = FALSE;
}

// informs that we are now processing speech
- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Speech detected.");
	self.statusTextView.text = @"Speech detected."; // display in app
}
// informs that we stopped listening
- (void) pocketsphinxDidStopListening {
	NSLog(@"Stopped listening.");
	self.statusTextView.text = @"No longer listening."; // display in app
}

// logs a language model change
- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

// informs that something went wrong with the recognition loop startup
- (void) pocketSphinxContinuousSetupDidFail {
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on [OpenEarsLogging startOpenEarsLogging] in OpenEarsConfig.h to learn more.");
	self.statusTextView.text = @"Not possible to start recognition loop."; // display in app
}

- (void) shutDown {
    NSLog(@"Hi I'm on thread %@",[NSThread currentThread]);
}

// logs a recognition test
- (void) testRecognitionCompleted {
	NSLog(@"A test file which was submitted for direct recognition via the audio driver is done.");
    [self.pocketsphinxController stopListening];
    
}

#pragma mark -
#pragma mark UI

// UI shizz

- (IBAction) stopButtonAction { // stop button
	[self.pocketsphinxController stopListening];
    //[self.pocketsphinxController suspendRecognition];
	self.startButton.hidden = FALSE;
	self.stopButton.hidden = TRUE;
}

- (IBAction) startButtonAction { // start button
    [self startListening];
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = FALSE;
}

#pragma mark -
#pragma mark Example for reading out Pocketsphinx and Flite audio levels without locking the UI by using an NSTimer

@end
