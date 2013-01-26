//
//  NLCD_Dictionary.h
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NLCD_Block;

typedef enum {
  DictionaryTypeDefault = 0,
  DictionaryTypeLearning = 1
} DictionaryType;

@interface NLCD_Dictionary : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *blocks;

+ (NLCD_Dictionary *)dictionaryWithBlocks:(NSArray *)blockSet andType:(DictionaryType)type;
+ (NLCD_Dictionary *)findDictionaryWithType:(DictionaryType)type;
+ (void)saveContext;

@end

@interface NLCD_Dictionary (CoreDataGeneratedAccessors)

- (void)insertObject:(NLCD_Block *)value inBlocksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBlocksAtIndex:(NSUInteger)idx;
- (void)insertBlocks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBlocksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBlocksAtIndex:(NSUInteger)idx withObject:(NLCD_Block *)value;
- (void)replaceBlocksAtIndexes:(NSIndexSet *)indexes withBlocks:(NSArray *)values;
- (void)addBlocksObject:(NLCD_Block *)value;
- (void)removeBlocksObject:(NLCD_Block *)value;
- (void)addBlocks:(NSOrderedSet *)values;
- (void)removeBlocks:(NSOrderedSet *)values;
@end
