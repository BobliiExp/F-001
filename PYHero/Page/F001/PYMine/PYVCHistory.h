//
//  PYVCHistory.h
//  PYHero
//
//  Created by crow on 2018/8/19.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVCBase.h"

typedef NS_ENUM(NSUInteger, PYHistoryType) {
    PYHistoryTypeVoice,    ///< 语音
    PYHistoryTypeLottery,  ///< 转一转
    PYHistoryTypeShake,    ///< 摇一摇
    PYHistoryTypeVR,       ///< 捉妖
};

@interface PYVCHistory : PYVCBase

@property (nonatomic, assign) PYLotteryType type;    ///< 

@end
