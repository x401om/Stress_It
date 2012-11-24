//
//  Generator.h
//  Project2
//
//  Created by Алексей Гончаров on 24.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//
//  Простейший класс, который способен генерировать одно целое число, имеет единственный метод
//  который принимает диапазон значений. Musthave, нужен везде =)


#import <Foundation/Foundation.h>
@interface Generator : NSObject

+ (int)generateNewNumberWithStart:(int)start Finish:(int)finish;

@end
