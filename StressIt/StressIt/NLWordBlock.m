//
//  NLWordBlock.m
//  StressIt
//
//  Created by Alexey Goncharov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLWordBlock.h"
#import "NLWord.h"
#import "NLAppDelegate.h"

@implementation NLWordBlock

@dynamic title;
@dynamic words;
@dynamic dictionary;
@dynamic firstLetter;


+ (NLWordBlock *)blockWithWords:(NSArray *)words {
  NLWordBlock *newBlock = nil;
  NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  newBlock = [NSEntityDescription insertNewObjectForEntityForName:@"WordBlock" inManagedObjectContext:context];
  newBlock.words = [NSSet setWithArray:words];
  NLWord *titleWord = [words objectAtIndex:0];
  newBlock.title = titleWord.text;
  newBlock.firstLetter = [newBlock.title substringToIndex:1];
  //[newBlock saveContext];
  return newBlock;
}

+ (NSArray *)allBlocks {
   NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"WordBlock" inManagedObjectContext:context];
  request.predicate = [NSPredicate predicateWithFormat:@"words.count > 0"];
  NSError *error = nil;
  return [context executeFetchRequest:request error:&error];
}

- (NSArray *)wordsArray {
  return [self.words allObjects];
}

- (NLWord *)getRandomWord {
  return [self.words anyObject];
}

- (void)addWordsObject:(NLWord *)value {
  NSMutableArray *allObjects = [[self.words allObjects]mutableCopy];
  [allObjects addObject:value];
  self.words = [NSSet setWithArray:allObjects];
  NSLog(@"Added %@", value);
  //[self saveContext];
}

- (void)removeWordsObject:(NLWord *)value {
  NSOrderedSet *set = [NSOrderedSet orderedSetWithSet:self.words];
  NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:set];
  [tempSet removeObject:value];
  self.words = [NSSet setWithArray:[tempSet array]] ;
  NSLog(@"Removed %@", value);
  //[self saveContext];
}

- (NSString *)description {
  NSString *output = self.title;
  output = [output stringByAppendingString:@"\n"];
  for (NLWordBlock *desc in self.words) {
    output = [output stringByAppendingString:desc.description];
    output = [output stringByAppendingString:@"\n"];
  }
  return output;
}

- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (void)deleteWordWithText:(NSString *)text {
  [self removeWordsObject:[NLWord findWordWithText:text]];
}

+ (NLWordBlock *)findBlockWithTitle:(NSString *)title {
  NSManagedObjectContext *myContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"WordBlock" inManagedObjectContext:myContext];
  request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
  NSError *error = nil;
  return [[myContext executeFetchRequest:request error:&error]lastObject];
}

- (NSComparisonResult)compare:(NLWordBlock *)aWordBlock
{
  return [self.title localizedCaseInsensitiveCompare:aWordBlock.title];
}


@end
