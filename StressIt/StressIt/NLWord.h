//
//  NLWord.h
//  StressIt
//
//  Created by Alexey Goncharov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
typedef enum _WordState {
  NLWordStateFavourite,
  NLWordStateRight,
  NLWordStateWrong,
  NLWordStateNew,
  NLWordStateUsed
} NLWordState;

@interface NLWord : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * example;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSNumber * secondStressed;
@property (nonatomic, retain) NSNumber * stressed;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSManagedObject *block;

+ (NLWord *)wordWithText:(NSString *)text andStressed:(int)stressedVowel;
+ (NLWord *)findWordWithText:(NSString *)text;

+ (NSArray *)newWordsForTodaysTest:(int)amount;
+ (NSArray *)newWordBlockToStudyTodayInAmount:(int)amount;
@end
