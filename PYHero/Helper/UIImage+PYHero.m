//
//  UIImage+PYHero.m
//  PYHero
//
//  Created by Bob Lee on 2018/4/3.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "UIImage+PYHero.h"

@implementation UIImage (PYHero)


+ (UIImage *)getCornerImageFromImage:(UIImage *)image containerFrame:(CGRect)frame withRadious:(CGFloat)corner {
    return [self getCornerImageFromImage:image containerFrame:frame withRadious:corner cornerMask:EImageRadiusTopRight|EImageRadiusTopLeft|EImageRadiusBottomRight|EImageRadiusBottomLeft];
}

+ (UIImage *)getCornerImageFromImage:(UIImage *)image containerFrame:(CGRect)frame withRadious:(CGFloat)corner cornerMask:(PYImageRadius)cornerMask {
    if(corner == 0.0f)
        return image;
    
    if(image != nil) {
        @autoreleasepool {
            CGFloat imageWidth = image.size.width;
            CGFloat imageHeight = image.size.height;
            
            
            const CGFloat scale = [UIScreen mainScreen].scale;
            
            
            CGFloat imageAspectRatio = imageWidth/imageHeight;
            CGFloat containerAspectRatio = frame.size.width/frame.size.height;
            
            if (imageAspectRatio == containerAspectRatio)
            {
            }
            else
            {
                if (imageAspectRatio > containerAspectRatio)
                {
                    imageWidth = imageHeight*containerAspectRatio;
                }
                else if (imageAspectRatio<containerAspectRatio)
                {
                    imageHeight = imageWidth/containerAspectRatio;
                }
                
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, scale);
                
                [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            
            CGRect rect = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
            
            corner = corner*imageHeight/frame.size.height;
            
            
            
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextBeginPath(context);
            CGContextSaveGState(context);
            CGContextTranslateCTM (context, 0, 0);
            CGContextScaleCTM (context, scale, scale);
            
            CGFloat rectWidth = CGRectGetWidth (rect)/scale;
            CGFloat rectHeight = CGRectGetHeight (rect)/scale;
            
            corner = corner/scale;
            
            
            CGContextMoveToPoint(context, 0.0f, rectHeight/2.0f);
            //左上圆角
            if (cornerMask&EImageRadiusTopLeft)
            {
                CGContextAddArcToPoint(context, 0.0f, 0.0f, rectWidth/2.0f, 0.0f, corner);
            }
            else
            {
                CGContextAddLineToPoint(context, 0.0f, 0.0f);
                CGContextAddLineToPoint(context, rectWidth/2.0f, 0.0f);
            }
            //右上圆角
            if (cornerMask&EImageRadiusTopRight)
            {
                CGContextAddArcToPoint(context, rectWidth, 0.0f, rectWidth, rectHeight/2.0f, corner);
            }
            else
            {
                CGContextAddLineToPoint(context, rectWidth, 0.0f);
                CGContextAddLineToPoint(context, rectWidth, rectHeight/2.0f);
            }
            //右下圆角
            if (cornerMask&EImageRadiusBottomRight)
            {
                CGContextAddArcToPoint(context, rectWidth, rectHeight, rectWidth/2.0f, rectHeight, corner);
            }
            else
            {
                CGContextAddLineToPoint(context, rectWidth, rectHeight);
                CGContextAddLineToPoint(context, rectWidth/2.0f, rectHeight);
            }
            //左下圆角
            if (cornerMask&EImageRadiusBottomLeft)
            {
                CGContextAddArcToPoint(context, 0, rectHeight, 0, rectHeight/2.0f, corner);
            }
            else
            {
                CGContextAddLineToPoint(context, 0, rectHeight);
                CGContextAddLineToPoint(context, 0, rectHeight/2.0f);
            }
            
            
            CGContextRestoreGState(context);
            CGContextClosePath(context);
            CGContextClip(context);
            
            [image drawInRect:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return newImage;
        }
    }
    
    return nil;
}

+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    CGSize size = firstImage.size;
    CGSize size2 = secondImage.size;
    return [self mergeImage:firstImage withImage:secondImage offset:CGPointMake((size.width-size2.width)/2, (size.height-size2.height)/2)];
}

+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage offset:(CGPoint)offset{
    return [self mergeImage:firstImage withImage:secondImage offset:offset sizeFirst:CGSizeZero sizeSec:CGSizeZero];
}

+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage sizeFirst:(CGSize)sizeFirst sizeSec:(CGSize)sizeSec {
    CGSize size = firstImage.size;
    CGSize size2 = secondImage.size;
    return [self mergeImage:firstImage withImage:secondImage offset:CGPointMake((size.width-size2.width)/2, (size.height-size2.height)/2) sizeFirst:sizeFirst sizeSec:sizeSec];
}

+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage offset:(CGPoint)offset sizeFirst:(CGSize)sizeFirst sizeSec:(CGSize)sizeSec {
    @autoreleasepool {
        if(CGSizeEqualToSize(sizeFirst, CGSizeZero))
            sizeFirst = firstImage.size;
        
        if(CGSizeEqualToSize(sizeSec, CGSizeZero))
            sizeSec = secondImage.size;
        
        // 转换成像素大小
        sizeFirst = CGSizeMake(sizeFirst.width*[UIScreen mainScreen].scale, sizeFirst.height*[UIScreen mainScreen].scale);
        sizeSec = CGSizeMake(sizeSec.width*[UIScreen mainScreen].scale, sizeSec.height*[UIScreen mainScreen].scale);
        
        //    CGImageRef firstImageRef = firstImage.CGImage;
        //    CGImageRef secondImageRef = secondImage.CGImage;
        CGSize mergedSize = CGSizeMake(MAX(sizeFirst.width, sizeSec.width), MAX(sizeFirst.height, sizeSec.height));
        UIGraphicsBeginImageContext(mergedSize);
        // 第一个位置不变
        [firstImage drawInRect:CGRectMake(0, 0, sizeFirst.width, sizeFirst.height)];
        
        // 第二个判断偏移量
        [secondImage drawInRect:CGRectMake(offset.x*([UIScreen mainScreen].scale), offset.y*([UIScreen mainScreen].scale), sizeSec.width, sizeSec.height)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

+ (UIImage *)adaptToSize:(UIImage*)image size:(CGSize)size {
    //获取屏幕的像素密度
    CGFloat scale = [[UIScreen mainScreen] scale];
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
