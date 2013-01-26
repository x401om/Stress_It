//
//  NLLabel.h
//  StressIt
//
//  Created by Alexey Goncharov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "NLCD_Word.h"

@protocol NLLabelDelegate <NSObject>
@optional
- (void)userTouchedOnLetter:(NSNumber *)letter;
- (void)userAnsweredWithAnswer:(BOOL)answer;
@end

@interface NLLabel : TTTAttributedLabel {
  float pointSize;
  int stresssed;
  NSArray *vowelLetters;
  NLCD_Word *wordSource;
}

@property (strong, nonatomic) id <NLLabelDelegate> delegate;

- (id)initWithWord:(NLCD_Word*)word;
- (id)initWithFrame:(CGRect)frame andWord:(NLCD_Word *)word;
- (void)changeWordWithWord:(NLCD_Word *)word;

@end

