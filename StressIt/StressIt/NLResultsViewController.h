//
//  NLResultsViewController.h
//  StressIt
//
//  Created by Alexey Goncharov on 05.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLSpinner.h"
@interface NLResultsViewController : UIViewController
@property (strong, nonatomic) IBOutlet NLSpinner *resultSpinner;
@property (strong, nonatomic) IBOutlet UILabel *rightAnswers;
@property (strong, nonatomic) IBOutlet UILabel *falseAnswers;
@property (strong, nonatomic) IBOutlet UILabel *trueLbl;
@property (strong, nonatomic) IBOutlet UILabel *falseLbl;

- (id)initWithRight:(int)right andMistakes:(int)mistakes;

@end
