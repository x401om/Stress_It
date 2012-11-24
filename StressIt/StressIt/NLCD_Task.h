//
//  NLCD_Task.h
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NLCD_Word;

@interface NLCD_Task : NSManagedObject

@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * rule;
@property (nonatomic, retain) NSOrderedSet *words;
@property (nonatomic, retain) NSOrderedSet *exceptions;

+ (NLCD_Task *)newTask;

@end



@interface NLCD_Task (CoreDataGeneratedAccessors)

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
- (void)insertObject:(NLCD_Word *)value inExceptionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromExceptionsAtIndex:(NSUInteger)idx;
- (void)insertExceptions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeExceptionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInExceptionsAtIndex:(NSUInteger)idx withObject:(NLCD_Word *)value;
- (void)replaceExceptionsAtIndexes:(NSIndexSet *)indexes withExceptions:(NSArray *)values;
- (void)addExceptionsObject:(NLCD_Word *)value;
- (void)removeExceptionsObject:(NLCD_Word *)value;
- (void)addExceptions:(NSOrderedSet *)values;
- (void)removeExceptions:(NSOrderedSet *)values;
@end
