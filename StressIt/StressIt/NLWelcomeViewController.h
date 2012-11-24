//
//  NLWelcomViewController.h
//  StressIt
//
//  Created by Alexey Goncharov on 04.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NLCoreGameViewController;

@interface NLWelcomeViewController : UIViewController {
  NLCoreGameViewController *game;
}
@property (strong, nonatomic) IBOutlet UILabel *numberOfPart;
@property (strong, nonatomic) IBOutlet UILabel *numberOfParagraph;
@property (strong, nonatomic) IBOutlet UILabel *paragraphTitle;
@property (strong, nonatomic) IBOutlet UILabel *paragraphDeclaration;


- (IBAction)nextButtonPressed:(id)sender;

@end
