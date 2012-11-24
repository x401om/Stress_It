//
//  NLCD_Word.m
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLCD_Word.h"
#import "NLCD_Block.h"
#import "NLAppDelegate.h"
#import "Generator.h"
#import "NLCD_Dictionary.h"

@implementation NLCD_Word

@dynamic example;
@dynamic info;
@dynamic secondStressed;
@dynamic state;
@dynamic stressed;
@dynamic text;
@dynamic fails;

+ (NLCD_Word *)wordWithText:(NSString *)text andStressed:(int)stressedVowel {
  NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NLCD_Word *newWord = nil;
  newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:context];
  newWord.text = text;
  newWord.secondStressed = [NSNumber numberWithInt:-1];
  newWord.stressed = [NSNumber numberWithInt:stressedVowel];
  newWord.state = [NSNumber numberWithInt:0];
  return newWord;
}

+ (NLCD_Word *)findWordWithText:(NSString *)text {
  NSManagedObjectContext *myContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:myContext];
  request.predicate = [NSPredicate predicateWithFormat:@"text = %@",text];
  NSError *error = nil;
  return [[myContext executeFetchRequest:request error:&error]lastObject];
}

+ (NLCD_Word *)findWordWithText:(NSString *)text andStressed:(int)stressed {
  NSManagedObjectContext *myContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:myContext];
  request.predicate = [NSPredicate predicateWithFormat:@"text = %@ && stressed = %d",text, stressed];
  NSError *error = nil;
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

- (NSString *)description {
  int stressedPosition = [self.stressed intValue] + 1;
  NSString *output = [NSString stringWithFormat:@"%@\u0301%@", [self.text substringToIndex:stressedPosition], [self.text substringFromIndex:stressedPosition]];
  return output;
}

+ (NSArray *)getRandomWordsInAmount:(int)amount {
    NLCD_Dictionary *dict = [NLCD_Dictionary findDictionaryWithType:DictionaryTypeLearning];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:amount];
    
    NSUInteger blocksCount = dict.blocks.count;
    for (int i = 0; i < amount; ++i) {
        NSUInteger randIndex = [Generator generateNewNumberWithStart:0 Finish:blocksCount-1];
        NLCD_Block *block = [dict.blocks objectAtIndex:randIndex];
        [array addObject:[block.words objectAtIndex:0]];
    }
    
    return array;
}


@end
