//
//  PYUserManage.m
//  PYHero
//
//  Created by crow on 2018/8/16.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYUserManage.h"

#define kUserDefaults [NSUserDefaults standardUserDefaults]

@implementation PYUserManage

+ (void)py_saveString:(NSString *)str key:(NSString *)key {
    [kUserDefaults setObject:str forKey:key];
    [kUserDefaults synchronize];
}

+ (NSString *)py_getStringWithKey:(NSString *)key {
    return [kUserDefaults objectForKey:key];
}

+ (void)py_savePoint:(NSString *)point {
    [kUserDefaults setObject:point forKey:@"UserPoint"];
    [kUserDefaults synchronize];
}

+ (NSString *)py_getPoint {
    return [kUserDefaults objectForKey:@"UserPoint"];
}

/******************** 摇一摇相关 ************************/
+ (void)py_saveShakeData:(NSObject *)obj type:(PYLotteryType)type {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:[self py_getShakeData:type]];
    [mArr insertObject:obj atIndex:0];
    
    [kUserDefaults setObject:mArr forKey:[NSString stringWithFormat:@"%@%ld",KShakeData,type]];
    [kUserDefaults synchronize];
}

+ (NSArray *)py_getShakeData:(PYLotteryType)type {
    NSArray *arr = [kUserDefaults objectForKey:[NSString stringWithFormat:@"%@%ld",KShakeData,type]];
    
    if (!arr) {
        arr = [NSArray array];
    }
    return arr;
}

/******************** 我的 ************************/
+ (void)py_saveUsrInfo:(NSArray *)arr {
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [dirArray firstObject];
    path = [path stringByAppendingPathComponent:@"imageHead"];
    NSData *imageData = UIImageJPEGRepresentation(arr.firstObject, 1.0);
    [imageData writeToFile:path atomically:YES];
    
    [kUserDefaults setObject:arr.lastObject forKey:KUserInfoData];
    [kUserDefaults synchronize];
}

+ (NSArray *)py_getUserInfo {
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [dirArray firstObject];
    path = [path stringByAppendingPathComponent:@"imageHead"];
    
    UIImage *img;
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSData *picData = [NSData dataWithContentsOfFile:path];
        img = [UIImage imageWithData:picData];
    }
    
    if (!img) {
        img = [UIImage imageNamed:@"ic_score_combat_value"];
    }
    
    NSString *name = [kUserDefaults objectForKey:KUserInfoData];
    if (!name) {
        name = @"给自己起个名字吧";
    }
    
    NSArray *arr =@[img,name];
    return arr;
}

/******************** 转一转相关 ************************/
+ (void)py_saveLotteryData:(NSArray *)data {
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:[self py_getLotteryData]];
    [mArr insertObject:data atIndex:0];
    
    [kUserDefaults setObject:mArr forKey:@"KPYLottery"];
    [kUserDefaults synchronize];
}

+ (NSArray *)py_getLotteryData {
    NSArray *arr = [kUserDefaults objectForKey:@"KPYLottery"];
    
    if (!arr) {
        arr = [NSArray array];
    }
    return arr;
}

@end
