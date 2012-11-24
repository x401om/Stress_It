//
//  NLSpinner.h
//  StressIt
//
//  Created by Alexey Goncharov on 27.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  NLSpinnerTypeTimer = 0,
  NLSpinnerTypeProgress = 1,
  NLSpinnerTypeDefault = 2
} NLSpinnerType;

@interface NLSpinner : UIView

@property float time, offset;
@property CGFloat* colors;
@property NSTimer* timer;
@property UILabel* centerLabel;
@property NLSpinnerType type;
@property float estimatedProgress, estimatedValue;


- (id)initWithFrame:(CGRect)frame type:(NLSpinnerType)type startValue:(int)value;
- (id)initWithFrame:(CGRect)frame type:(NLSpinnerType)type colors:(NSArray *)colors startValue:(int)value;

- (void)changeProgress:(float)progress withValueAtCenter:(int)value;
- (void)startSpin;
- (void)stopSpin;

+ (id)staticSpinnerWithProgress:(float)progress valueAtCenter:(int)value frame:(CGRect)frame;
+ (id)staticSpinnerWithProgress:(float)progress valueAtCenter:(int)value colors:(NSArray *)colors frame:(CGRect)frame;

@end
