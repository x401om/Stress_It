//
//  NLCD_Block.m
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLCD_Block.h"
#import "NLCD_Word.h"
#import "NLAppDelegate.h"

@implementation NLCD_Block

@dynamic firstLetter;
@dynamic title;
@dynamic words;

+ (NLCD_Block *)blockWithWords:(NSArray *)words {
  NLCD_Block *newBlock = nil;
  NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  newBlock = [NSEntityDescription insertNewObjectForEntityForName:@"Block" inManagedObjectContext:context];
  newBlock.words = [[NSOrderedSet alloc]initWithArray:words];
  NLCD_Word *titleWord = [words objectAtIndex:0];
  newBlock.title = titleWord.text;
  newBlock.firstLetter = [newBlock.title substringToIndex:1];
  return newBlock;
}
+ (NSArray *)allBlocks {
  NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Block" inManagedObjectContext:context];
  request.predicate = [NSPredicate predicateWithFormat:@"words.count > 0"];
  NSError *error = nil;
  return [context executeFetchRequest:request error:&error];
}
- (NSArray *)wordsArray {
  return [[self.words set]allObjects];
}
- (NLCD_Word *)getRandomWord {
  return [[self.words set]anyObject];
}
+ (NLCD_Block *)findBlockWithTitle:(NSString *)title {
  NSManagedObjectContext *myContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Block" inManagedObjectContext:myContext];
  request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
  NSError *error = nil;
  return [[myContext executeFetchRequest:request error:&error]lastObject];
}
- (NSString *)description {
  NSString *output = self.title;
  output = [output stringByAppendingString:@"\n"];
  for (NLCD_Block *desc in self.words) {
    output = [output stringByAppendingString:desc.description];
    output = [output stringByAppendingString:@"\n"];
  }
  return output;
}
- (void)deleteWordWithText:(NSString *)text {
  [self removeWordsObject:[NLCD_Word findWordWithText:text]];
}
- (void)removeWordsObject:(NLCD_Word *)value {
  NSOrderedSet *set = self.words;
  NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:set];
  [tempSet removeObject:value];
  self.words = [NSSet setWithArray:[tempSet array]] ;
  NSLog(@"Removed %@", value);
  [NLCD_Word saveContext];
}



@end
