//
//  NLLabel.m
//  StressIt
//
//  Created by Alexey Goncharov on 10.10.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLLabel.h"

#define kDebug 1
#define kFullDebug 0

#define kMaxFontSize 40
#define kVerticalOffset 180
#define kLabelHeight 50

static NSString *kFontName = @"Cuprum-Regular";

// 80 177 205 - blue
// 66 79 91 - dark blue
// 169 47 72 - red

@implementation NLLabel

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andWord:(NLCD_Word *)word {
  CGSize windowSize = [[[UIApplication sharedApplication]delegate] window].frame.size;
  int width = windowSize.height;
  if (CGRectIsEmpty(frame)) {
    self = [[NLLabel alloc]initWithFrame:CGRectMake(0, kVerticalOffset, width, kLabelHeight)];
  } else {
    self = [[NLLabel alloc]initWithFrame:frame];
  }
  stresssed = [word.stressed intValue];
  self.userInteractionEnabled = YES;
  self.backgroundColor = [UIColor clearColor];
  self.textAlignment = NSTextAlignmentCenter;
  [self changeWordWithWord:word];
  return self;
}

- (id)initWithWord:(NLCD_Word *)word {
  self = [[NLLabel alloc]initWithFrame:CGRectZero andWord:word];
  return self;
}

- (void)changeWordWithWord:(NLCD_Word *)word {
  wordSource = word;
  if (kDebug) NSLog(@"NLLabel_output: new word %@", word);
  [UIView animateWithDuration:0.5 animations:^{
    self.alpha = 0;
  }];
  int stringLength = word.text.length;
  stresssed = [wordSource.stressed intValue];
  NSRange fullRange = NSMakeRange(0, stringLength);
  [self vowelsInWord:word.text];
  float fontSize = [self recommendedFontSizeForWord:word.text];
  pointSize = fontSize;
  NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:word.text];
  CGFloat components[4] = {66.f/255.f, 79.f/255.f, 91.f/255.f, 1};
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGColorRef color = CGColorCreate(colorSpace, components);
  [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)(color) range:fullRange];
  //[mutableAttributedString addAttribute:(NSString *)kCTForegroundColorFromContextAttributeName value:[UIColor colorWithRed:66.f/255.f green:79.f/255.f blue:91.f/255.f alpha:1] range:fullRange];

  CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)kFontName, fontSize, NULL);
  if (font) {
    [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:fullRange];
    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:fullRange];
    CFRelease(font);
  }
  CTTextAlignment theAlignment = kCTCenterTextAlignment;
  CFIndex theNumberOfSettings = 1;
  CTParagraphStyleSetting theSettings[1] = {{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &theAlignment }};
  CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
  [mutableAttributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)theParagraphRef range:fullRange];
  self.text = mutableAttributedString;
  [UIView animateWithDuration:0.5 animations:^{
    self.alpha = 1;
  }];
}

- (NSString *)characterAtIndex:(int)index inString:(NSString *)_string {
  NSRange range;
  range.location = index;
  range.length = 1;
  return [_string substringWithRange:range];
}

- (BOOL)point:(CGPoint)point inRect:(CGRect)rect {
  return (point.x >= rect.origin.x && point.x <= rect.origin.x + rect.size.width) &&  (point.y >= rect.origin.y && point.y <= rect.origin.y + rect.size.height);
}

- (int)touchedLetter:(CGPoint)touchLocation {
  NSString *word = self.text;
  float fontSize = pointSize;
  CGSize wordSize = [word sizeWithFont:[UIFont fontWithName:kFontName size:fontSize]];
  CGRect wordRect;
  NSLog(@"NLLabel_output: label rect %@", [NSValue valueWithCGRect:self.frame]);
  wordRect.size = wordSize;
  wordRect.origin.y = (self.frame.size.height - wordRect.size.height)/2;
  wordRect.origin.x = (self.frame.size.width - wordSize.width)/2;
  
  if (kDebug && kFullDebug) NSLog(@"NLLabel_output: word rect %@", [NSValue valueWithCGRect:wordRect]);
  NSMutableArray *letterRects = [NSMutableArray array];
  for (int i = 0; i < word.length; ++i) {
		NSRange range;
		range.location = i;
		range.length = 1;
    NSString *currentChar = [word substringWithRange:range];
		CGSize currentSize = [currentChar sizeWithFont:[UIFont fontWithName:kFontName size:fontSize]];
    range.location = 0;
    range.length = i+1;
    CGSize bigSize = [[word substringWithRange:range] sizeWithFont:[UIFont fontWithName:kFontName size:fontSize]];
    CGRect rect;
    rect.size = currentSize;
    rect.origin.y = wordRect.origin.y;
    rect.origin.x = wordRect.origin.x + bigSize.width - rect.size.width;
    if (kDebug && kFullDebug) NSLog(@"NLLabel_output: current char %@; rect %@", currentChar, [NSValue valueWithCGRect:rect]);
    [letterRects addObject:[NSValue valueWithCGRect:rect]];
	}
  
  for (int i = 0; i < letterRects.count; ++i) {
    NSValue *currentValue = [letterRects objectAtIndex:i];
    CGRect current = [currentValue CGRectValue];
    if ([self point:touchLocation inRect:current]) {
      return i;
    }
  }
  if (kDebug) NSLog(@"NLLabel_output: touched not in word");
  return -1;
}

