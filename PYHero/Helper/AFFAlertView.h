//
//  AFFAlertView.h
//  AnyfishApp
//
//  Created by Lydix-Liu on 15/11/26.
//  Copyright © 2015年 Anyfish. All rights reserved.
//

//弹出框
#define kAlertEdgeWidth     22
#define kAlertBtnHeight     40
#define kAlertViewCorner    5

#import <UIKit/UIKit.h>
#import "MacroCustom.h"

typedef void (^AlertBlock)(NSInteger index, BOOL isCancel);

@interface AFFAlertView : UIControl {
    NSMutableArray *mArrViews;
}

@property (nonatomic, assign) BOOL touchDismiss;///< 点击背景消失,默认为NO

@property (nonatomic, assign) BOOL touchNaviDisable;///< 是否可点击导航

@property (nonatomic, assign) BOOL isShowing;///< 是否有弹出框正在显示

@property (nonatomic, assign) BOOL autoDismiss;///< 自动消失

@property (nonatomic, assign) BOOL autoCorner;    ///< 自动增加圆角默认YES（只针对传入view切没有按钮情况）

@property (nonatomic, strong) UIColor *specColor;///< actionSheet特殊字体色

@property (nonatomic, assign) BOOL isHandle;    ///< 是否只显示当前弹框，其他弹框全部干掉；关闭后清理

+ (AFFAlertView *)sharedView;
/**
 * 弹出框默认居中，按钮由传入名称数量确认（不超过3个），基类统一处理按钮以及背景绘制
 （默认点击背景不可取消）
 * @param  title    标题
 * @param  content  内容
 * @param  dataText 携带了富文本以及可拉取的数据信息对象
 * @param  titles   按钮名称，传入nil表示走默认（取消、确认）
 * @param  block    抛出选中按钮索引，是否取消，如果抛出索引未-1，则表示点击背景消失
 
 * @return
 */
+ (void)alertWithTitle:(NSString*)title btnTitle:(NSArray*)titles block:(AlertBlock)block;
+ (void)alertWithTitle:(NSString*)title content:(NSString*)content btnTitle:(NSArray*)titles block:(AlertBlock)block;
+ (void)alertWithTitle:(NSString *)title content:(NSString *)content btnTitle:(NSArray *)titles inView:(UIView *)superView block:(AlertBlock)block;

/**
 * 弹出框默认居中，自定义内容view，按钮由传入名称数量确认（不超过3个），基类统一处理按钮以及背景绘制
 （默认点击背景不可取消）
 * @param  view         自定view
 * @param  superView    自己指定父view
 * @param  titles       按钮名称
 * @param  block        抛出选中按钮索引，是否取消，如果抛出索引未-1，则表示点击背景消失
 
 * @return
 */
+ (void)alertWithView:(UIView*)view btnTitle:(NSArray*)titles block:(AlertBlock)block;
+ (void)alertWithView:(UIView*)view inView:(UIView*)superView btnTitle:(NSArray*)titles block:(AlertBlock)block;
+ (void)alertWithView:(UIView*)view block:(AlertBlock)block; // view水平垂直居中

/**
 *  高优先级显示弹窗,调用此方式显示弹窗将会直接显示,用于及时处理紧急事务,不建议频繁使用（如果当前有弹窗显示，将会直接消失）
 */
+ (void)highPriorityAlertWithTitle:(NSString*)title content:(NSString*)content btnTitle:(NSArray*)titles block:(AlertBlock)block;
+ (void)highPriorityAlertWithView:(UIView*)view btnTitle:(NSArray*)titles block:(AlertBlock)block;

/**
 * 弹出表单默认从下访抽出，取消按钮基类统一处理
 （默认点击背景可取消）
 * @param  title    显示标题
 * @param  dataText 携带了富文本以及可拉取的数据信息对象
 * @param  titles   按钮名称
 * @param  block    抛出选中按钮索引，是否取消，如果抛出索引未-1，则表示点击背景消失
 
 * @return
 */
+ (void)actionSheetWithTitle:(NSString*)title btnTitle:(NSArray*)titles block:(AlertBlock)block;

/**
 * 弹出View，与sheet展示过程一致
 （默认点击背景可取消）
 * @param  view         自定义view
 * @param  withCancel   是否需要取消按钮（NO = view自己做了取消操作，调用Dismiss）
 * @param  block        抛出选中按钮索引，是否取消，如果抛出索引未-1，则表示点击背景消失
 
 * @return
 */
+ (void)actionSheetWithView:(UIView*)view withCancel:(BOOL)withCancel block:(AlertBlock)block;
+ (void)actionSheetWithView:(UIView*)view block:(AlertBlock)block; // view水平居中，垂直靠底部

/**
 *  消失
 */
+ (void)dismiss;

+ (BOOL)hasSupperView;

/**
 *  清理弹窗
 */
+ (void)clean;

/**
 *  设置点击消失
 *
 *  @param dismiss 是否点击消失,默认为NO
 */
+ (void)touchDismiss:(BOOL)dismiss;

/**
 *  点击确认按钮后弹出框自动消失
 *
 *  @param dismiss 是否自动消失
 */
+ (void)dismissWhileComfirm:(BOOL)dismiss;

/**
 *  是否自动设置圆角，仅针对自定义view弹出框，默认圆角大小5.0
 *
 *  @param corner 设置为YES将自动增加view圆角
 */
+ (void)autoCorner:(BOOL)corner;

/**
 *  设置actionsheet特殊字体色
 *
 *  @param color 显示的特殊字体色
 */
+ (void)specTitleColor:(UIColor *)color;

@end

