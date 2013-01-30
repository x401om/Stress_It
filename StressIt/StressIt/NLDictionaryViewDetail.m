//
//  NLDictionaryViewDetail.m
//  StressIt
//
//  Created by Nikita Popov on 29.01.13.
//  Copyright (c) 2013 NIALSoft. All rights reserved.
//

#import "NLDictionaryViewDetail.h"
#import "NLCD_Word.h"

@interface NLDictionaryViewDetail ()

@end

@implementation NLDictionaryViewDetail
@synthesize header, words, back,currentBlock;

- (id)initWithBlock:(NLCD_Block*)block
{
  self = [super init];
  currentBlock = block;
  
  return self;
}
-(IBAction)goBack:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)viewWillAppear:(BOOL)animated
{
  header.text = [[[currentBlock wordsArray] objectAtIndex:0] description];
  [header sizeToFit];
  for (NLCD_Word* temp in [currentBlock wordsArray]) {
    words.text = [words.text stringByAppendingFormat:@"\n%@",[temp description]];
  }
}

@end
