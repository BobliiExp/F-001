//
//  PYWinManage.m
//  PYHero
//
//  Created by crow on 2018/8/17.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYWinManage.h"

@implementation PYWinManage

+ (PYWinResultType)py_winResult:(PYLotteryType)type winArr:(NSArray *)winArr userArr:(NSArray *)userArr {
    PYWinResultType winType = 0;
    
    // 确定前区号码个数
    NSInteger index = userArr.count;
    if (type == PYLotteryTypeLecaGreati) {
        index = userArr.count-1;
    }else if (type == PYLotteryTypeSuperLotto) {
        index = userArr.count-2;
    }else {
        index = userArr.count-1;
    }
    
    NSInteger firstCount = 0;
    NSInteger lastCount = 0;
    
    // 将号码按照前区后区分开
    NSMutableArray *mArrFirst = [NSMutableArray array];
    NSMutableArray *mArrLast = [NSMutableArray array];
    for (NSInteger i = 0; i < winArr.count; i++) {
        NSString *number = winArr[i];
        if (i < index) {
            [mArrFirst addObject:number];
        }else {
            [mArrLast addObject:number];
        }
    }
    
    // 判断相同个数
    for (NSInteger i = 0; i < userArr.count; i++) {
        NSString *number = userArr[i];
        if (i < index) {
            if ([mArrFirst containsObject:number]) {
                firstCount++;
            }
        }else {
            if ([mArrLast containsObject:number]) {
                lastCount++;
            }
        }
    }
    
    // 按照type判断
    if (type == PYLotteryTypeLecaGreati) {
        if (firstCount == 7) {
            winType = PYWinResultTypeOne;
        }else if (firstCount == 6 && lastCount == 1) {
            winType = PYWinResultTypeTwo;
        }else if (firstCount == 6) {
            winType = PYWinResultTypeThree;
        }else if (firstCount == 5 && lastCount == 1) {
            winType = PYWinResultTypeFour;
        }else if (firstCount == 5) {
            winType = PYWinResultTypefive;
        }else if (firstCount == 4 && lastCount == 1) {
            winType = PYWinResultTypeSix;
        }else if (firstCount == 4) {
            winType = PYWinResultTypeSeven;
        }
    }else if (type == PYLotteryTypeSuperLotto) {
        if (firstCount == 5 && lastCount == 2) {
            winType = PYWinResultTypeOne;
        }else if (firstCount == 5 && lastCount == 1) {
            winType = PYWinResultTypeTwo;
        }else if (firstCount == 5 || (firstCount == 4 && lastCount == 2)) {
            winType = PYWinResultTypeThree;
        }else if ((firstCount == 4 && lastCount == 1) || (firstCount == 3 && lastCount == 2)) {
            winType = PYWinResultTypeFour;
        }else if (firstCount == 4 || (firstCount == 3 && lastCount == 1) || (firstCount == 2 && lastCount == 2)) {
            winType = PYWinResultTypefive;
        }else if (firstCount == 3 || (firstCount == 1 && lastCount == 2) || (firstCount == 2 && lastCount == 1) || lastCount == 2) {
            winType = PYWinResultTypeSix;
        }
    }else {
        if (firstCount == 6 && lastCount == 1) {
            winType = PYWinResultTypeOne;
        }else if (firstCount == 6) {
            winType = PYWinResultTypeTwo;
        }else if (firstCount == 5 && lastCount == 1) {
            winType = PYWinResultTypeThree;
        }else if (firstCount == 5 || (firstCount == 4 && lastCount == 1)) {
            winType = PYWinResultTypeFour;
        }else if (firstCount == 4 || (firstCount == 3 && lastCount == 1)) {
            winType = PYWinResultTypefive;
        }else if ((firstCount == 2 && lastCount == 1) || (firstCount == 1 && lastCount == 1) || lastCount == 1) {
            winType = PYWinResultTypeSix;
        }
    }
    
    return winType;
}

+ (BOOL)py_isWin:(PYLotteryType)type winArr:(NSArray *)winArr userArr:(NSArray *)userArr {
    return [PYWinManage py_winResult:type winArr:winArr userArr:userArr];
}

+ (NSString *)py_winString:(PYWinResultType)winType {
    NSString *str = @"";
    switch (winType) {
        case PYWinResultTypeOne:
            str = @"一等奖";
            break;
        case PYWinResultTypeTwo:
            str = @"二等奖";
            break;
        case PYWinResultTypeThree:
            str = @"三等奖";
            break;
        case PYWinResultTypeFour:
            str = @"四等奖";
            break;
        case PYWinResultTypefive:
            str = @"五等奖";
            break;
        case PYWinResultTypeSix:
            str = @"六等奖";
            break;
        case PYWinResultTypeSeven:
            str = @"七等奖";
            break;
            
        default:
            break;
    }
    return str;
}

@end
