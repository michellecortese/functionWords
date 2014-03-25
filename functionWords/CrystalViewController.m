//
//  CrystalViewController.m
//  functionWords
//
//  Created by Michelle Cortese on 2014-03-18.
//  Copyright (c) 2014 Michelle Cortese. All rights reserved.
//

#import "CrystalViewController.h"

@interface CrystalViewController ()

@end

@implementation CrystalViewController
@synthesize dismissDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    if (self.dismissDelegate != nil && [self.dismissDelegate respondsToSelector:@selector(crystalViewControllerDidFinish:)]) {
        [self.dismissDelegate crystalViewControllerDidFinish:self];
    }
}

@end
