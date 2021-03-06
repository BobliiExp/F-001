//
//  PYModelSaveMedia.h
//  PYHero
//
//  Created by crow on 2018/8/26.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYModelSaveMedia : NSObject

@property (nonatomic, copy) NSString *startTime;    ///< 开始时间，传时间字符串,2018-08-08 10:30
@property (nonatomic, copy) NSString *duration;     ///< 语音时间，传10:22
@property (nonatomic, assign) NSInteger point;      ///< 使用的积分
@property (nonatomic, assign) BOOL beInvited;       ///< 是否被邀请

@end
