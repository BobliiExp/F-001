//
//  PYVCOwnSetting.h
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCBase.h"

typedef void(^saveUserInfo)(void);

@interface PYVCOwnSetting : PYVCBase

@property (nonatomic, copy) saveUserInfo block;    ///< 保存成功

@end
