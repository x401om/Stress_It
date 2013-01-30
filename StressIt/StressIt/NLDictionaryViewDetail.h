//
//  NLDictionaryViewDetail.h
//  StressIt
//
//  Created by Nikita Popov on 29.01.13.
//  Copyright (c) 2013 NIALSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLCD_Block.h"

@interface NLDictionaryViewDetail : UIViewController

@property (nonatomic, retain) IBOutlet UILabel* header;
@property (nonatomic, retain) IBOutlet UIButton* back;
@property (nonatomic, retain) IBOutlet UITextView* words;
@property (nonatomic, retain) NLCD_Block* currentBlock;

- (id)initWithBlock:(NLCD_Block*)block;
- (IBAction)goBack:(id)sender;

@end
