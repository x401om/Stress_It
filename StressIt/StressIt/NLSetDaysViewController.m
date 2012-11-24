//
//  NLSetDaysViewController.m
//  StressIt
//
//  Created by Alexey Goncharov on 04.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLSetDaysViewController.h"
#import "NLLearningManager.h"
#import "NLWelcomeViewController.h"

#define kFontName @"Cuprum-Regular"
#define kFontSize 20
@interface NLSetDaysViewController ()

@end

@implementation NLSetDaysViewController

@synthesize slider, days, daysNaming, allWords, wordsPerDay, rank;
//@synthesize titleLbl, chooseTimeLbl, allWordsLbl, wordsPerDaysLbl, difficultyLbl, nextBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//  titleLbl.font = [UIFont fontWithName:kFontName size:kFontSize];
//  chooseTimeLbl.font = [UIFont fontWithName:kFontName size:kFontSize];
//  allWordsLbl.font = [UIFont fontWithName:kFontName size:kFontSize];
//  wordsPerDaysLbl.font = [UIFont fontWithName:kFontName size:kFontSize];
//  difficultyLbl.font = [UIFont fontWithName:kFontName size:kFontSize];

  n_allWords = 1800;
  rank.text = @"норм";
  allWords.text = [NSString stringWithFormat:@"%d", n_allWords];
  wordsPerDay.text = [NSString stringWithFormat:@"%d", n_allWords/days.text.intValue];
  [slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sliderChanged {
  int daysSelected = slider.value;
  n_wordPerDay = n_allWords/daysSelected;
  wordsPerDay.text = [NSString stringWithFormat:@"%d", n_wordPerDay];
  int n_days = n_allWords/n_wordPerDay;
  days.text = [NSString stringWithFormat:@"%d", n_allWords/n_wordPerDay];
  if (n_days%10 < 5 && n_days%10 > 1) daysNaming.text = @"дня";
    else if (n_days%10 == 1) daysNaming.text = @"день";
      else daysNaming.text = @"дней";
  
  if (n_wordPerDay >= 100)rank.text = @"псих";
    else if (n_wordPerDay >= 50) rank.text = @"неадекват";
      else if (n_wordPerDay > 30) rank.text = @"нерд";
        else if (n_wordPerDay > 20) rank.text = @"ботан";
          else rank.text = @"норм";
}

- (IBAction)nextButtonPressed:(id)sender {
  [[NSUserDefaults standardUserDefaults]setInteger:n_wordPerDay forKey:@"DaysAmount"];
  [[NSUserDefaults standardUserDefaults]synchronize];
  [self.navigationController pushViewController:[[NLWelcomeViewController alloc]init] animated:YES];
}
@end
