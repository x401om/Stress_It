//
//  NLParser.h
//  StressIt
//
//  Created by Nikita Popov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLParser : NSObject

+ (void) parse;
- (void) parse;
+ (void)addTasks;
+ (void)fillFavourites;

@end
