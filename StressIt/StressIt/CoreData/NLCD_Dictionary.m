//
//  NLCD_Dictionary.m
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLCD_Dictionary.h"
#import "NLCD_Block.h"
#import "NLAppDelegate.h"

@implementation NLCD_Dictionary
#define kDefaultName @"default"
#define kLearningName @"learning"
@dynamic name;
@dynamic blocks;

+ (NLCD_Dictionary *)dictionaryWithBlocks:(NSArray *)blockSet andType:(DictionaryType)type {
  NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NLCD_Dictionary *newDictionary = nil;
  newDictionary = [NSEntityDescription insertNewObjectForEntityForName:@"Dictionary" inManagedObjectContext:context];
  newDictionary.name = type == 0 ? kDefaultName : kLearningName;
  newDictionary.blocks = [[NSOrderedSet alloc]initWithArray:blockSet];
  [NLCD_Dictionary saveContext];
  return newDictionary;
}

+ (NLCD_Dictionary *)findDictionaryWithType:(DictionaryType)type {
  NSManagedObjectContext *myContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Dictionary" inManagedObjectContext:myContext];
  NSString *name = type == 0 ? kDefaultName : kLearningName;
  request.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
  NSError *error = nil;
  //NLCD_Dictionary *d = [[myContext executeFetchRequest:request error:&error]lastObject];
  //NLCD_Block *b = [d.blocks lastObject];
  return [[myContext executeFetchRequest:request error:&error]lastObject];
}

+ (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

@end
