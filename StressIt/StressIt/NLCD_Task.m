//
//  NLCD_Task.m
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLCD_Task.h"
#import "NLCD_Word.h"
#import "NLAppDelegate.h"

@implementation NLCD_Task

@dynamic point;
@dynamic title;
@dynamic rule;
@dynamic words;
@dynamic exceptions;

+ (NLCD_Task *)newTask {
  NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NLCD_Task *newTask = nil;
  newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
  return newTask;
}

- (NSString *)description {
  int n = [self.point intValue];
  NSString *d = self.rule;
  NSString *str = [NSString stringWithFormat:@"#%d %@", n, d];
  return str;
}

@end
