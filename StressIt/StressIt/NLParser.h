//
//  NLParser.h
//  StressIt
//
//  Created by Nikita Popov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NLSpinner;

@interface NLParser : NSObject

+ (void) parse;
+ (void)parseWithSpinner:(NLSpinner*)spinner;
- (void)parseWithSpinner:(NLSpinner*)spinner;
- (void) parse;
+ (void)addTasks;
+ (void)fillFavourites;

@end
