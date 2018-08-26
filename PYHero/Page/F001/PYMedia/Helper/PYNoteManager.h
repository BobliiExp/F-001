//
//  PYNoteManager.h
//  PYIMAV
//
//  Created by Bob Lee on 2018/5/16.
//  Copyright © 2018年 Ponyo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define kNote  [PYNoteManager sharedInstance]



@interface PYNoteManager : NSObject

@property (nonatomic, readonly) NSMutableString *noteInfo;   ///< 日志信息，注意初始化从文件读取（文件按照日期控制）,其后内存管理

+ (instancetype)sharedInstance;

/**
 * @brief 增加日志记录
 * @param note 记录信息，注意时间戳不用带
 */
- (void)writeNote:(NSString*)note;

/**
 * @brief 保存日志信息到文件，一半外部不要调用
 */
- (void)saveNote;

/**
 * @brief 观察日志变化
 * @param block 变化通知外部，外部调用noteInfo信息展示即可
 */
- (void)addObserverForNoteChanged:(void(^)(void))block;

+ (NSArray *)loadFiles;

@end
