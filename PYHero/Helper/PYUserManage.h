//
//  PYUserManage.h
//  PYHero
//
//  Created by crow on 2018/8/16.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KShakeData @"ShakeData"
#define KUserInfoData @"UserInfoData"

@interface PYUserManage : NSObject

/******************** 摇一摇相关 ************************/
+ (void)py_saveShakeData:(NSObject *)obj type:(PYLotteryType)type;
+ (NSArray *)py_getShakeData:(PYLotteryType)type;

/******************** 我的 ************************/
+ (void)py_saveUsrInfo:(NSArray *)arr; // 保存用户信息，包含头像和昵称
+ (NSArray *)py_getUserInfo;

@end
