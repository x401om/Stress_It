//
//  NLCoreGameViewController.h
//  StressIt
//
//  Created by Alexey Goncharov on 05.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLLabel.h"
#import "NLSpinner.h"

@class NLCD_Paragraph, NLCD_Task;

typedef enum {
  NLGameTypeTwo
} NLGameType;

@interface NLCoreGameViewController : UIViewController <NLLabelDelegate> {
  NSManagedObjectContext *contextObject;
  NLCD_Paragraph *currentParagraph;
  NLCD_Task *currentTask;
  NLCD_Word *currentWord;
  NLGameType gameType;
  NSArray *tasks;
  NSArray *words;
  
   int trueButton ;
  
   int allAnswers ;
   int allTrueAnswers ;
   int allQuestions ;
  
   int currentWordNum ;
   int currentTaskNum ;
   int answers ;
  
   BOOL wordsOpened ;
}

@property (strong, nonatomic) IBOutlet UILabel *ruleLabel;
@property (nonatomic, strong) IBOutlet NLLabel* label;
@property (strong, nonatomic) IBOutlet UILabel *exampleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightAnswers;
@property (strong, nonatomic) IBOutlet NLSpinner *progressRound;

//buttons
@property (strong, nonatomic) IBOutlet UIButton *favouriteButton;
@property (strong, nonatomic) IBOutlet UIView *soundButton;
@property (strong, nonatomic) IBOutlet UIButton *questionButton;
@property (strong, nonatomic) IBOutlet UIButton *firstWordButton;
@property (strong, nonatomic) IBOutlet UIButton *secondWordButton;

- (id)initWithWords:(NSArray *)words;
- (id)initWithType:(NLGameType)type andParagraph:(NLCD_Paragraph *)paragraph;

@end
