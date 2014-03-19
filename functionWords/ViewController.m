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
@synthesize fliteController;
@synthesize statusTextView;
@synthesize heardTextView;
@synthesize outputDisplayBox;
@synthesize pocketsphinxDbLabel;
@synthesize fliteDbLabel;
@synthesize openEarsEventsObserver;
@synthesize slt;

// dictionary building assets
NSDictionary *languageGeneratorResults = nil;
NSString *lmPath = nil;
NSString *dicPath = nil;

// word counting assets
float overSixLetters;
float firstPersonSingular;
float firstPersonPlural;
float totalFirstPerson;
float secondPerson;
float thirdPerson;
float articles;
float semanticCausation;
float pastTenseVerbs;
float futureTenseVerbs;
float semanticTime;
float totalWords;

// percentage assets
float overSixLettersPercent;
float firstPersonSingularPercent;
float firstPersonPluralPercent;
float totalFirstPersonPercent;
float secondPersonPercent;
float thirdPersonPercent;
float articlesPercent;
float semanticCausationPercent;
float pastTenseVerbsPercent;
float futureTenseVerbsPercent;
float semanticTimePercent;
float totalWordsPercent;

// output assets
int happy;
int sad;
int angry;
int disHonesty;
int honesty;
int lackConfidence;
int confidence;
bool power;
bool truth;
NSString *powerRead = nil;
NSString *truthRead = nil;

