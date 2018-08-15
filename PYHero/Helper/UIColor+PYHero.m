//
//  UIColor+PYHero.m
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "UIColor+PYHero.h"

#define DEFAULT_VOID_COLOR [UIColor clearColor]

@implementation UIColor (PYHero)

+ (UIColor *)colorWithARGBString:(NSString *)stringToConvert alpha:(CGFloat)alpha {
    if(stringToConvert==nil || stringToConvert.length==0)
        return DEFAULT_VOID_COLOR;
    
    stringToConvert = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    
    //例子，stringToConvert #ffffff
    if ([stringToConvert length] < 6){
        return DEFAULT_VOID_COLOR;//如果非十六进制，返回白色
    }
    if ([stringToConvert hasPrefix:@"#"])
        stringToConvert = [stringToConvert substringFromIndex:1];//去掉头
    if ([stringToConvert length] != 6)//去头非十六进制，返回白色
        return DEFAULT_VOID_COLOR;
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithARGBString:(NSString *)stringToConvert {
    return [UIColor colorWithARGBString:stringToConvert alpha:1.0];
}

+ (NSString*)colorToString:(UIColor*)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    int red = (int)(components[0] * 255);
    int green = (int)(components[1] * 255);
    int blue = (int)(components[2] * 255);
    //    int alpha = (int)(components[3] * 255);
    return [NSString stringWithFormat:@"#%0.2X%0.2X%0.2X", red, green, blue];
}

@end
