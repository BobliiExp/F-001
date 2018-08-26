//
//  NSString+PY.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/26.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "NSString+PY.h"

@implementation NSString (PY)

- (CGFloat)getStringWidth:(CGFloat)height attributes:(NSDictionary<NSString *, id> *)attribute
{
    if (!(self.length > 0)) {
        return 0.0;
    }
    CGSize textSize = CGSizeZero;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX , height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attribute
                                        context:nil].size;
    } else {
        textSize = [self sizeWithFont:attribute[NSFontAttributeName]
                      constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    return textSize.width;
}

@end
