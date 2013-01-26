//
//  NLCD_Paragraph.m
//  StressIt
//
//  Created by Alexey Goncharov on 12.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLCD_Paragraph.h"
#import "NLCD_Task.h"
#import "NLAppDelegate.h"

@implementation NLCD_Paragraph

@dynamic title;
@dynamic declaration;
@dynamic number;
@dynamic tasks;

+ (NLCD_Paragraph *)newParagraph {
  NLCD_Paragraph *newParagraph = nil;
  NSManagedObjectContext *context = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  newParagraph = [NSEntityDescription insertNewObjectForEntityForName:@"Paragraph" inManagedObjectContext:context];
  return newParagraph;
}

+ (NLCD_Paragraph *)paragraphWithNumber:(int)number {
  NSManagedObjectContext *myContext = ((NLAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Paragraph" inManagedObjectContext:myContext];
  request.predicate = [NSPredicate predicateWithFormat:@"number = %d",number];
  NSError *error = nil;
  return [[myContext executeFetchRequest:request error:&error]lastObject];
}

- (NSString *)description {
  int n = [self.number intValue];
  NSString *d = self.declaration;
  NSString *str = [NSString stringWithFormat:@"§%d %@", n, d];
  return str;
}


@end
