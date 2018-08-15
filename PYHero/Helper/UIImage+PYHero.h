//
//  UIImage+PYHero.h
//  PYHero
//
//  Created by Bob Lee on 2018/4/3.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PYHero)

typedef NS_OPTIONS(NSInteger, PYImageRadius) {
    EImageRadiusTopLeft = 1,
    EImageRadiusTopRight = 1 << 1,
    EImageRadiusBottomRight = 1 << 2,
    EImageRadiusBottomLeft = 1 << 3
} ;

/**
 * @brief 将已有图标添加圆角效果,并可制定圆角位置
 * @param image 原始图片
 * @param frame 图片要放入的容器控件的frame
 * @param corner 相对容器控件的 圆角大小
 * @param cornerMask 圆角位置
 * @return UIImage with corner
 */
+ (UIImage *)getCornerImageFromImage:(UIImage *)image containerFrame:(CGRect)frame withRadious:(CGFloat)corner cornerMask:(PYImageRadius)cornerMask;

/**
 * @brief 将已有图标添加圆角效果，默认四个角都处理
 * @param image 原始图片
 * @param frame 图片要放入的容器控件的frame
 * @param corner 相对容器控件的 圆角大小
 * @return UIImage with corner
 */
+ (UIImage *)getCornerImageFromImage:(UIImage *)image containerFrame:(CGRect)frame withRadious:(CGFloat)corner;

/**
 * @brief 合并两个图片，默认居中
 * @param firstImage 第一张也就是底层的那张
 * @param secondImage  第二张
 * @return UIImage merged
 */
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/**
 * @brief 合并两个图片
 * @param firstImage 第一张也就是底层的那张
 * @param secondImage 第二张
 * @param offset 第二张相对下层的偏移值
 * @return UIImage merged
 */
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage offset:(CGPoint)offset;

+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage sizeFirst:(CGSize)sizeFirst sizeSec:(CGSize)sizeSec;

/**
 * @brief 合并两个图片，可控制压缩图片大小
 * @param firstImage 第一张也就是底层的那张
 * @param secondImage 第二张
 * @param offset 第二张相对下层的偏移值
 * @param sizeFirst 底部图片大小，默认图片自身大小
 * @param sizeSec 上层图片大小，默认图片自身大小
 * @return UIImage merged
 */
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage offset:(CGPoint)offset sizeFirst:(CGSize)sizeFirst sizeSec:(CGSize)sizeSec;

/**
 * @brief 适配图片大小，进行压缩，如果图片比当前size小，将会放大，请参考使用
 * @param size 目标大小
 * @return new UIImage 
 */
+ (UIImage *)adaptToSize:(UIImage*)image size:(CGSize)size;

@end
