//
//  NSString+PY.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/26.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "NSString+PY.h"

@implementation NSString (PY)

- (CGFloat)getStringWidth:(CGFloat)height attributes:(NSDictionary<NSString *, id> *)attribute {
    return [self getStringSize:CGSizeMake(CGFLOAT_MAX, height) attributes:attribute].width;
}

- (CGFloat)getStringHeight:(CGFloat)width attributes:(NSDictionary<NSString *, id> *)attribute {
    return [self getStringSize:CGSizeMake(width, CGFLOAT_MAX) attributes:attribute].height;
}

- (CGSize)getStringSize:(CGSize)size attributes:(NSDictionary<NSString *, id> *)attribute
{
    if (!(self.length > 0)) {
        return CGSizeZero;
    }
    
    CGSize textSize = CGSizeZero;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        textSize = [self boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attribute
                                        context:nil].size;
    } else {
        textSize = [self sizeWithFont:attribute[NSFontAttributeName]
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    return textSize;
}

@end
