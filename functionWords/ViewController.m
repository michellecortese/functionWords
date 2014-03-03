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

// word counting assets
int overSixLetters;
int firstPersonSingular;
int firstPersonPlural;
int totalFirstPerson;
int secondPerson;
int thirdPerson;
int articles;
int semanticCausation;
int pastTenseVerbs;
int futureTenseVerbs;
int semanticTime;
int totalWords;

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
    
    // ui shizz
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = TRUE;
}

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

// deliver text of speech heard and analyzed + accuracy score + utterance ID
// word counts will occur here
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore {
    
    // if user says a category word, add to that category
	if([hypothesis isEqualToString:@"I"] || [hypothesis isEqualToString:@"ME"] || [hypothesis isEqualToString:@"MINE"] || [hypothesis isEqualToString:@"MY"]) {
        firstPersonSingular++;
	}
    if([hypothesis isEqualToString:@"LETS"] || [hypothesis isEqualToString:@"OUR"] || [hypothesis isEqualToString:@"US"] || [hypothesis isEqualToString:@"WE"]) {
        firstPersonPlural++;
	}
    if([hypothesis isEqualToString:@"THOU"] || [hypothesis isEqualToString:@"Y'ALL"] || [hypothesis isEqualToString:@"YA"] || [hypothesis isEqualToString:@"YOU"] || [hypothesis isEqualToString:@"YOUR"]) {
        secondPerson++;
	}
    if([hypothesis isEqualToString:@"HE"] || [hypothesis isEqualToString:@"HER"] || [hypothesis isEqualToString:@"HIM"] || [hypothesis isEqualToString:@"HIS"] || [hypothesis isEqualToString:@"SHE"] || [hypothesis isEqualToString:@"THEIR"] || [hypothesis isEqualToString:@"THEM"] || [hypothesis isEqualToString:@"THEY"]) {
        thirdPerson++;
	}
    if([hypothesis isEqualToString:@"A"] || [hypothesis isEqualToString:@"AN"] || [hypothesis isEqualToString:@"THE"]) {
        articles++;
	}
    if([hypothesis isEqualToString:@"AFFECT"] || [hypothesis isEqualToString:@"ASSUME"] || [hypothesis isEqualToString:@"BASIS"] || [hypothesis isEqualToString:@"BECAUSE"] || [hypothesis isEqualToString:@"CAUSE"] || [hypothesis isEqualToString:@"CONSEQUENCE"] || [hypothesis isEqualToString:@"DEPEND"] || [hypothesis isEqualToString:@"EFFECT"] || [hypothesis isEqualToString:@"FOUND"] || [hypothesis isEqualToString:@"FOUNDATION"] || [hypothesis isEqualToString:@"HENCE"] || [hypothesis isEqualToString:@"HOW"] || [hypothesis isEqualToString:@"IMPLICIT"] || [hypothesis isEqualToString:@"INFER"] || [hypothesis isEqualToString:@"INFLUENCE"] || [hypothesis isEqualToString:@"MOTIVATE"] || [hypothesis isEqualToString:@"MOTIVE"] || [hypothesis isEqualToString:@"ORIGIN"] || [hypothesis isEqualToString:@"OUTCOME"] || [hypothesis isEqualToString:@"PRODUCE"] || [hypothesis isEqualToString:@"PRODUCT"] || [hypothesis isEqualToString:@"PURPOSE"] || [hypothesis isEqualToString:@"RATIONAL"] || [hypothesis isEqualToString:@"REACT"] || [hypothesis isEqualToString:@"REASON"] || [hypothesis isEqualToString:@"RESULT"] || [hypothesis isEqualToString:@"ROOT"] || [hypothesis isEqualToString:@"SINCE"] || [hypothesis isEqualToString:@"SOURCE"] || [hypothesis isEqualToString:@"STIMULI"] || [hypothesis isEqualToString:@"THEREFORE"] || [hypothesis isEqualToString:@"THUS"] || [hypothesis isEqualToString:@"WHY"]) {
        semanticCausation++;
	}
    if([hypothesis isEqualToString:@"AFTER"] || [hypothesis isEqualToString:@"AGAIN"] || [hypothesis isEqualToString:@"AGO"] || [hypothesis isEqualToString:@"ALREADY"] || [hypothesis isEqualToString:@"ALWAYS"] || [hypothesis isEqualToString:@"ANNUAL"] || [hypothesis isEqualToString:@"ANYTIME"] || [hypothesis isEqualToString:@"APRIL"] || [hypothesis isEqualToString:@"AUGUST"] || [hypothesis isEqualToString:@"AUTUMN"] || [hypothesis isEqualToString:@"BEFORE"] || [hypothesis isEqualToString:@"BRIEF"] || [hypothesis isEqualToString:@"CLOCK"] || [hypothesis isEqualToString:@"DAY"] || [hypothesis isEqualToString:@"DECADE"] || [hypothesis isEqualToString:@"DECEMBER"] || [hypothesis isEqualToString:@"DURING"] || [hypothesis isEqualToString:@"END"] || [hypothesis isEqualToString:@"ERA"] || [hypothesis isEqualToString:@"ETERNITY"] || [hypothesis isEqualToString:@"EVENING"] || [hypothesis isEqualToString:@"FEBRUARY"] || [hypothesis isEqualToString:@"FOREVER"] || [hypothesis isEqualToString:@"FRIDAY"] || [hypothesis isEqualToString:@"FUTURE"] || [hypothesis isEqualToString:@"GENERATION"] || [hypothesis isEqualToString:@"HISTORY"] || [hypothesis isEqualToString:@"HOUR"] || [hypothesis isEqualToString:@"IMMEDIATE"] || [hypothesis isEqualToString:@"IMMORTAL"] || [hypothesis isEqualToString:@"INSTANCE"] || [hypothesis isEqualToString:@"JANUARY"] || [hypothesis isEqualToString:@"JULY"] || [hypothesis isEqualToString:@"JUNE"] || [hypothesis isEqualToString:@"LAST"] || [hypothesis isEqualToString:@"LATE"] || [hypothesis isEqualToString:@"MARCH"] || [hypothesis isEqualToString:@"MEANTIME"] || [hypothesis isEqualToString:@"MEANWHILE"] || [hypothesis isEqualToString:@"MINUTE"] || [hypothesis isEqualToString:@"MOMENT"] || [hypothesis isEqualToString:@"MONDAY"] || [hypothesis isEqualToString:@"MONTH"] || [hypothesis isEqualToString:@"MORNING"] || [hypothesis isEqualToString:@"NEVER"] || [hypothesis isEqualToString:@"NEXT"] || [hypothesis isEqualToString:@"NIGHT"] || [hypothesis isEqualToString:@"NOON"] || [hypothesis isEqualToString:@"NOVEMBER"] || [hypothesis isEqualToString:@"NOW"] || [hypothesis isEqualToString:@"OCCASIONAL"] || [hypothesis isEqualToString:@"OCTOBER"] || [hypothesis isEqualToString:@"OLD"] || [hypothesis isEqualToString:@"ONCE"] || [hypothesis isEqualToString:@"ORIGIN"] || [hypothesis isEqualToString:@"PAST"] || [hypothesis isEqualToString:@"PERIOD"] || [hypothesis isEqualToString:@"PRESENT"] || [hypothesis isEqualToString:@"SATURDAY"] || [hypothesis isEqualToString:@"SEMESTER"] || [hypothesis isEqualToString:@"SEPTEMBER"] || [hypothesis isEqualToString:@"SOMETIME"] || [hypothesis isEqualToString:@"SOON"] || [hypothesis isEqualToString:@"SPRING"] || [hypothesis isEqualToString:@"SUDDEN"] || [hypothesis isEqualToString:@"SUMMER"] || [hypothesis isEqualToString:@"SUNDAY"] || [hypothesis isEqualToString:@"TEMPORARY"] || [hypothesis isEqualToString:@"THEN"] || [hypothesis isEqualToString:@"THURSDAY"] || [hypothesis isEqualToString:@"TILL"] || [hypothesis isEqualToString:@"TIME"] || [hypothesis isEqualToString:@"TODAY"] || [hypothesis isEqualToString:@"TOMORROW"] || [hypothesis isEqualToString:@"TONIGHT"] || [hypothesis isEqualToString:@"TUESDAY"] || [hypothesis isEqualToString:@"UNTIL"] || [hypothesis isEqualToString:@"WEDNESDAY"] || [hypothesis isEqualToString:@"WEEK"] || [hypothesis isEqualToString:@"WHEN"] || [hypothesis isEqualToString:@"WHILE"] || [hypothesis isEqualToString:@"WINTER"] || [hypothesis isEqualToString:@"YEAR"] || [hypothesis isEqualToString:@"YESTERDAY"] || [hypothesis isEqualToString:@"YOUNG"]) {
        semanticTime++;
    }
    if([hypothesis isEqualToString:@"ACCEPTED"] || [hypothesis isEqualToString:@"ADMITTED"] || [hypothesis isEqualToString:@"AFFECTED"] || [hypothesis isEqualToString:@"APPEARED"] || [hypothesis isEqualToString:@"ASKED"] || [hypothesis isEqualToString:@"ATE"] || [hypothesis isEqualToString:@"BECAME"] || [hypothesis isEqualToString:@"BEEN"] || [hypothesis isEqualToString:@"BEGAN"] || [hypothesis isEqualToString:@"BELIEVED"] || [hypothesis isEqualToString:@"BOUGHT"] || [hypothesis isEqualToString:@"BROKEN"] || [hypothesis isEqualToString:@"BROUGHT"] || [hypothesis isEqualToString:@"CALLED"] || [hypothesis isEqualToString:@"CAME"] || [hypothesis isEqualToString:@"CARED"] || [hypothesis isEqualToString:@"CARRIED"] || [hypothesis isEqualToString:@"CHANGED"] || [hypothesis isEqualToString:@"CHEERED"] || [hypothesis isEqualToString:@"CONFIDED"] || [hypothesis isEqualToString:@"CRIED"] || [hypothesis isEqualToString:@"DEPENDED"] || [hypothesis isEqualToString:@"DESCRIBED"] || [hypothesis isEqualToString:@"DID"] || [hypothesis isEqualToString:@"DIED"] || [hypothesis isEqualToString:@"DISLIKED"] || [hypothesis isEqualToString:@"DONE"] || [hypothesis isEqualToString:@"DRANK"] || [hypothesis isEqualToString:@"DRIVEN"] || [hypothesis isEqualToString:@"DROVE"] || [hypothesis isEqualToString:@"DRUNK"] || [hypothesis isEqualToString:@"EATEN"] || [hypothesis isEqualToString:@"ENDED"] || [hypothesis isEqualToString:@"ENTERED"] || [hypothesis isEqualToString:@"EXPLAINED"] || [hypothesis isEqualToString:@"EXPRESSED"] || [hypothesis isEqualToString:@"FED"] || [hypothesis isEqualToString:@"FELT"] || [hypothesis isEqualToString:@"FLED"] || [hypothesis isEqualToString:@"FLEW"] || [hypothesis isEqualToString:@"FOLLOWED"] || [hypothesis isEqualToString:@"FOUGHT"] || [hypothesis isEqualToString:@"FOUND"] || [hypothesis isEqualToString:@"GAVE"] || [hypothesis isEqualToString:@"GIVEN"] || [hypothesis isEqualToString:@"GONE"] || [hypothesis isEqualToString:@"GOT"] || [hypothesis isEqualToString:@"GOTTEN"] || [hypothesis isEqualToString:@"GUESSED"] || [hypothesis isEqualToString:@"HAD"] || [hypothesis isEqualToString:@"HAPPENED"] || [hypothesis isEqualToString:@"HATED"] || [hypothesis isEqualToString:@"HEARD"] || [hypothesis isEqualToString:@"HELD"] || [hypothesis isEqualToString:@"HELPED"] || [hypothesis isEqualToString:@"HOPED"] || [hypothesis isEqualToString:@"INFERRED"] || [hypothesis isEqualToString:@"KEPT"] || [hypothesis isEqualToString:@"KNEW"] || [hypothesis isEqualToString:@"LEFT"] || [hypothesis isEqualToString:@"LIED"] || [hypothesis isEqualToString:@"LIKED"] || [hypothesis isEqualToString:@"LISTENED"] || [hypothesis isEqualToString:@"LIVED"] || [hypothesis isEqualToString:@"LOOKED"] || [hypothesis isEqualToString:@"LOST"] || [hypothesis isEqualToString:@"LOVED"] || [hypothesis isEqualToString:@"MADE"] || [hypothesis isEqualToString:@"MEANT"] || [hypothesis isEqualToString:@"MET"] || [hypothesis isEqualToString:@"MISSED"] || [hypothesis isEqualToString:@"MOVED"] || [hypothesis isEqualToString:@"NEEDED"] || [hypothesis isEqualToString:@"OWED"] || [hypothesis isEqualToString:@"PACKED"] || [hypothesis isEqualToString:@"PAID"] || [hypothesis isEqualToString:@"PAST"] || [hypothesis isEqualToString:@"PLAYED"] || [hypothesis isEqualToString:@"PROTESTED"] || [hypothesis isEqualToString:@"QUESTIONNED"] || [hypothesis isEqualToString:@"RAN"] || [hypothesis isEqualToString:@"REQUIRED"] || [hypothesis isEqualToString:@"RESOLVED"] || [hypothesis isEqualToString:@"RUBBED"] || [hypothesis isEqualToString:@"RUSHED"] || [hypothesis isEqualToString:@"SAID"] || [hypothesis isEqualToString:@"SAT"] || [hypothesis isEqualToString:@"SAW"] || [hypothesis isEqualToString:@"SEEMED"] || [hypothesis isEqualToString:@"SEEN"] || [hypothesis isEqualToString:@"SENSED"] || [hypothesis isEqualToString:@"SHARED"] || [hypothesis isEqualToString:@"SHOPPED"] || [hypothesis isEqualToString:@"SHOWED"] || [hypothesis isEqualToString:@"SMOKED"] || [hypothesis isEqualToString:@"SOLD"] || [hypothesis isEqualToString:@"SPENT"] || [hypothesis isEqualToString:@"SPOKE"] || [hypothesis isEqualToString:@"STARTED"] || [hypothesis isEqualToString:@"STAYED"] || [hypothesis isEqualToString:@"STOOD"] || [hypothesis isEqualToString:@"STOPPED"] || [hypothesis isEqualToString:@"STUCK"] || [hypothesis isEqualToString:@"STUDIED"] || [hypothesis isEqualToString:@"STUNNED"] || [hypothesis isEqualToString:@"SUCKED"] || [hypothesis isEqualToString:@"SUFFERED"] || [hypothesis isEqualToString:@"SUPPORTED"] || [hypothesis isEqualToString:@"SUPPOSED"] || [hypothesis isEqualToString:@"SURROUNDED"] || [hypothesis isEqualToString:@"TAKEN"] || [hypothesis isEqualToString:@"TALKED"] || [hypothesis isEqualToString:@"TAUGHT"] || [hypothesis isEqualToString:@"TENDED"] || [hypothesis isEqualToString:@"THANKED"] || [hypothesis isEqualToString:@"THOUGHT"] || [hypothesis isEqualToString:@"THREW"] || [hypothesis isEqualToString:@"TOLD"] || [hypothesis isEqualToString:@"TOOK"] || [hypothesis isEqualToString:@"TRIED"] || [hypothesis isEqualToString:@"TURNED"] || [hypothesis isEqualToString:@"UNDERSTOOD"] || [hypothesis isEqualToString:@"USED"] || [hypothesis isEqualToString:@"VIEWED"] || [hypothesis isEqualToString:@"WAITED"] || [hypothesis isEqualToString:@"WALKED"] || [hypothesis isEqualToString:@"WANTED"] || [hypothesis isEqualToString:@"WAS"] || [hypothesis isEqualToString:@"WENT"] || [hypothesis isEqualToString:@"WERE"] || [hypothesis isEqualToString:@"WISHED"] || [hypothesis isEqualToString:@"WOKE"] || [hypothesis isEqualToString:@"WON"] || [hypothesis isEqualToString:@"WONDERED"] || [hypothesis isEqualToString:@"WORE"] || [hypothesis isEqualToString:@"WORKED"] || [hypothesis isEqualToString:@"WRITTEN"] || [hypothesis isEqualToString:@"WROTE"] || [hypothesis isEqualToString:@"YESTERDAY"]) {
        pastTenseVerbs++;
	}
    if([hypothesis isEqualToString:@"HE'LL"] || [hypothesis isEqualToString:@"I'LL"] || [hypothesis isEqualToString:@"IT'LL"] || [hypothesis isEqualToString:@"MAY"] || [hypothesis isEqualToString:@"MIGHT"] || [hypothesis isEqualToString:@"SHALL"] || [hypothesis isEqualToString:@"SHE'LL"] || [hypothesis isEqualToString:@"THEY'LL"] || [hypothesis isEqualToString:@"WE'LL"] || [hypothesis isEqualToString:@"WILL"] || [hypothesis isEqualToString:@"WON'T"] || [hypothesis isEqualToString:@"YOU'LL"]) {
        futureTenseVerbs++;
	}
    // tallies
    totalFirstPerson = (firstPersonSingular + firstPersonPlural)/totalWords;
    totalWords = overSixLetters + firstPersonSingular + firstPersonPlural + totalFirstPerson + secondPerson + thirdPerson + articles + semanticCausation + pastTenseVerbs + futureTenseVerbs + semanticTime;
    
    // print all
    NSLog(@"The received hypothesis is %@ with a score of %@", hypothesis, recognitionScore);
    NSLog(@"Words Over Six Characters = %d",overSixLetters);
    NSLog(@"First Person Singular Pronouns = %d", firstPersonSingular);
    NSLog(@"First Person Plural Pronouns = %d", firstPersonPlural);
    NSLog(@"Total First Person Pronouns = %d", totalFirstPerson);
    NSLog(@"Second Person Pronouns = %d", secondPerson);
    NSLog(@"Third Person Pronouns = %d", thirdPerson);
    NSLog(@"Articles = %d", articles);
    NSLog(@"Causation Words = %d", semanticCausation);
    NSLog(@"Past Tense Verbs = %d", pastTenseVerbs);
    NSLog(@"Future Tense Verbs = %d", futureTenseVerbs);
    NSLog(@"Time Words = %d", semanticTime);
    NSLog(@"Sample Size = %d", totalWords);
    
    // display words
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
