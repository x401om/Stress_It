//
//  NLWelcomViewController.m
//  StressIt
//
//  Created by Alexey Goncharov on 04.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLWelcomeViewController.h"
#import "NLLearningManager.h"
#import "NLCoreGameViewController.h"
#import "NLCD_Dictionary.h"
#import "Generator.h"
#import "NLCD_Paragraph.h"

#define kCuprumFontName @"Cuprum-Regular"


@interface NLWelcomeViewController ()

@end

@implementation NLWelcomeViewController

@synthesize numberOfPart,numberOfParagraph, paragraphTitle, paragraphDeclaration;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define kCountOfBlocks 3

- (void)viewDidLoad
{
  [super viewDidLoad];
  for (UILabel *viewToChange in self.view.subviews) {
    if (viewToChange.tag == 1) {
      viewToChange.font = [UIFont fontWithName:kCuprumFontName size:viewToChange.font.pointSize];
    }
  }
  NLCD_Paragraph *currentPar = [NLCD_Paragraph paragraphWithNumber:1];
  //NSArray *tasks = [currentPar.tasks allObjects];
  numberOfParagraph.text = @"1";
  paragraphTitle.text = currentPar.title;
  paragraphDeclaration.text = currentPar.declaration;
  game = [[NLCoreGameViewController alloc]initWithType:NLGameTypeTwo andParagraph:currentPar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPressed:(id)sender {
  [self.navigationController pushViewController:game animated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
