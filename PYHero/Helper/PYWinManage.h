//
//  PYWinManage.h
//  PYHero
//
//  Created by crow on 2018/8/17.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYWinManage : NSObject

// 中的几等奖
+ (PYWinResultType)py_winResult:(PYLotteryType)type winArr:(NSArray *)winArr userArr:(NSArray *)userArr;
// 是否中奖
+ (BOOL)py_isWin:(PYLotteryType)type winArr:(NSArray *)winArr userArr:(NSArray *)userArr;
// 中了几等奖
+ (NSString *)py_winString:(PYWinResultType)winType;

@end