- (float)recommendedFontSizeForWord:(NSString *)word {
  CGSize need = [word sizeWithFont:[UIFont fontWithName:kFontName size:kMaxFontSize]];
  CGSize here = self.frame.size;
  if(need.width < here.width) return kMaxFontSize;
  float fontSize = kMaxFontSize;
  while (true) {
    fontSize -= 0.5;
    need = [word sizeWithFont:[UIFont fontWithName:kFontName size:fontSize]];
    if(need.width < here.width) return fontSize;
  }
}

- (void)allLettersDefault {
  [self changeWordWithWord:wordSource];
}

- (void)setColor:(UIColor *)color atIndex:(int)index {
  [UIView animateWithDuration:0.3 animations:^{
    self.alpha = 0;
  } completion:^(BOOL finished) {
    [self setText:@"fake"];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:wordSource.text];
    
    CGFloat components[4] = {66.f/255.f, 79.f/255.f, 91.f/255.f, 1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorN = CGColorCreate(colorSpace, components);
    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)(colorN) range:NSMakeRange(0, index)];
    
    
    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)(color.CGColor) range:NSMakeRange(index, 1)];
    
    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)(colorN) range:NSMakeRange(index + 1, wordSource.text.length - index - 1)];
    
    NSRange fullRange = NSMakeRange(0, wordSource.text.length);
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)kFontName, pointSize, NULL);
    if (font) {
      [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:fullRange];
      [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:fullRange];
      CFRelease(font);
    }
    CTTextAlignment theAlignment = kCTCenterTextAlignment;
    CFIndex theNumberOfSettings = 1;
    CTParagraphStyleSetting theSettings[1] = {{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &theAlignment }};
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
    [mutableAttributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)theParagraphRef range:fullRange];
    [self setText:mutableAttributedString];
    [UIView animateWithDuration:0.3 animations:^{
      self.alpha = 1;
    } completion:^(BOOL finished) {
      
    }];
  }];
 

}

- (void)answeredWithLetter:(int)number {
  if ([self.delegate respondsToSelector:@selector(userTouchedOnLetter:)]) {
    [self.delegate userTouchedOnLetter:[NSNumber numberWithInt:number]];
  }
  NSString *word = self.text;
  if (![self isVovel:[self characterAtIndex:number inString:word]]) return;
  [self allLettersDefault];
  UIColor *newColor;
  if (number == stresssed)
  {
    newColor = [UIColor colorWithRed:80.f/255.f green:177.f/255.f blue:205.f/255.f alpha:1];
    if ([self.delegate respondsToSelector:@selector(userAnsweredWithAnswer:)]) {
      [self.delegate userAnsweredWithAnswer:YES];
    }
  } else {
    newColor = [UIColor colorWithRed:169.f/255.f green:47.f/255.f blue:72.f/255.f alpha:1];
    if ([self.delegate respondsToSelector:@selector(userAnsweredWithAnswer:)]) {
      [self.delegate userAnsweredWithAnswer:NO];
    }
  } 
  [self setColor:newColor atIndex:number];
}

- (BOOL)isVovel: (NSString*) letter {
	NSArray* letters = @[@"а", @"е", @"ё", @"и", @"о", @"у", @"ы",@"э",@"ю",@"я", @"А", @"Е",@"Ё", @"И", @"О", @"У", @"Ы", @"Э", @"Ю", @"Я"];
	for (int i = 0; i < letters.count; ++i) {
		if ([letter isEqualToString:[letters objectAtIndex:i]]) {
			return YES;
		}
	}
	return NO;
}

- (void)vowelsInWord:(NSString *)word {
  NSMutableArray *vowelsNumbers = [NSMutableArray array];
  for (int i = 0; i < word.length; ++i) {
		NSRange range;
		range.location = i;
		range.length = 1;
		if ([self isVovel: [word substringWithRange:range]]) {
			[vowelsNumbers addObject:[[NSNumber alloc] initWithInt:i]];
		}
	}
  vowelLetters = [NSArray arrayWithArray:vowelsNumbers];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  if (touch.view != self) return;
  CGPoint location = [touch locationInView:self];
  if (kDebug) NSLog(@"NLLabel_output: touched on %@", [NSValue valueWithCGPoint:location]);
  
  int letter = [self touchedLetter:location];
  [self answeredWithLetter:letter];
    
}



@end
