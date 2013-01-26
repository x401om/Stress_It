//
//  NLWordBlock.h
//  StressIt
//
//  Created by Alexey Goncharov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NLWord;

@interface NLWordBlock : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *words;
@property (nonatomic, retain) NSManagedObject *dictionary;
@property (nonatomic, retain) NSString* firstLetter;


+ (NLWordBlock *)blockWithWords:(NSArray *)words;
+ (NSArray *)allBlocks;
- (NSArray *)wordsArray;
- (NLWord *)getRandomWord;
- (void)deleteWordWithText:(NSString *)text;

+ (NLWordBlock *)findBlockWithTitle:(NSString *)title;

@end


@interface NLWordBlock (CoreDataGeneratedAccessors)

- (void)addWordsObject:(NLWord *)value;
- (void)removeWordsObject:(NLWord *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

- (NSComparisonResult)compare:(NLWordBlock *)aWordBlock;

@end
