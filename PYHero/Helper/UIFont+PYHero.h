//
//  UIFont+PYHero.h
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFont_Normal    [UIFont fontNormal:12]     ///< 普通文本描述大小：12
#define kFont_Small     [UIFont fontNormal:10]     ///< 备注、辅助信息：10
#define kFont_Large     [UIFont fontNormal:14]     ///< 列表标题：14
#define kFont_XL        [UIFont fontNormal:16]     ///< 导航栏默认标题：16
#define kFont_XXL       [UIFont fontNormal:17]     ///< 导航栏选中：17

@interface UIFont (PYHero)

/**
 * 字体：加粗
 */
+ (UIFont*)fontBold:(CGFloat)fontSize;

/**
 * 字体：普通样式
 */
+ (UIFont*)fontNormal:(CGFloat)fontSize;
- (CGFloat)lineHeightUsed;


@end
