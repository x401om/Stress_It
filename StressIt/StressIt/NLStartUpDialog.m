//
//  NLStartUpDialog.m
//  StressIt
//
//  Created by Nikita Popov on 31.01.13.
//  Copyright (c) 2013 NIALSoft. All rights reserved.
//

#import "NLStartUpDialog.h"
#import "NLParser.h"
#import "NLMainMenuViewController.h"
#import "NLAppDelegate.h"
#import "NLSpinner.h"

@interface NLStartUpDialog ()

@end

@implementation NLStartUpDialog
@synthesize next, prev;

- (void)viewWillAppear:(BOOL)animated
{
  if ([NLAppDelegate copyToDocumentsFile:@"StressIt" ofType:@"sqlite"])
  {
    NLMainMenuViewController* mainmenu = [[NLMainMenuViewController alloc] init];
    [self.navigationController pushViewController:mainmenu animated:NO];
  }
  [[UIApplication sharedApplication]setStatusBarHidden:YES];  
}

- (IBAction)parseData:(id)sender
{
  NLSpinner* spin = [[NLSpinner alloc] initWithFrame:CGRectMake(40, 130, 150, 150) type:NLSpinnerTypeProgress startValue:0];
  [self.view addSubview:spin];
  [spin setAlpha:0];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipParsing:) name:@"ParceDone" object:nil];
  [next setEnabled:NO];
  [prev setEnabled:NO];
  [[NLParser alloc] performSelectorInBackground:@selector(parseWithSpinner:) withObject:spin];
  [UIView animateWithDuration:0.5 animations:^{
    [spin setAlpha:1];
  }];
}

- (IBAction)skipParsing:(id)sender
{
  NLMainMenuViewController* mainmenu = [[NLMainMenuViewController alloc] init];
  [self.navigationController pushViewController:mainmenu animated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}


@end
