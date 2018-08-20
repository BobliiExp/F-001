//
//  PYNumber.m
//  PYHero
//
//  Created by crow on 2018/8/16.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYNumber.h"

@implementation PYNumber

+ (NSArray *)py_getUnionLottoNumbers {
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSInteger i = 0; i<7; i++) {
        NSString *number = [self py_getRandomNumber:(i == 6 ? 16 : 33) zero:NO];
        
        // 判断是否有相同的数字
        BOOL isSame = NO;
        for (NSString *num in mArr) {
            if ([number isEqualToString:num]) {
                isSame = YES;
                break;
            }
        }
        
        // 不相同就添加；相同i减一，重新获取一个随机数
        if (!isSame) {
            [mArr addObject:number];
        }else {
            i--;
        }
    }
    
    return mArr;
}

+ (NSArray *)py_getLecaGreatiNumbers {
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSInteger i = 0; i<8; i++) {
        NSString *number = [self py_getRandomNumber:30 zero:NO];
        
        // 判断是否有相同的数字
        BOOL isSame = NO;
        for (NSString *num in mArr) {
            if ([number isEqualToString:num]) {
                isSame = YES;
                break;
            }
        }
        
        // 不相同就添加；相同i减一，重新获取一个随机数
        if (!isSame) {
            [mArr addObject:number];
        }else {
            i--;
        }
    }
    
    return mArr;
}

+ (NSArray *)py_getSuperLottoNumbers {
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSInteger i = 0; i<7; i++) {
        NSString *number = [self py_getRandomNumber:(i == 5 ? 35 : 12) zero:NO];
        
        // 判断是否有相同的数字
        BOOL isSame = NO;
        for (NSString *num in mArr) {
            if ([number isEqualToString:num]) {
                isSame = YES;
                break;
            }
        }
        
        // 不相同就添加；相同i减一，重新获取一个随机数
        if (!isSame) {
            [mArr addObject:number];
        }else {
            i--;
        }
    }
    
    return mArr;
}

// max-最大的数字，zero-是否可以为0
+ (NSString *)py_getRandomNumber:(NSInteger)max zero:(BOOL)zero{
    int number = 0;
    if (zero) {
        number = arc4random()%(max+1);
    }else {
        do {
            number = arc4random()%(max+1);
        } while (!number);
    }
    
    return [NSString stringWithFormat:@"%d",number];
}

+ (NSInteger)py_getLottoLastZoneIndex:(PYLotteryType)type {
    NSInteger index = 0;
    if (type == PYLotteryTypeLecaGreati) {
        index = 7;
    }else if (type == PYLotteryTypeSuperLotto) {
        index = 5;
    }else {
        index = 6;
    }
    
    return index;
}

@end