// ui update frequency
#define kLevelUpdatesPerSecond 18

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
    
    NSArray *languageArray = [NSArray arrayWithObjects:   @"A",
                              @"ACCEPTED",
                              @"ADMITTED",
                              @"AFFECT",
                              @"AFFECTED",
                              @"AFTER",
                              @"AGAIN",
                              @"AGO",
                              @"ALREADY",
                              @"ALWAYS",
                              @"AN",
                              @"ANNUAL",
                              @"ANYTIME",
                              @"APPEARED",
                              @"APRIL",
                              @"ASKED",
                              @"ASSUME",
                              @"ATE",
                              @"AUGUST",
                              @"AUTUMN",
                              @"BASIS",
                              @"BECAME",
                              @"BECAUSE",
                              @"BEEN",
                              @"BEFORE",
                              @"BEGAN",
                              @"BELIEVED",
                              @"BOUGHT",
                              @"BRIEF",
                              @"BROKEN",
                              @"BROUGHT",
                              @"CALLED",
                              @"CAME",
                              @"CARED",
                              @"CARRIED",
                              @"CAUSE",
                              @"CHANGED",
                              @"CHEERED",
                              @"CLOCK",
                              @"CONFIDED",
                              @"CONSEQUENCE",
                              @"CRIED",
                              @"DAY",
                              @"DECADE",
                              @"DECEMBER",
                              @"DEPEND",
                              @"DEPENDED",
                              @"DESCRIBED",
                              @"DID",
                              @"DIED",
                              @"DISLIKED",
                              @"DONE",
                              @"DRANK",
                              @"DRIVEN",
                              @"DROVE",
                              @"DRUNK",
                              @"DURING",
                              @"EATEN",
                              @"EFFECT",
                              @"END",
                              @"ENDED",
                              @"ENTERED",
                              @"ERA",
                              @"ETERNITY",
                              @"EVENING",
                              @"EXPLAINED",
                              @"EXPRESSED",
                              @"FEBRUARY",
                              @"FED",
                              @"FELT",
                              @"FLED",
                              @"FLEW",
                              @"FOLLOWED",
                              @"FOREVER",
                              @"FOUGHT",
                              @"FOUND",
                              @"FOUNDATION",
                              @"FRIDAY",
                              @"FUTURE",
                              @"GAVE",
                              @"GENERATION",
                              @"GIVEN",
                              @"GONE",
                              @"GOT",
                              @"GOTTEN",
                              @"GUESSED",
                              @"HAD",
                              @"HAPPENED",
                              @"HATED",
                              @"HE",
                              @"HE'LL",
                              @"HEARD",
                              @"HELD",
                              @"HELPED",
                              @"HENCE",
                              @"HER",
                              @"HIM",
                              @"HIS",
                              @"HISTORY",
                              @"HOPED",
                              @"HOUR",
                              @"HOW",
                              @"I",
                              @"I'LL",
                              @"IMMEDIATE",
                              @"IMMORTAL",
                              @"IMPLICIT",
                              @"INFER",
                              @"INFERRED",
                              @"INFLUENCE",
                              @"INSTANCE",
                              @"IT'LL",
                              @"JANUARY",
                              @"JULY",
                              @"JUNE",
                              @"KEPT",
                              @"KNEW",
                              @"LAST",
                              @"LATE",
                              @"LEFT",
                              @"LETS",
                              @"LIED",
                              @"LIKED",
                              @"LISTENED",
                              @"LIVED",
                              @"LOOKED",
                              @"LOST",
                              @"LOVED",
                              @"MADE",
                              @"MARCH",
                              @"MAY",
                              @"ME",
                              @"MEANT",
                              @"MEANTIME",
                              @"MEANWHILE",
                              @"MET",
                              @"MIGHT",
                              @"MINE",
                              @"MINUTE",
                              @"MISSED",
                              @"MOMENT",
                              @"MONDAY",
                              @"MONTH",
                              @"MORNING",
                              @"MOTIVATE",
                              @"MOTIVE",
                              @"MOVED",
                              @"MY",
                              @"NEEDED",
                              @"NEVER",
                              @"NEXT",
                              @"NIGHT",
                              @"NOON",
                              @"NOVEMBER",
                              @"NOW",
                              @"OCCASIONAL",
                              @"OCTOBER",
                              @"OLD",
                              @"ONCE",
                              @"ORIGIN",
                              @"OUR",
                              @"OUTCOME",
                              @"OWED",
                              @"PACKED",
                              @"PAID",
                              @"PAST",
                              @"PERIOD",
                              @"PLAYED",
                              @"PRESENT",
                              @"PRODUCE",
                              @"PRODUCT",
                              @"PROTESTED",
                              @"PURPOSE",
                              @"QUESTIONNED",
                              @"RAN",
                              @"RATIONAL",
                              @"REACT",
                              @"REASON",
                              @"REQUIRED",
                              @"RESOLVED",
                              @"RESULT",
                              @"ROOT",
                              @"RUBBED",
                              @"RUSHED",
                              @"SAID",
                              @"SAT",
                              @"SATURDAY",
                              @"SAW",
                              @"SEEMED",
                              @"SEEN",
                              @"SEMESTER",
                              @"SENSED",
                              @"SEPTEMBER",
                              @"SHALL",
                              @"SHARED",
                              @"SHE",
                              @"SHE'LL",
                              @"SHOPPED",
                              @"SHOWED",
                              @"SINCE",
                              @"SMOKED",
                              @"SOLD",
                              @"SOMETIME",
                              @"SOON",
                              @"SOURCE",
                              @"SPENT",
                              @"SPOKE",
                              @"SPRING",
                              @"STARTED",
                              @"STAYED",
                              @"STIMULI",
                              @"STOOD",
                              @"STOPPED",
                              @"STUCK",
                              @"STUDIED",
                              @"STUNNED",
                              @"SUCKED",
                              @"SUDDEN",
                              @"SUFFERED",
                              @"SUMMER",
                              @"SUNDAY",
                              @"SUPPORTED",
                              @"SUPPOSED",
                              @"SURROUNDED",
                              @"TAKEN",
                              @"TALKED",
                              @"TAUGHT",
                              @"TEMPORARY",
                              @"TENDED",
                              @"THANKED",
                              @"THE",
                              @"THEIR",
                              @"THEM",
                              @"THEN",
                              @"THEREFORE",
                              @"THEY",
                              @"THEY'LL",
                              @"THOU",
                              @"THOUGHT",
                              @"THREW",
                              @"THURSDAY",
                              @"THUS",
                              @"TILL",
                              @"TIME",
                              @"TODAY",
                              @"TOLD",
                              @"TOMORROW",
                              @"TONIGHT",
                              @"TOOK",
                              @"TRIED",
                              @"TUESDAY",
                              @"TURNED",
                              @"UNDERSTOOD",
                              @"UNTIL",
                              @"US",
                              @"USED",
                              @"VIEWED",
                              @"WAITED",
                              @"WALKED",
                              @"WANTED",
                              @"WAS",
                              @"WE",
                              @"WE'LL",
                              @"WEDNESDAY",
                              @"WEEK",
                              @"WENT",
                              @"WERE",
                              @"WHEN",
                              @"WHILE",
                              @"WHY",
                              @"WILL",
                              @"WINTER",
                              @"WISHED",
                              @"WOKE",
                              @"WON",
                              @"WON'T",
                              @"WONDERED",
                              @"WORE",
                              @"WORKED",
                              @"WRITTEN",
                              @"WROTE",
                              @"Y'ALL",
                              @"YA",
                              @"YEAR",
                              @"YESTERDAY",
                              @"YOU",
                              @"YOU'LL",
                              @"YOUNG",
                              @"YOUR", nil];
    
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
    
    // initial ui shizz
}

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

