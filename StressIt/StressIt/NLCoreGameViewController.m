//
//  NLCoreGameViewController.m
//  StressIt
//
//  Created by Alexey Goncharov on 05.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLCoreGameViewController.h"
#import "NLLabel.h"
#import "NLAppDelegate.h"
#import "NLCD_Word.h"
#import "NLCD_Block.h"
#import "NLParser.h"
#import "Generator.h"
#import "NLLearningManager.h"
#import "NLResultsViewController.h"
#import "NLCD_Task.h"
#import "NLCD_Paragraph.h"

#define kCuprumFontName @"Cuprum-Regular"



@implementation NLCoreGameViewController

@synthesize label, exampleLabel, rightAnswers, progressRound, ruleLabel, firstWordButton, secondWordButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (id)initWithWords:(NSArray *)words {
  self = [super init];
  if (self) {


    contextObject = ((NLAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    trueButton = 0;
    
    allAnswers = 0;
    allTrueAnswers = 0;
    allQuestions = 0;
    
    currentWordNum = 0;
    currentTaskNum = 0;
    answers = 0;
    
    wordsOpened = NO;
   // [[UIApplication sharedApplication]setStatusBarHidden:YES];
  }
  return self;
}

- (id)initWithType:(NLGameType)type andParagraph:(NLCD_Paragraph *)paragraph {
  currentParagraph = paragraph;
  gameType = type;
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //label = [[NLLabel alloc]initWithWord:nil];
   trueButton = 0;
  
   allAnswers = 0;
   allTrueAnswers = 0;
   allQuestions = 0;
  
   currentWordNum = 0;
   currentTaskNum = 0;
   answers = 0;
  
   wordsOpened = NO;
  
  progressRound = [[NLSpinner alloc]initWithFrame:progressRound.frame type:NLSpinnerTypeProgress startValue:0];
  [self.view addSubview:progressRound];
  rightAnswers.text = [NSString stringWithFormat:@"%d / %d", answers, allQuestions];
  ruleLabel.font = [UIFont fontWithName:kCuprumFontName size:ruleLabel.font.pointSize];
  exampleLabel.font = [UIFont fontWithName:kCuprumFontName size:exampleLabel.font.pointSize];
  firstWordButton.titleLabel.font = [UIFont fontWithName:kCuprumFontName size:firstWordButton.titleLabel.font.pointSize];
  secondWordButton.titleLabel.font = [UIFont fontWithName:kCuprumFontName size:secondWordButton.titleLabel.font.pointSize];


  
//  NLCD_Block *block = blocks[currentBlock];
//  currentBlockArray = [block.words array];
//  [self presentNewWord];
  if (gameType == NLGameTypeTwo) {
    tasks = [currentParagraph.tasks allObjects];
    [self presentNewTask];
  }
}

- (void)presentNewTask {
  if (currentTaskNum >= 1) {
    //currentTaskNum = 0;
    //[self.navigationController pushViewController:[[NLResultsViewController alloc]initWithRight:allTrueAnswers andMistakes:(allQuestions - allTrueAnswers) ] animated:YES];
  }
  currentTask = tasks[currentTaskNum];
  ++currentTaskNum;
  ruleLabel.text = currentTask.rule;
  words = [currentTask.words array];
  wordsOpened = YES;
  [self presentNewWord];
}

- (void)presentNewWord {
  ++ allQuestions;
  if (currentWordNum >= words.count) {
    if (!wordsOpened) {
      [self presentNewTask];
      return;
    }
    words = [currentTask.exceptions array];
    wordsOpened = NO;
    currentWordNum = 0;
    [self presentNewWord];
    return;
  }
  currentWord = words[currentWordNum];
  exampleLabel.text = currentWord.example;
  ++currentWordNum;
  NLCD_Word *wrongWord = [currentWord.fails anyObject];
  trueButton = [Generator generateNewNumberWithStart:0 Finish:1];
  if (trueButton == 0) {
    [firstWordButton setTitle:currentWord.text forState:UIControlStateNormal];
    [secondWordButton setTitle:wrongWord.text forState:UIControlStateNormal];
  } else {
    [secondWordButton setTitle:currentWord.text forState:UIControlStateNormal];
    [firstWordButton setTitle:wrongWord.text forState:UIControlStateNormal];
  }
  
}


- (IBAction)firstWordChoosed:(id)sender {
  if (trueButton == 0) {
    [self showMainLabel];
  }
}
- (IBAction)secondWordChoosed:(id)sender {
  if (trueButton == 1) {
    [self showMainLabel];
  }
}

- (void)showMainLabel {
  if (label) {
    [label changeWordWithWord:currentWord];
  } else {
    label = [[NLLabel alloc]initWithFrame:CGRectMake(59, 188, 363, 52) andWord:currentWord];
  }

  label.delegate = self;
  firstWordButton.alpha = 0;
  secondWordButton.alpha = 0;
  [self.view addSubview:label];
}

#pragma mark Buttons Methods

- (IBAction)goToMainMenu:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)addToFavouritePressed:(id)sender {
  NSLog(@"Add to favourits");
}
- (IBAction)playSoundPressed:(id)sender {
  NSLog(@"playing sound...");
}
- (IBAction)questionPressedPressed:(id)sender {
  NSLog(@"What do u want to do, mr. Bean?");
}

#pragma mark NLLabelDelagate Methods

- (void)userTouchedOnLetter:(NSNumber *)letter {
  NSLog(@"smb touched on %@'th letter", letter);
}

- (void)userAnsweredWithAnswer:(BOOL)answer {
  ++allAnswers;

  rightAnswers.text = [NSString stringWithFormat:@"%d / %d", allAnswers, allQuestions];
  if (answer) {
    ++allTrueAnswers;
    [self performSelector:@selector(moveNext) withObject:nil afterDelay:2
     ];
  } 
  [progressRound changeProgress:(float)allTrueAnswers/allAnswers withValueAtCenter:allTrueAnswers];
}

- (void)moveNext {
  firstWordButton.alpha = 1;
  secondWordButton.alpha = 1;
  [label removeFromSuperview];
  //label = nil;
  [self presentNewWord];
}

- (void)viewDidUnload {
  label = nil;
  [super viewDidUnload];
}
@end
