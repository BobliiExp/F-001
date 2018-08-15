//
//  UIColor+PYHero.h
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kColor_Normal           [UIColor colorWithARGBString:@"#333333"]    ///< 默认颜色：黑色
#define kColor_HighLight        [UIColor colorWithARGBString:@"#b17834"]    ///< 高亮颜色：咖啡色
#define kColor_Gray             [UIColor colorWithARGBString:@"#666666"]    ///< 灰色
#define kColor_Graylight        [UIColor colorWithARGBString:@"#eeeeee"]    ///< 浅灰色
#define kColor_Blue             [UIColor colorWithARGBString:@"#255cad"]    ///< 蓝色色
#define kColor_Red              [UIColor colorWithARGBString:@"#ca3f33"]    ///< 红色

@interface UIColor (PYHero)

+ (UIColor *)colorWithARGBString:(NSString *)stringToConvert alpha:(CGFloat)alpha;
+ (UIColor *)colorWithARGBString:(NSString *)stringToConvert;
+ (NSString*)colorToString:(UIColor*)color;

@end
