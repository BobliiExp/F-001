//
//  MacroCustom.h
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#ifndef MacroCustom_h
#define MacroCustom_h

#import "localization.h"

// 主题配置
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//NavBar高度
#define kCurrentStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBar_Height 44.0f
#define kTabBar_Height  49.0f

#define kBadge_Height                       18.0f
#define kBadge_Width                        18.0f
#define kBadge_Width_2                      23.0f // 2位数
#define kBadge_Width_3                      31.0f // 3位数
#define kBadge_Width_Notify                 8.0f  // 仅通知tab、cell中
#define kBadge_Width_Notify_S               5.0f  // 仅通知上导航、部分控件上

#pragma mark UITableView cell

#define kPadding_BottomBar_H                30.0f       // 全屏等界面的底部操作按钮距离左右屏幕边距
#define kPadding_BottomBar_V                20.0f       // 全屏等界面的底部操作按钮距离底部屏幕边距

#define kPadding_Delta                      0

// cell内部内容与cell边界
#define kPadding_Cell_H                      (12.0f+kPadding_Delta)      // cell 横向距离边界空间（cell中的内容与cell边界）
#define kPadding_Cell_V                      (12.0f+kPadding_Delta)      // cell 垂直距离边界空间（二行文字时）

// cell间或cell与屏幕的空间
#define kMargin_Cell_H                       (10.0f+kPadding_Delta)      // cell 之间的空间（如鱼潮主界面，踏浪界面cell与屏幕边界）
#define kMargin_Cell_V                       (10.0f+kPadding_Delta)      // cell 之间上下空间（如鱼榜、鱼潮等）

#define kMargin_Cell_Item_V                  (5.0f+kPadding_Delta)      // cell中控件距离自己下方控件距离（三行文字时）
#define kMargin_Cell_Item_H                  (5.0f+kPadding_Delta)      // cell中控件距离其他控件横向距离

#define kHeight_Delta                        (ScreenScale>2?3:0) // 不同分辨率的差值，因为子图会变化

#define kHeight_Cell_S                       (43.0f+kHeight_Delta)      // cell高度（图片22|29|一行文字）
#define kHeight_Cell_M                       (50.0f+kHeight_Delta)      // cell高度（图片36&一行文字）
#define kHeight_Cell_L                       (65.0f+kHeight_Delta)      // cell高度（图片36&二行文字）
#define kHeight_Cell_XL                      (80.0f+kHeight_Delta)      // cell高度（图片36&三行文字）

#define kHeight_Section_S                    11.0f      // cell分区高度（没有内容）
#define kHeight_Section_M                    36.0f      // cell分区高度（一行文字）

#pragma mark End

#pragma mark 系统头像大小
#define kHeight_PlayerIcon_S                 (22.0f+kHeight_Delta)      // 头像 - 小（日历贴章、首页排行榜商家）
#define kHeight_PlayerIcon_M                 (40.0f+kHeight_Delta)      // 头像 - 中（各种列表：鱼榜，鱼潮，聊天）
#define kHeight_PlayerIcon_L                 (50.0f+kHeight_Delta)      // 头像 - 大（鱼信，鱼塔、鱼塘标题栏，鱼塘钓鱼人）
#define kHeight_PlayerIcon_XL                (54.0f+kHeight_Delta)      // 头像 - 超大（鱼榜单个）
#define kHeight_PlayerIcon_XXL               (59.0f+kHeight_Delta)      // 头像 - 超超大（日历、详细资料）


/** 头像、按钮 圆角 **/
#define kCorner_Icon_S                       3.0f       // 方头像、按钮
#define kCorner_Chat_Bubble                  5.0f       // 聊天气泡
#define kCorner_Circle_Board                 5.0f       // 圈子打卡、简报、投票、活动等等

/** End **/

/** 系统图标大小 **/
#define kHeight_PagePoint                   5.0f        // 分页控件标点
#define kHeight_CircleOpr                   40.0f       // 普通圆形按钮（鱼塘、鱼塔下边兰，详细资料勋章图标）
#define kHeight_FishSign                    22.0f       // 不同界面的鱼章图标大小
#define kHeight_Fish                        45.0f       // 鱼形象（聊天、鱼典、弹出框）
#define kHeight_NavIcon                     17.0f       // 导航栏按钮图标
#define kHeight_Button_Cell                 22.0f       // cell中的按钮、其他圆角小按钮
#define kHeight_Button_GM                   32.0f       // 捕手用普通按钮高度，圆角是高度一半
#define kHeight_Button                      40.0f       // 通用VC底部操作按钮高度
#define kHeight_Button_CommonOperation      15.0f       // 通用小操作按钮（一般在cell上的箭头、checkbox、radio等）
#define kHeight_Button_ChatBoard            22.0f       // 鱼板上的按钮高度
/** End **/

#define kFrame_Button(y)                       CGRectMake(kPadding_Cell_H, y, SCREEN_WIDTH-kPadding_Cell_H*2, kHeight_Button)

#define kDelta_H(xOf320)    (xOf320*SCREEN_WIDTH/320)
#define kDelta_V(yOf320)    (yOf320*SCREEN_HEIGHT/480)

#define kWidth_Alert                        270.0f      ///< 弹出框统一宽度
#define kAlertViewWidth         kWidth_Alert

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define kCurrentStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#endif /* MacroCustom_h */