// deliver text of speech heard and analyzed + accuracy score + utterance ID
// word counts occur, percentages calculated, outcomes drawn
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
    // if user says a category word, add to that category
    NSArray *firstPersonSingularArray = [NSArray arrayWithObjects: @"I", @"ME", @"MINE", @"MY", nil];
    for (NSString *s in firstPersonSingularArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            firstPersonSingular++;
        }
    }
    NSArray *firstPersonPluralArray = [NSArray arrayWithObjects: @"LETS", @"OUR", @"US", @"WE", nil];
    for (NSString *s in firstPersonPluralArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            firstPersonPlural++;
        }
    }
    NSArray *secondPersonArray = [NSArray arrayWithObjects: @"THOU", @"Y'ALL", @"YA", @"YOU", @"YOUR", nil];
    for (NSString *s in secondPersonArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            secondPerson++;
        }
    }
    NSArray *thirdPersonArray = [NSArray arrayWithObjects: @"HE", @"HER", @"HIM", @"HIS", @"SHE", @"THEIR", @"THEM", @"THEY", nil];
    for (NSString *s in thirdPersonArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            thirdPerson++;
        }
    }
    NSArray *articlesArray = [NSArray arrayWithObjects: @"A", @"AN", @"THE", nil];
    for (NSString *s in articlesArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            articles++;
        }
    }
    NSArray *semanticCausationArray = [NSArray arrayWithObjects: @"AFFECT", @"ASSUME", @"BASIS", @"BECAUSE", @"CAUSE", @"CONSEQUENCE", @"DEPEND", @"EFFECT", @"FOUND", @"FOUNDATION", @"HENCE", @"HOW", @"IMPLICIT", @"INFER", @"INFLUENCE", @"MOTIVATE", @"MOTIVE", @"ORIGIN", @"OUTCOME", @"PRODUCE", @"PRODUCT", @"PURPOSE", @"RATIONAL", @"REACT", @"REASON", @"RESULT", @"ROOT", @"SINCE", @"SOURCE", @"STIMULI", @"THEREFORE", @"THUS", @"WHY", nil];
    for (NSString *s in semanticCausationArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            semanticCausation++;
        }
    }
    NSArray *semanticTimeArray = [NSArray arrayWithObjects: @"AFTER", @"AGAIN", @"AGO", @"ALREADY", @"ALWAYS", @"ANNUAL", @"ANYTIME", @"APRIL", @"AUGUST", @"AUTUMN", @"BEFORE", @"BRIEF", @"CLOCK", @"DAY", @"DECADE", @"DECEMBER", @"DURING", @"END", @"ERA", @"ETERNITY", @"EVENING", @"FEBRUARY", @"FOREVER", @"FRIDAY", @"FUTURE", @"GENERATION", @"HISTORY", @"HOUR", @"IMMEDIATE", @"IMMORTAL", @"INSTANCE", @"JANUARY", @"JULY", @"JUNE", @"LAST", @"LATE", @"MARCH", @"MEANTIME", @"MEANWHILE", @"MINUTE", @"MOMENT", @"MONDAY", @"MONTH", @"MORNING", @"NEVER", @"NEXT", @"NIGHT", @"NOON", @"NOVEMBER", @"NOW", @"OCCASIONAL", @"OCTOBER", @"OLD", @"ONCE", @"ORIGIN", @"PAST", @"PERIOD", @"PRESENT", @"SATURDAY", @"SEMESTER", @"SEPTEMBER", @"SOMETIME", @"SOON", @"SPRING", @"SUDDEN", @"SUMMER", @"SUNDAY", @"TEMPORARY", @"THEN", @"THURSDAY", @"TILL", @"TIME", @"TODAY", @"TOMORROW", @"TONIGHT", @"TUESDAY", @"UNTIL", @"WEDNESDAY", @"WEEK", @"WHEN", @"WHILE", @"WINTER", @"YEAR", @"YESTERDAY", @"YOUNG", nil];
    for (NSString *s in semanticTimeArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            semanticTime++;
        }
    }
    NSArray *pastTenseVerbsArray = [NSArray arrayWithObjects: @"ACCEPTED", @"ADMITTED", @"AFFECTED", @"APPEARED", @"ASKED", @"ATE", @"BECAME", @"BEEN", @"BEGAN", @"BELIEVED", @"BOUGHT", @"BROKEN", @"BROUGHT", @"CALLED", @"CAME", @"CARED", @"CARRIED", @"CHANGED", @"CHEERED", @"CONFIDED", @"CRIED", @"DEPENDED", @"DESCRIBED", @"DID", @"DIED", @"DISLIKED", @"DONE", @"DRANK", @"DRIVEN", @"DROVE", @"DRUNK", @"EATEN", @"ENDED", @"ENTERED", @"EXPLAINED", @"EXPRESSED", @"FED", @"FELT", @"FLED", @"FLEW", @"FOLLOWED", @"FOUGHT", @"FOUND", @"GAVE", @"GIVEN", @"GONE", @"GOT", @"GOTTEN", @"GUESSED", @"HAD", @"HAPPENED", @"HATED", @"HEARD", @"HELD", @"HELPED", @"HOPED", @"INFERRED", @"KEPT", @"KNEW", @"LEFT", @"LIED", @"LIKED", @"LISTENED", @"LIVED", @"LOOKED", @"LOST", @"LOVED", @"MADE", @"MEANT", @"MET", @"MISSED", @"MOVED", @"NEEDED", @"OWED", @"PACKED", @"PAID", @"PAST", @"PLAYED", @"PROTESTED", @"QUESTIONNED", @"RAN", @"REQUIRED", @"RESOLVED", @"RUBBED", @"RUSHED", @"SAID", @"SAT", @"SAW", @"SEEMED", @"SEEN", @"SENSED", @"SHARED", @"SHOPPED", @"SHOWED", @"SMOKED", @"SOLD", @"SPENT", @"SPOKE", @"STARTED", @"STAYED", @"STOOD", @"STOPPED", @"STUCK", @"STUDIED", @"STUNNED", @"SUCKED", @"SUFFERED", @"SUPPORTED", @"SUPPOSED", @"SURROUNDED", @"TAKEN", @"TALKED", @"TAUGHT", @"TENDED", @"THANKED", @"THOUGHT", @"THREW", @"TOLD", @"TOOK", @"TRIED", @"TURNED", @"UNDERSTOOD", @"USED", @"VIEWED", @"WAITED", @"WALKED", @"WANTED", @"WAS", @"WENT", @"WERE", @"WISHED", @"WOKE", @"WON", @"WONDERED", @"WORE", @"WORKED", @"WRITTEN", @"WROTE", @"YESTERDAY", nil];
    for (NSString *s in pastTenseVerbsArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            pastTenseVerbs++;
        }
    }
    NSArray *futureTenseVerbsArray = [NSArray arrayWithObjects: @"HE'LL", @"I'LL", @"IT'LL", @"MAY", @"MIGHT", @"SHALL", @"SHE'LL", @"THEY'LL", @"WE'LL", @"WILL", @"WON'T", @"YOU'LL", nil];
    for (NSString *s in futureTenseVerbsArray)
    {
        if ([hypothesis rangeOfString:s].location != NSNotFound) {
            futureTenseVerbs++;
        }
    }
    
    // tallies
    totalFirstPerson = firstPersonSingular + firstPersonPlural;
    totalWords = overSixLetters + firstPersonSingular + firstPersonPlural + totalFirstPerson + secondPerson + thirdPerson + articles + semanticCausation + pastTenseVerbs + futureTenseVerbs + semanticTime;
    
    // calculate percentages
    overSixLettersPercent = (overSixLetters/totalWords)*100;
    firstPersonSingularPercent = (firstPersonSingular/totalWords)*100;
    firstPersonPluralPercent = (firstPersonPlural/totalWords)*100;
    totalFirstPersonPercent = (totalFirstPerson/totalWords)*100;
    secondPersonPercent = (secondPerson/totalWords)*100;
    thirdPersonPercent = (thirdPerson/totalWords)*100;
    articlesPercent = (articles/totalWords)*100;
    semanticCausationPercent = (semanticCausation/totalWords)*100;
    pastTenseVerbsPercent = (pastTenseVerbs/totalWords)*100;
    futureTenseVerbsPercent = (futureTenseVerbs/totalWords)*100;
    semanticTimePercent = (semanticTime/totalWords)*100;
    
    // outputs
    // happy
    if (pastTenseVerbsPercent < 11 && happy < 244){
        happy = happy+10;
    } else if (pastTenseVerbsPercent > 11 && happy > 9){
        happy = happy-10;
    }
    if (futureTenseVerbsPercent < 2 && happy < 244){
        happy = happy+10;
    } else if (futureTenseVerbsPercent > 2 && happy > 9){
        happy = happy-10;
    }
    if (firstPersonPluralPercent > 2 && happy < 244){
        happy = happy+10;
    } else if (firstPersonPluralPercent < 2 && happy > 9){
        happy = happy-10;
    }
    if (semanticTimePercent > 9 && happy < 244){
        happy = happy+10;
    } else if (semanticTimePercent < 9 && happy > 9){
        happy = happy-10;
    }
    // sad
    if (firstPersonSingularPercent > 16 && sad < 244){
        sad = sad+10;
    } else if (firstPersonSingularPercent < 16 && sad > 9){
        sad = sad-10;
    }
    if (pastTenseVerbsPercent > 11 && sad < 244){
        sad = sad+10;
    } else if (pastTenseVerbsPercent < 11 && sad > 9){
        sad = sad-10;
    }
    if (futureTenseVerbsPercent > 2 && sad < 244){
        sad = sad+10;
    } else if (futureTenseVerbsPercent < 2 && sad > 9){
        sad = sad-10;
    }
    if (semanticCausationPercent > 1 && sad < 244){
        sad = sad+10;
    } else if (semanticCausationPercent < 1 && sad > 9){
        sad = sad-10;
    }
    // angry
    if (secondPersonPercent > 1 && angry < 244){
        angry = angry+10;
    } else if (secondPersonPercent < 1 && angry > 9){
        angry = angry-10;
    }
    if (thirdPersonPercent > 10 && angry < 244){
        angry = angry+10;
    } else if (thirdPersonPercent < 10 && angry > 9){
        angry = angry-10;
    }
    if (pastTenseVerbsPercent < 11 && angry < 244){
        angry = angry+10;
    } else if (pastTenseVerbsPercent > 11 && angry > 9){
        angry = angry-10;
    }
    if (semanticCausationPercent > 1 && angry < 244){
        angry = angry+10;
    } else if (semanticCausationPercent < 1 && angry > 9){
        angry = angry-10;
    }
    // confidence
    if (firstPersonPluralPercent > 2){confidence++;}
    if (overSixLettersPercent > 25){confidence++;}
    if (articlesPercent > 11){confidence++;}
    // lack of confidence
    if (firstPersonSingularPercent > 16){lackConfidence++;}
    if (pastTenseVerbsPercent < 11){lackConfidence++;}
    if (futureTenseVerbsPercent < 2){lackConfidence++;}
    // confidence bool
    if (confidence > lackConfidence){
        power = true;
        powerRead = @"Confident";
    } else if (honesty < disHonesty) {
        truth = false;
        powerRead = @"Under Confident";
    } else {
        powerRead = @"Average";
    }
    // honesty
    if (overSixLettersPercent > 25){honesty++;}
    if (totalFirstPersonPercent > 17){honesty++;}
    if (semanticTimePercent > 9){honesty++;}
    // dishonesty
    if (pastTenseVerbsPercent > 11){disHonesty++;}
    if (totalFirstPersonPercent < 17){disHonesty++;}
    if (semanticTimePercent < 9){disHonesty++;}
    // honesty bool
    if (honesty > disHonesty){
        truth = true;
        truthRead = @"Honest";
    } else if (honesty < disHonesty) {
        truth = false;
        truthRead = @"Dishonest";
    } else {
        truthRead = @"Average";
    }
    
    // print all
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    NSLog(@"\n Words Over Six Characters = %f percent \n First Person Singular Pronouns = %f percent \n First Person Plural Pronouns = %f percent \n Total First Person Pronouns = %f percent \n Second Person Pronouns = %f percent \n Third Person Pronouns = %f percent \n Articles = %f percent \n Causation Words = %f percent \n Past Tense Verbs = %f percent \n Future Tense Verbs = %f percent \n Time Words = %f percent \n Sample Size = %f words", overSixLettersPercent, firstPersonSingularPercent, firstPersonPluralPercent, totalFirstPersonPercent, secondPersonPercent, thirdPersonPercent, articlesPercent, semanticCausationPercent, pastTenseVerbsPercent, futureTenseVerbsPercent, semanticTimePercent, totalWords);
    NSLog(@"\n Happiness Score = %d /255 \n Sadness Score = %d /255 \n Anger Score = %d /255 \n Power = %@ \n Truth = %@", happy, sad, angry, powerRead, truthRead);
    
    // display words and scores in app
	self.heardTextView.text = [NSString stringWithFormat:@"Heard: \"%@\"", hypothesis]; // words
    self.outputDisplayBox.text = [NSString stringWithFormat:@"Scores: \n Happiness Score = %d /255 \n Sadness Score = %d /255 \n Anger Score = %d /255 \n Power = %@ \n Truth = %@", happy, sad, angry, powerRead, truthRead]; // score
}

