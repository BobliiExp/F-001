//
//  UIImage+Color.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIColor *)colorAtPoint:(CGPoint )point
{
    if (point.x < 0 || point.y < 0) return nil;
    
    CGImageRef imageRef = self.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    if (point.x >= width || point.y >= height) return nil;
    
    unsigned char *rawData = malloc(height * width * 4);
    if (!rawData) return nil;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast
                                                 | kCGBitmapByteOrder32Big);
    if (!context) {
        free(rawData);
        return nil;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *result = nil;
    result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return result;
}

- (UIColor *)colorAtPixel:(CGPoint)point
{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (BOOL)hasAlphaChannel
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

//转成黑白图像
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

+ (UIImage *)imageWithColorString:(NSString *)colorString frame:(CGRect)frame
{
    return [self imageWithColor:[UIColor colorWithARGBString:colorString] frame:frame];
}

+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame{
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageFromColors:(NSArray*)colors locations:(CGFloat[])locations gradientType:(GradientType)gradientType size:(CGSize)size {
    if(colors==nil || colors.count==0)
        return nil;
    
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:10];
    
    NSMutableArray *mArrColor = nil;
    if([[colors firstObject] isKindOfClass:[NSString class]]){
        mArrColor = [NSMutableArray array];
        for(NSString *cols in colors){
            [mArrColor addObject:[UIColor colorWithARGBString:cols]];
        }
    }else{
        mArrColor = [NSMutableArray arrayWithArray:colors];
    }
    
    for(UIColor *c in mArrColor) {
        [ar addObject:(id)c.CGColor];
    }
    
    CGFloat width = size.width, height = size.height;
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[mArrColor lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start=CGPointMake(0.0, 0.0);;
    CGPoint end=CGPointMake(0.0, height);;
    switch ((int)gradientType) {
        case EGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, height);
            break;
        case EGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(width, 0.0);
            break;
        case EGradientTypeUpleftTolowRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(width, height);
            break;
        case EGradientTypeUprightTolowLeft:
            start = CGPointMake(width, 0.0);
            end = CGPointMake(0.0, height);
            break;
        case EGradientTypeBottomToTop:
            start = CGPointMake(0.0, height);
            end = CGPointMake(0.0, 0.0);
            break;
        case EGradientTypeRightToLeft:
            start = CGPointMake(width, 0.0);
            end = CGPointMake(0.0, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    //    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType size:(CGSize)size
{
    return [self imageFromColors:colors locations:NULL gradientType:gradientType size:size];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)imageAddShape:(EShapeType)shape
             withShapeSize:(CGSize)size
              shapeBgColor:(UIColor *)bgColor
                shapeColor:(UIColor *)color
                atLocation:(EShapeLocation)location
                autoRaduis:(BOOL)raduis
{
    
    UIImage *raduisImg = nil;
    CGFloat r = (self.size.width > self.size.height ? self.size.height : self.size.width)/2.;
   
    //生成指定形状的图片
    UIImage *shapeImg = [UIImage imageWithShape:shape size:size shapeBgColor:bgColor shapeColor:color lineWidth:3. linePadding:2 raduis:size.width/2 edgeWidth:2 isDashed:YES];
    shapeImg = [self imageWithRoundedCornersSize:size.width/2];
    
    //整合
    CGPoint point = CGPointZero;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    if (raduis) {
        raduisImg = [self imageWithRoundedCornersSize:r];
        [raduisImg drawAtPoint:point];
    } else {
        [self drawAtPoint:point];
    }
    
    //添加到指定位置
    if (location & EShapeLocationBottomLeft) {
        point = CGPointMake(self.size.width/2 - r * cos(M_PI_4) - size.width/2., self.size.height/2 + r * sin(M_PI_4) - size.height/2.);
        [shapeImg drawAtPoint:point];
    }
    if (location & EShapeLocationBottomRight) {
        point = CGPointMake(self.size.width/2 + r * cos(M_PI_4) - size.width/2., self.size.height/2 + r * sin(M_PI_4) - size.height/2.);
        [shapeImg drawAtPoint:point];
    }
    if (location & EShapeLocationTopLeft) {
        point = CGPointMake(self.size.width/2 - r * cos(M_PI_4) - size.width/2., self.size.height/2 - r * sin(M_PI_4) - size.height/2.);
        [shapeImg drawAtPoint:point];
    }
    if (location & EShapeLocationTopRight) {
        point = CGPointMake(self.size.width/2 + r * cos(M_PI_4) - size.width/2., self.size.height/2 - r * sin(M_PI_4) - size.height/2.);
        [shapeImg drawAtPoint:point];
    }
    if (location & EShapeLocationCenter) {
        point = CGPointMake(self.size.width/2. - size.width/2., self.size.height/2. - size.height/2.);
        [shapeImg drawAtPoint:point];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  制作圆角图片
 *
 *  @param cornerRadius 圆角大小
 *  @param original     原始图片
 *
 *  @return 带圆角的图片
 */
- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius
{
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // Draw your image
    [self drawInRect:frame];
    // Retrieve and return the new image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithShape:(EShapeType)shape
                       size:(CGSize)size
                   isCircle:(BOOL)isCircle
                   isDashed:(BOOL)isDashed {
    
    return [self imageWithShape:shape size:size shapeBgColor:[UIColor clearColor] shapeColor:kColor_Graylight lineWidth:1.5 linePadding:size.width/5 raduis:isCircle?size.height/2:0 edgeWidth:1.0 isDashed:isDashed];
}

+ (UIImage *)imageWithShape:(EShapeType)shape
                       size:(CGSize)size
               shapeBgColor:(UIColor *)bgColor
                 shapeColor:(UIColor *)color
                  lineWidth:(CGFloat)lineWidth
                linePadding:(CGFloat)paddingWidth
                     raduis:(CGFloat)raduis
                  edgeWidth:(CGFloat)edgeWidth
                   isDashed:(BOOL)isDashed
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //设置填充
    [bgColor setFill];
    
    //画图片框架
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(edgeWidth, edgeWidth, size.width-2*edgeWidth, size.height-2*edgeWidth) cornerRadius:raduis];
    
    [path fill];
    
    if (isDashed || edgeWidth > 0) {//画边框虚线
        
        [kColor_Graylight setStroke];
        
        UIBezierPath *dashPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(edgeWidth/2, edgeWidth/2, size.width-edgeWidth, size.height-edgeWidth) cornerRadius:raduis];
        
        if (isDashed) {//设置虚线
            CGFloat dash[] = {5.,2.,5.,2.};
            [dashPath setLineDash:dash count:4 phase:0];
        }
        
        if (edgeWidth > 0.) {//设置边框
            [kColor_Graylight setStroke];
            dashPath.lineWidth = edgeWidth;
            [dashPath stroke];
        }
        
    }
    
    
    [color setStroke];
    //画图形
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    path1.lineWidth = lineWidth;
    [path1 moveToPoint:CGPointMake(edgeWidth + paddingWidth, size.height/2)];
    [path1 addLineToPoint:CGPointMake(size.width-edgeWidth-paddingWidth, size.height/2)];
    [path1 stroke];
    
    if (shape == EShapeTypeAdd) {
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        path2.lineWidth = lineWidth;
        [path2 moveToPoint:CGPointMake(size.width/2., paddingWidth+edgeWidth)];
        [path2 addLineToPoint:CGPointMake(size.width/2., size.height - paddingWidth - edgeWidth)];
        [path2 stroke];
    }
   
    
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
