//
//  NLResultsViewController.m
//  StressIt
//
//  Created by Alexey Goncharov on 05.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLResultsViewController.h"

static int truePerc;
static int falsePerc;

@interface NLResultsViewController ()

@end

@implementation NLResultsViewController

@synthesize resultSpinner, rightAnswers, falseAnswers, trueLbl, falseLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRight:(int)right andMistakes:(int)mistakes {
  self = [super init];
  if (!self) {
    return self;
  }
  truePerc = 100*right/(right+mistakes);
  falsePerc = 100 - truePerc;
  
  return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  resultSpinner = [[NLSpinner alloc]initWithFrame:resultSpinner.frame type:NLSpinnerTypeProgress startValue:0];
  [self.view addSubview:resultSpinner];
  [resultSpinner changeProgress:(float)truePerc/(truePerc+falsePerc) withValueAtCenter:truePerc];
  rightAnswers.text = [NSString stringWithFormat:@"%d%%", truePerc];
  falseAnswers.text = [NSString stringWithFormat:@"%d%%", falsePerc];
  truePerc = 0;
  falseAnswers = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToMenu:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