#ifdef kGetNbest
- (void) pocketsphinxDidReceiveNBestHypothesisArray:(NSArray *)hypothesisArray { // pocketsphinx has an n-best hypothesis dictionary
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

// ui shizz

- (void) genernateGradient {
    //NSGradient(angry,happy,sad);
}

- (IBAction)refreshButton:(id)sender { // clear all results
    overSixLetters=0;
    firstPersonSingular=0;
    firstPersonPlural=0;
    totalFirstPerson=0;
    secondPerson=0;
    thirdPerson=0;
    articles=0;
    semanticCausation=0;
    pastTenseVerbs=0;
    futureTenseVerbs=0;
    semanticTime=0;
    totalWords=0;
    happy=0;
    sad=0;
    angry=0;
    disHonesty=0;
    honesty=0;
    lackConfidence=0;
    confidence=0;
    truthRead = @"Average";
    powerRead = @"Average";
    self.outputDisplayBox.text = [NSString stringWithFormat:@"Scores: \n Happiness Score = %d /255 \n Sadness Score = %d /255 \n Anger Score = %d /255 \n Power = %@ \n Truth = %@", happy, sad, angry, powerRead, truthRead];
}

#pragma mark -
#pragma mark Example for reading out Pocketsphinx and Flite audio levels without locking the UI by using an NSTimer

@end
