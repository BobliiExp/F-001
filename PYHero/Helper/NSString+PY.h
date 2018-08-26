//
//  NSString+PY.h
//  PYHero
//
//  Created by Bob Lee on 2018/8/26.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PY)

- (CGFloat)getStringWidth:(CGFloat)height attributes:(NSDictionary<NSString *, id> *)attribute;

@end

NS_ASSUME_NONNULL_END
