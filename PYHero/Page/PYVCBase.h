//
//  PYVCBase.h
//  PYHero
//
//  Created by Bob Lee on 2018/4/5.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.h"

#define KColorTheme [UIColor colorWithARGBString:@"#FFD700"]

@interface PYVCBase : UIViewController <UIMemoryClean, UIInitLogic>

@property (nonatomic, strong) NSMutableArray *mArrData;    ///< 数据源

/**
 * @brief 子类重写处理自己View界面相关变化，应用主题变化；基类处理与导航等相关的操作（当然导航还要细节判断避免在vc-tree中多次更新）
 */
- (void)appThemeUpdated;

@end
