//
//  Protocol.h
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

@protocol UIInitLogic

- (void)setupUI;
- (void)setupData;

@end

@protocol UIMemoryClean

@property (nonatomic, assign) BOOL hadCleaned;   ///< 是否已经清理过了

/**
 * 清理内存
 */
- (void)cleanSelf;

@optional

- (void)reloadData;

/**
 * 清理可以再创建的缓存数据或UI
 */
- (void)cleanCache;

/**
 * 重新加载缓存
 */
- (void)reloadCache;

@end
