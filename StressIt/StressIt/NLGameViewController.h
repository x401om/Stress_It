//
//  NLGameViewController.h
//  StressIt
//
//  Created by Виталий Давыдов on 19.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "NLLabel.h"
#import "NLCD_Word.h"
#import "NLCD_Block.h"

@interface NLGameViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate, NLLabelDelegate>

@property GKSession *session;
@property (strong, nonatomic) NLLabel *word;
@property NSArray *wordsForGame;
@property int playerScores;
@property (weak, nonatomic) IBOutlet UILabel *myScores;
@property (weak, nonatomic) IBOutlet UILabel *apponentScore;

@end
