//
//  PYNumber.h
//  PYHero
//
//  Created by crow on 2018/8/16.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYNumber : NSObject

+ (NSArray *)py_getUnionLottoNumbers; // 获取双色球数据，数组中包含的字符串
+ (NSArray *)py_getLecaGreatiNumbers; // 获取双色球数据，数组中包含的字符串
+ (NSArray *)py_getSuperLottoNumbers; // 获取双色球数据，数组中包含的字符串

+ (NSInteger)py_getLottoLastZoneIndex:(PYLotteryType)type; // 获取彩票后区的位置

@end
