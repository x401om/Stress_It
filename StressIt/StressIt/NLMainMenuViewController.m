//
//  NLMainMenuViewController.m
//  StressIt
//
//  Created by Alexey Goncharov on 09.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLMainMenuViewController.h"
#import "NLCoreGameViewController.h"
#import "NLDictionaryView.h"
#import "NLSetDaysViewController.h"
#import "NLWelcomeViewController.h"
#import "NLGameViewController.h"

@interface NLMainMenuViewController ()

@end

@implementation NLMainMenuViewController

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
  [[UIApplication sharedApplication]setStatusBarHidden:YES];  
  
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showActivityIndicator) name:@"ParceStart" object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideActivityIndicator) name:@"ParceDone" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)learningButtonPressed:(id)sender {
  [self.navigationController pushViewController:[[NLWelcomeViewController alloc]init] animated:YES];
  [self.label setHighlighted:NO];
}

-(IBAction)dictionaryButtonPressed:(id)sender {
  NLDictionaryView* dict = [[NLDictionaryView alloc] init];
  [self.navigationController pushViewController:dict animated:YES];
}

-(IBAction)learningButtonTouched:(id)sender {
  [self.label setHighlightedTextColor:[UIColor whiteColor]];
  [self.label setHighlighted:YES];
}

-(IBAction)learningButtonTouchEnded:(id)sender
{
  [self.label setHighlighted:NO];
}

- (void)showActivityIndicator {
	darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 320)];
	[darkView setBackgroundColor:[UIColor blackColor]];
	[darkView setAlpha:0];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(darkView.frame.size.width/2 - 30, darkView.frame.size.height/2-30, 60, 60)];
	[darkView addSubview:spinner];
	[spinner startAnimating];
	[self.view addSubview:darkView];
	[UIView animateWithDuration:0.3 animations:^{
		[darkView setAlpha:0.5];
	}];
  self.view.userInteractionEnabled = NO;
}

- (void)hideActivityIndicator {
	[UIView animateWithDuration:0.3 animations:^{
		[darkView setAlpha:0];
	}];
	[darkView removeFromSuperview];
  self.view.userInteractionEnabled = YES;
}

- (IBAction)settingsPressed:(id)sender {
  
  //[self.navigationController pushViewController:[[NLSetDaysViewController alloc]init] animated:YES];
}

- (IBAction)gameButtonPressed {
    NLGameViewController *vc = [[NLGameViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation = UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
