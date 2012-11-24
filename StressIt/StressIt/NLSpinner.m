//
//  NLSpinner.m
//  StressIt
//
//  Created by Alexey Goncharov on 27.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLSpinner.h"

#define kSpinPeriod 1

@implementation NLSpinner
@synthesize time,offset;
@synthesize colors;
@synthesize timer;
@synthesize centerLabel;
@synthesize type;
@synthesize estimatedValue, estimatedProgress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)newFrame type:(NLSpinnerType)newType startValue:(int)value
{
  NSArray* newColors = @[@(202.0/255), @(46.0/255), @(120.0/255), @1.0, @(73.0/255), @(177.0/255), @(216.0/255), @1.0];
  self = [self initWithFrame:newFrame type:newType colors:newColors startValue:value];
  return self;
}

-(id)initWithFrame:(CGRect)frame type:(NLSpinnerType)newType colors:(NSArray *)newColors startValue:(int)value
{
  self = [super initWithFrame:frame];
  if (self) {
    time = 0.0;
    offset = 0.0;
    [self setBackgroundColor:[UIColor clearColor]];
    UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timerTop"]];
    [image setFrame:CGRectMake(0, 0, frame.size.width*0.5, frame.size.height*0.5)];
    [image setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    [self addSubview:image];
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timerUnder"]];
    [image setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    [image setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:image];
    
    colors = malloc(sizeof(CGFloat)*8);
    for (int i=0; i<8; ++i) {
      colors[i] = [newColors[i] floatValue];
    }
    centerLabel = [[UILabel alloc] initWithFrame:frame];
    if(newType!=NLSpinnerTypeDefault) centerLabel.text = [@(value) stringValue];
    centerLabel.textColor = [UIColor darkGrayColor];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.backgroundColor = [UIColor clearColor];
    centerLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:frame.size.width*0.3];
    centerLabel.center = image.center;
    [self addSubview:centerLabel];
    type = newType;
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
  CGColorSpaceRelease(baseSpace), baseSpace = NULL;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGFloat myCenterX = self.bounds.size.width/2;
  CGFloat myCenterY = self.bounds.size.height/2;
  CGFloat myRadius = myCenterY;
  CGFloat mySmallRadius = 0.3;
  CGFloat myBigRadius = 0.8;
  CGContextSaveGState(context);
  CGContextMoveToPoint(context, myCenterX + mySmallRadius*myRadius*cos(-M_PI_2 +offset), myCenterY + mySmallRadius*myRadius*sin(-M_PI_2 +offset));
  CGContextAddLineToPoint(context, myCenterX + myBigRadius*myRadius*cos(-M_PI_2 +offset), myCenterY + myBigRadius*myRadius*sin(-M_PI_2 +offset));
  
  CGContextAddArc(context, myCenterX, myCenterY, myBigRadius*myRadius, -M_PI_2 + offset, - M_PI_2+time, 0);
  
  CGContextMoveToPoint(context, myCenterX + myBigRadius*myRadius*cos(-M_PI_2 +time), myCenterY + myBigRadius*myRadius*sin(-M_PI_2 +time));
  CGContextAddLineToPoint(context, myCenterX + mySmallRadius*myRadius*cos(-M_PI_2 +time), myCenterY + mySmallRadius*myRadius*sin(-M_PI_2 +time));

  CGContextAddArc(context, myCenterX, myCenterY, mySmallRadius*myRadius, -M_PI_2+time, - M_PI_2 + offset, 1);

  
  CGContextEOClip(context);
  
  
  CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
  
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGGradientRelease(gradient), gradient = NULL;
  
  CGContextRestoreGState(context);
  
  CGContextDrawPath(context, kCGPathStroke);
  
}

-(void)timer:(NSTimer*)timer
{
  //time+=0.01;
  if (time>=2*M_PI) {
    if(type == NLSpinnerTypeTimer)
    {
      centerLabel.text = [NSString stringWithFormat:@"%i",[[centerLabel text] integerValue]-1];
      time=0;
    }
    else
    {
      offset+=0.01;
    }
  }
  else time+=0.01;
  if (offset>=2*M_PI) {
    offset = 0.0;
    time = 0.0;
  }
  [self setNeedsDisplay];
}

-(void)startSpin
{
  timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
}

-(void) stopSpin
{
  [timer invalidate];
}


+(id)staticSpinnerWithProgress:(float)progress valueAtCenter:(int)value colors:(NSArray *)colors frame:(CGRect)frame
{
  NLSpinner* result = [[NLSpinner alloc] initWithFrame:frame type:NLSpinnerTypeProgress colors:colors startValue:value];
  result.time = 2*M_PI*progress;
  //result.centerLabel.text = [@(value) stringValue];
  return result;
}

+ (id)staticSpinnerWithProgress:(float)progress valueAtCenter:(int)value frame:(CGRect)frame
{
  NSArray* newColors = @[@(202.0/255), @(46.0/255), @(120.0/255), @1.0, @(73.0/255), @(177.0/255), @(216.0/255), @1.0];
  return [NLSpinner staticSpinnerWithProgress:progress valueAtCenter:value colors:newColors frame:frame];
}

- (void)changeProgress:(float)progress withValueAtCenter:(int)value
{
  if (estimatedProgress<progress) {
      timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeProgressTimer:) userInfo:nil repeats:YES];
  }
  else
  {
      timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeDecreasingProgressTimer:) userInfo:nil repeats:YES];
  }
  estimatedProgress = progress;
  estimatedValue = value;
}

-(void)changeProgressTimer:(NSTimer*)pTimer
{
  time+=0.01;
  if (time>=estimatedProgress*2*M_PI) {
    time=estimatedProgress*2*M_PI;
    centerLabel.text = [@(estimatedValue) stringValue];
    [pTimer invalidate];
  }
  else
  {
    centerLabel.text = [@(abs(((estimatedValue*1.0)/estimatedProgress) * time/(2*M_PI))) stringValue];
  }
  [self setNeedsDisplay];
}

-(void)changeDecreasingProgressTimer:(NSTimer*)pTimer
{
  time-=0.01;
  if (time<=estimatedProgress*2*M_PI) {
    time=estimatedProgress*2*M_PI;
    centerLabel.text = [@(estimatedValue) stringValue];
    [pTimer invalidate];
  }
  else
  {
  }
  [self setNeedsDisplay];
}



@end
