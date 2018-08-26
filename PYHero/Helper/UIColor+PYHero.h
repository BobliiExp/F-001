//
//  UIColor+PYHero.h
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PYHero)

+ (UIColor *)colorWithARGBString:(NSString *)stringToConvert alpha:(CGFloat)alpha;
+ (UIColor *)colorWithARGBString:(NSString *)stringToConvert;
+ (NSString*)colorToString:(UIColor*)color;

@end
