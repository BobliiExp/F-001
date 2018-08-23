//
//  UIImage+Color.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

typedef NS_ENUM(int,EShapeType){
    EShapeTypeAdd   =   0,
    EShapeTypeMinus =   1,
};

typedef NS_ENUM(int,EShapeLocation){
    EShapeLocationTopLeft       =   1   <<  0,  //左上角
    EShapeLocationTopRight      =   1   <<  1,  //右上角
    EShapeLocationBottomLeft    =   1   <<  2,  //左下角
    EShapeLocationBottomRight   =   1   <<  3,  //右下角
    EShapeLocationCenter        =   1   <<  4,  //中心
};

/**
 * GradientType
 * 渐变填充方式
 */
typedef NS_ENUM(char, GradientType)  {
    EGradientTypeTopToBottom = 0,//从上到小
    EGradientTypeLeftToRight = 1,//从左到右
    EGradientTypeBottomToTop = 4,
    EGradientTypeRightToLeft = 5,
    
    EGradientTypeUpleftTolowRight = 2,//左上到右下
    EGradientTypeUprightTolowLeft = 3,//右上到左下
} ;

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIColor *)colorAtPoint:(CGPoint )point;
///< more accurate method ,colorAtPixel 1x1 pixel
- (UIColor *)colorAtPixel:(CGPoint)point;
///< 返回该图片是否有透明度通道
- (BOOL)hasAlphaChannel;

///< 获得灰度图
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;

+ (UIImage *)imageWithColorString:(NSString *)colorString frame:(CGRect)frame;

+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame;

/**
 获得渐变效果的图片
 * @param colors 颜色数组(UIColor\ColorString)
 * @param locations 色值范围{0.1，0.5，1.0}
 * @param 填充方式
 * @param  size 填充区域
 
 * @return 填充后的图片
 */
+ (UIImage *)imageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType size:(CGSize)size;
+ (UIImage *)imageFromColors:(NSArray*)colors locations:(CGFloat[])locations gradientType:(GradientType)gradientType size:(CGSize)size;
/**
 * 重置图片内容颜色
 */
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

/**
 * 重置图片内容颜色（中间向外有放射效果）
 */
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

/**
 * 重置图片内容颜色，自己设置效果
 */
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

/**
 *  为图片在指定位置添加指定的形状
 *
 *  @param shape    形状
 *  @param size     形状大小
 *  @param bgColor  形状背景色
 *  @param color    形状自身颜色
 *  @param location 添加形状位置
 *  @param raduis   是否自动圆角处理
 *
 *  @return 添加形状后的图片
 */
- (UIImage *) imageAddShape:(EShapeType)shape
              withShapeSize:(CGSize)size
               shapeBgColor:(UIColor *)bgColor
                 shapeColor:(UIColor *)color
                 atLocation:(EShapeLocation)location
                 autoRaduis:(BOOL)raduis;

/**
 *  制作圆角图片
 *
 *  @param cornerRadius 圆角大小
 *
 *  @return 带圆角的图片
 */
- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius;

/**
 *  画指定图形的图片
 *
 *  @param shape     指定图形
 *  @param size      生成的图片大小
 *  @param bgColor   图片背景色
 *  @param color     图形颜色
 *  @param lineWidth 图形线条粗细
 *  @param paddingWidth 图形边距
 *  @param raduis    圆角大小
 *  @param edgeWidth 边框宽度, =0时无边框
 *  @param isDashed  是否虚线边框
 *
 *  @return 带指定图形的图片
 */
+ (UIImage *)imageWithShape:(EShapeType)shape
                       size:(CGSize)size
               shapeBgColor:(UIColor *)bgColor
                 shapeColor:(UIColor *)color
                  lineWidth:(CGFloat)lineWidth
                linePadding:(CGFloat)paddingWidth
                     raduis:(CGFloat)raduis
                  edgeWidth:(CGFloat)edgeWidth
                   isDashed:(BOOL)isDashed;
/**
 *  群成员、发起聊天、创建群组等直接用
    画指定图形的图片：加或减，通用默认风格，有边框，背景透明
 *
 *  @param shape     指定图形，加或减
 *  @param size      生成的图片大小
 *  @param isCircle  边框圆形还是方形
 *  @param isDashed  是否虚线边框
 *
 *  @return 带指定图形的图片
 */
+ (UIImage *)imageWithShape:(EShapeType)shape
                       size:(CGSize)size
                   isCircle:(BOOL)isCircle
                   isDashed:(BOOL)isDashed;


@end
