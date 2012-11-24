//
//  NLTimer.m
//  StressIt
//
//  Created by Nikita Popov on 20.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLTimer.h"

@implementation NLTimer
@synthesize time, cleanNeeded;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      time = 0;
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timer:) userInfo:nil repeats:YES];//timerWithTimeInterval:0.5 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
      [self setBackgroundColor:[UIColor clearColor]];
      UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timerTop"]];
      [image setCenter:CGPointMake(frame.size.width/2, frame.size.width/2)];
      [self addSubview:image];
      image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timerUnder"]];
      [image setCenter:CGPointMake(frame.size.width/2, frame.size.width/2)];
      [self addSubview:image];
      cleanNeeded = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    // Drawing code
//  CGContextRef contextRef = UIGraphicsGetCurrentContext();
//  
//  
//  CGContextSetRGBFillColor(contextRef, 0, 0, 255, 0.1);
//  CGContextSetRGBStrokeColor(contextRef, 0, 0, 255, 0.5);
//  
//  // Draw a circle (filled)
//  CGContextFillEllipseInRect(contextRef, CGRectMake(0, 0, 25, 25));
//  
//  // Draw a circle (border only)
//  CGContextStrokeEllipseInRect(contextRef, CGRectMake(0, 25, 25, 25));
//  
//  // Get the graphics context and clear it
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect te = self.bounds;
  if(cleanNeeded) CGContextClearRect(ctx, te);
  cleanNeeded = NO;
  
  // Draw a green solid circle
  for (int i=0; i<500; ++i) {
    double k = i/500.0;
    CGFloat r = (1+sin(time*k))/2;
    CGFloat g = (1+cos(time*k))/2;
    CGFloat b = 0;
    r = 202 - (M_PI - fabs(time*k - M_PI))*(202-73)/M_PI;
    g = 46 - (M_PI - fabs(time*k - M_PI))*(46-177)/M_PI;
    b = 120 - (M_PI - fabs(time*k - M_PI))*(120-216)/M_PI;
    //CGContextSetRGBFillColor(ctx, 0, 0, 0, 0);
    CGContextSetRGBFillColor(ctx, r/255, g/255, b/255, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(123 - 25 + 70*sin(time*k), 123 - 25 - 70*cos(time*k), 50, 50));
  }
  
  //CGContextFillEllipseInRect(ctx, CGRectMake(time, 50, 25, 25));
//  
//  // Draw a yellow hollow rectangle
//  CGContextSetRGBStrokeColor(ctx, 255, 255, 0, 1);
//  CGContextStrokeRect(ctx, CGRectMake(0, 0, 25, 25));
//  
//  // Draw a purple triangle with using lines
//  CGContextSetRGBStrokeColor(ctx, 255, 0, 255, 1);
//  CGPoint points[6] = { CGPointMake(100, 200), CGPointMake(150, 250),
//    CGPointMake(150, 250), CGPointMake(50, 250),
//    CGPointMake(50, 250), CGPointMake(100, 200) };
//  CGContextStrokeLineSegments(ctx, points, 6);
}

-(void)timer:(NSTimer*)timer
{
  //UIGraphicsBeginImageContext(self.bounds.size);
  time+=0.01;
  if (time>=2*M_PI) {
    time=0;
    cleanNeeded = YES;
  }
  [self setNeedsDisplay];
  //UIGraphicsEndImageContext();
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}


@end
