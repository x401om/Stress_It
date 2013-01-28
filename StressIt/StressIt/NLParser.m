//
//  NLParser.m
//  StressIt
//
//  Created by Nikita Popov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLParser.h"
#import "NLCD_Word.h"
#import "NLCD_Block.h"
#import "NLCD_Dictionary.h"
#import "NLCD_Paragraph.h"
#import "NLCD_Task.h"
#import "NLAppDelegate.h"

@implementation NLParser

+ (void)parse {
  @autoreleasepool {
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"All_Forms"
                                                             ofType:@"txt"];
    __block int count, bad;
    bad = 0;
    count = 0;
    NSError* error;
    NSDate* tempDate = [NSDate date];
    NSString* file = [NSString stringWithContentsOfFile:resourcePath
                                               encoding:NSWindowsCP1251StringEncoding
                                                  error:&error];
    [file enumerateLinesUsingBlock:^(NSString* line, BOOL* stop){
      @autoreleasepool {
        NSMutableString* currentString = [line mutableCopy];
        currentString = [[currentString substringFromIndex:[currentString rangeOfString:@"#"].location+1] mutableCopy];
        NSRange currentRange = [currentString rangeOfString:@","];
        NSMutableArray* arrayForBlock = [NSMutableArray array];
        while (currentRange.length!=0) @autoreleasepool {
          NSString* currentWord = [currentString substringToIndex:currentRange.location];
          NSRange currentRangeForWord = {0,currentRange.location+1};
          [currentString replaceCharactersInRange:currentRangeForWord withString:@""];
          currentRange = [currentString rangeOfString:@","];
          NSMutableArray* stressedArray = [NSMutableArray arrayWithCapacity:2];
          NSRange stressRange = [currentWord rangeOfString:@"'"];
          while (stressRange.location!=NSNotFound) {
            [stressedArray addObject:[NSNumber numberWithInt:stressRange.location - 1]];
            currentWord = [currentWord stringByReplacingCharactersInRange:stressRange withString:@""];
            stressRange = [currentWord rangeOfString:@"'"];
          }
          if ([stressedArray count]==0) {
            NSLog(@"no stress found in word %@",currentWord);
            ++bad;
          }
          else {
            NLCD_Word* insertWord = [NLCD_Word wordWithText:currentWord
                                           andStressed:[stressedArray[0] intValue]];
            if([stressedArray count]==2)
            {
              insertWord.secondStressed = stressedArray[1];
            }
            [arrayForBlock addObject:insertWord];
          }
        }
        NLCD_Block* block;
        if([arrayForBlock count]!=0)
        {
          block = [NLCD_Block blockWithWords:arrayForBlock];
          ++count;
        
        }
        if (count==1000) {
          [(NLAppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
          [[(NLAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] reset];
          count = 0;
        }
      }
    }];
    [(NLAppDelegate*)[[UIApplication sharedApplication] delegate] saveContext];
    [[(NLAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] reset];
    [NLParser fillFavourites];
    [NLParser addTasks];
    NSLog(@"%f",-[tempDate timeIntervalSinceNow]);
    NSLog(@"%d",bad);
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ParceDone" object:nil];
}

- (void) parse {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ParceStart" object:nil];
  [NLParser parse];
}

+ (void)fillFavourites {
  NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"dataArr" ofType:@"plist"];
  NSArray *data = [NSArray arrayWithContentsOfFile:resourcePath];
  NSMutableArray *blocksArray = [NSMutableArray array];
  for (NSString *currentWord in data) {
    NLCD_Block *newBlock = [NLCD_Block findBlockWithTitle:currentWord];
    if (newBlock.title) {
      //NSLog(@"found %@", newBlock.title);
      [blocksArray addObject:newBlock];
    }
  }
  [NLCD_Dictionary dictionaryWithBlocks:blocksArray
                                andType:DictionaryTypeLearning];
  return;
}

+ (void)addTasks {
  NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"Tasks"
                                                           ofType:@"plist"];
  NSArray *data = [NSArray arrayWithContentsOfFile:resourcePath];
  int num = 0;
  for (NSDictionary *currentParagraph in data) {
    ++num;
    NLCD_Paragraph *myParagraph = [NLCD_Paragraph newParagraph];
    myParagraph.number = [NSNumber numberWithInt:num];
    myParagraph.title = currentParagraph[@"Title"];
    myParagraph.declaration = currentParagraph[@"Declaration"];
    // task handling
    NSArray *tasks = currentParagraph[@"Tasks"];
    NSMutableArray *myTasks = [NSMutableArray array];
    for (NSDictionary *currentTask in tasks) {
      NLCD_Task *myTask = [NLCD_Task newTask];
      myTask.title = currentTask[@"Title"];
      myTask.rule = currentTask[@"Rule"];
      // words handling
      NSArray *tWords = currentTask[@"Words"];
      NSMutableArray *words = [NSMutableArray array];
      for (NSString *str in tWords) {
        NSRange range = [str rangeOfString:@"—"];
        if (range.location == NSNotFound) continue;
        NSArray *arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"— (){}"]];
        NSString *example = arr[4];
        NSString *word = arr[6];
        NSArray *cuttedWord = [word componentsSeparatedByString:@"\u0301"];
        word = cuttedWord[0];
        int stressed = word.length-1;
        if (cuttedWord.count > 1) {
          word = [word stringByAppendingString:cuttedWord[1]];
        }
        NLCD_Word * newWord = [NLCD_Word wordWithText:word andStressed:stressed];
        //NSLog(newWord.description);
        newWord.example = example;
        NSString *mistake = arr[8];
        cuttedWord = [mistake componentsSeparatedByString:@"\u0301"];
        mistake = cuttedWord[0];
        stressed = mistake.length-1;
        if (cuttedWord.count > 1) {
          mistake = [mistake stringByAppendingString:cuttedWord[1]];
        }
        NLCD_Word *newMistake = [NLCD_Word wordWithText:mistake andStressed:stressed];
        newWord.fails = [NSSet setWithObject:newMistake];
        [words addObject:newWord];
      }
      myTask.words = [[NSOrderedSet alloc]initWithArray:words];
      // handling exceptions
      NSArray *tExceptions = currentTask[@"Exceptions"];
      [words removeAllObjects];
      for (NSString *str in tExceptions) {
        NSRange range = [str rangeOfString:@"—"];
        if (range.location == NSNotFound) continue;
        NSArray *arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"— (){}"]];
        NSString *example = arr[4];
        NSString *word = arr[6];
        NSArray *cuttedWord = [word componentsSeparatedByString:@"\u0301"];
        word = cuttedWord[0];
        int stressed = word.length-1;
        if (cuttedWord.count > 1) {
          word = [word stringByAppendingString:cuttedWord[1]];
        }
        NLCD_Word * newWord = [NLCD_Word wordWithText:word andStressed:stressed];
        NSLog(newWord.description);
        newWord.example = example;
        NSString *mistake = arr[8];
        cuttedWord = [mistake componentsSeparatedByString:@"\u0301"];
        mistake = cuttedWord[0];
        stressed = mistake.length-1;
        if (cuttedWord.count > 1) {
          mistake = [mistake stringByAppendingString:cuttedWord[1]];
        }
        NLCD_Word *newMistake = [NLCD_Word wordWithText:mistake andStressed:stressed];
        newWord.fails = [NSSet setWithObject:newMistake];
        [words addObject:newWord];
      }
      myTask.exceptions = [[NSOrderedSet alloc]initWithArray:words];
      [myTasks addObject:myTask];
    }
  myParagraph.tasks = [NSSet setWithArray:myTasks];
  }
  NSLog(@"saving");
  [(NLAppDelegate *)[[UIApplication sharedApplication]delegate] saveContext];
  NSLog(@"saving completed");
}


@end
