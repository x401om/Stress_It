//
//  NLDictionary.h
//  StressIt
//
//  Created by Alexey Goncharov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
  DictionaryTypeDefault = 0,
  DictionaryTypeLearning = 1
} DictionaryType;

@class NLWordBlock;

@interface NLDictionary : NSManagedObject

@property (nonatomic, retain) NSSet *blocks;
@property (nonatomic, retain) NSString *name;


+ (NLDictionary *)dictionaryWithBlocks:(NSArray *)blockSet andType:(DictionaryType)type;
+ (NLDictionary *)findDictionaryWithType:(DictionaryType)type;

+ (void)saveContext;

@end

@interface NLDictionary (CoreDataGeneratedAccessors)

- (void)addBlocksObject:(NLWordBlock *)value;
- (void)removeBlocksObject:(NLWordBlock *)value;
- (void)addBlocks:(NSSet *)values;
- (void)removeBlocks:(NSSet *)values;

@end
