//
//  UIFont+PYHero.m
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "UIFont+PYHero.h"

@implementation UIFont (PYHero)

+ (UIFont*)fontBold:(CGFloat)fontSize {
    //    return [UIFont fontWithName:kFontType_Heiti_s size:fontSize];
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont*)fontNormal:(CGFloat)fontSize {
    //    return [UIFont fontWithName:kFontType_Heiti_m size:fontSize];
    return [UIFont systemFontOfSize:fontSize];
}

- (CGFloat)lineHeightUsed {
    return IOS_VERSION>=9.0 ? (self.pointSize+4) : (self.lineHeight + 2); // 平均增加2个
}

@end
