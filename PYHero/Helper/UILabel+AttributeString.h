//
//  UILabel+AttributeString.h
//  PYHero
//
//  Created by crow on 2018/8/28.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYModelAttr : NSObject

@property (nonatomic, strong) NSArray<NSString *> *arrText;                 ///< 字符串数组
@property (nonatomic, strong) NSArray<UIColor *> *arrFgColor;               ///< 字体颜色
@property (nonatomic, strong) NSArray<UIFont *> *arrFont;                   ///< 字体大小

- (BOOL)isAvailable;  ///< 模型是否符合使用规范，（几个数组的元素数必须相同）

@end

@interface UILabel (AttributeString)

- (void)setAttributedTextWithModel:(PYModelAttr *)model;

@end
