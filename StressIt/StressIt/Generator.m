//
//  Generator.m
//  Project2
//
//  Created by Алексей Гончаров on 24.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "Generator.h"
@implementation Generator

+ (int)generateNewNumberWithStart:(int)start Finish:(int)finish {
	float rndValue = (((float)arc4random()/0x100000000)*(finish - start)+start);
	return (int)(rndValue + 0.5);
}


@end
