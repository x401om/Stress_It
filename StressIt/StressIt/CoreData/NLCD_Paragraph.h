//
//  NLCD_Paragraph.h
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NLCD_Task;

@interface NLCD_Paragraph : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * declaration;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface NLCD_Paragraph (CoreDataGeneratedAccessors)

+ (NLCD_Paragraph *)newParagraph;
+ (NLCD_Paragraph *)paragraphWithNumber:(int)number;

- (void)addTasksObject:(NLCD_Task *)value;
- (void)removeTasksObject:(NLCD_Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
