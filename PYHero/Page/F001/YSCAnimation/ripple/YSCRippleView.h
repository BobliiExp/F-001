//
//  YSCRippleView.h
//  AnimationLearn
//
//  Created by yushichao on 16/2/17.
//  Copyright © 2016年 yushichao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YSCRippleType) {
    YSCRippleTypeLine,
    YSCRippleTypeRing,
    YSCRippleTypeCircle,
    YSCRippleTypeMixed,
};

@interface YSCRippleView : UIView

@property (nonatomic, strong) UIButton *rippleButton;

/**
 *  show ripple view
 *
 *  @param type ripple type
 */
- (void)showWithRippleType:(YSCRippleType)type;

/**
 *  remove ripple view
 */
- (void)removeFromParentView;

- (void)updateButtonFrame:(CGRect)frame;

- (void)onButtonClicked:(void(^)(void))buttonClicked;

- (void)updateButtonImage:(UIImage*)img;

- (void)cleanTheme;

@end
