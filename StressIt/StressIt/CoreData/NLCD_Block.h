//
//  NLCD_Block.h
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NLCD_Word;

@interface NLCD_Block : NSManagedObject

@property (nonatomic, retain) NSString * firstLetter;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *words;


+ (NLCD_Block *)blockWithWords:(NSArray *)words;
+ (NSArray *)allBlocks;
- (NSArray *)wordsArray;
- (NLCD_Word *)getRandomWord;
+ (void)deleteWordWithText:(NSString *)text;
+ (NLCD_Block *)findBlockWithTitle:(NSString *)title;

@end
@interface NLCD_Block (CoreDataGeneratedAccessors)

- (void)insertObject:(NLCD_Word *)value inWordsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWordsAtIndex:(NSUInteger)idx;
- (void)insertWords:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWordsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWordsAtIndex:(NSUInteger)idx withObject:(NLCD_Word *)value;
- (void)replaceWordsAtIndexes:(NSIndexSet *)indexes withWords:(NSArray *)values;
- (void)addWordsObject:(NLCD_Word *)value;
- (void)removeWordsObject:(NLCD_Word *)value;
- (void)addWords:(NSOrderedSet *)values;
- (void)removeWords:(NSOrderedSet *)values;
@end
