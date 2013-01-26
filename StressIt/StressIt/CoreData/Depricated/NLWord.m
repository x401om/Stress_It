//
//  NLWord.m
//  StressIt
//
//  Created by Alexey Goncharov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLWord.h"
#import "NLAppDelegate.h"

@implementation NLWord

@dynamic text;
@dynamic secondStressed;
@dynamic stressed;
@dynamic state;
@dynamic block;
@dynamic example;
@dynamic info;

+ (id)wordWithText:(NSString *)text andStressed:(int)stressedVowel { 
  NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NLWord *newWord = nil;
  newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:context];
  newWord.text = text;
  newWord.secondStressed = [NSNumber numberWithInt:-1];
  newWord.stressed = [NSNumber numberWithInt:stressedVowel];
  newWord.state = [NSNumber numberWithInt:0];
  //[newWord saveContext];
  return newWord;
}

- (NSString *)description {
  int stressedPosition = [self.stressed intValue] + 1;
  NSString *output = [NSString stringWithFormat:@"%@\u0301%@", [self.text substringToIndex:stressedPosition], [self.text substringFromIndex:stressedPosition]];
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

+ (NLWord *)findWordWithText:(NSString *)text {
  NSManagedObjectContext *myContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:myContext];
  request.predicate = [NSPredicate predicateWithFormat:@"text = %@",text];
  NSError *error = nil;    
  return [[myContext executeFetchRequest:request error:&error]lastObject];
}

+ (NLWord *)findWordWithState:(NSNumber *)state {
  NSManagedObjectContext *myContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:myContext];
  request.predicate = [NSPredicate predicateWithFormat:@"state = %@",state];
  NSError *error = nil;
  return [[myContext executeFetchRequest:request error:&error]lastObject];
}

#pragma mark word for study and tests
+ (NSArray *)newWordsForTodaysTest:(int)amount {
    NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *requestToBase = [[NSFetchRequest alloc] init];
    requestToBase.entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:context];
    requestToBase.fetchLimit = amount;
    requestToBase.predicate = [NSPredicate predicateWithFormat:@"state = %d OR state = %d", NLWordStateWrong, NLWordStateFavourite];
    NSError *error;
    NSArray *wordForTest = [NSArray arrayWithArray:[context executeFetchRequest:requestToBase error:&error]];
    
        NSLog(@"%d", wordForTest.count);
    
        for (NLWord *str in wordForTest) {
            NSLog(@"%@", str.text);
        }
    
    return wordForTest;
}
+ (NSArray *)newWordBlockToStudyTodayInAmount:(int)amount {
    NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *requestToBase = [[NSFetchRequest alloc] init];
    requestToBase.fetchLimit = amount;
    requestToBase.entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:context];
    requestToBase.predicate = [NSPredicate predicateWithFormat:@"state = %d", NLWordStateNew];
    NSError *error;
    NSArray *wordsToStudy = [NSArray arrayWithArray:[context executeFetchRequest:requestToBase error:&error]];
    for (NLWord *word in wordsToStudy) {
        word.state = [NSNumber numberWithInt:NLWordStateUsed];
        [word saveContext];
    }
//    NSLog(@"%d", wordsToStudy.count);
//    
//    for (NLWord *str in wordsToStudy) {
//        NSLog(@"%@", str.text);
//    }
    
    return wordsToStudy;
}
+ (NSArray *)getFavouriteList {
    NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *requestToBase = [[NSFetchRequest alloc] init];
    requestToBase.entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:context];
    requestToBase.predicate = [NSPredicate predicateWithFormat:@"state = %d", NLWordStateFavourite];
    NSError *error;
    NSArray *wordsToStudy = [NSArray arrayWithArray:[context executeFetchRequest:requestToBase error:&error]];
    for (NLWord *word in wordsToStudy) {
        word.state = [NSNumber numberWithInt:NLWordStateUsed];
//        [word saveContext];
    }

    return wordsToStudy;
}

@end
