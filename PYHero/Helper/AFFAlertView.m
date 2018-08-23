//
//  AFFAlertView.m
//  AnyfishApp
//
//  Created by Lydix-Liu on 15/11/26.
//  Copyright © 2015年 Anyfish. All rights reserved.
//

#import "AFFAlertView.h"

#define kNaviFrame CGRectMake(0, 0, SCREEN_WIDTH, kNavigationBar_Height+kCurrentStatusBarHeight)

#define kFont_Title [UIFont systemFontOfSize:15]
#define kFont_Content [UIFont systemFontOfSize:15]
#define kColor_Text [UIColor blackColor]
#define kColor_Content [UIColor blackColor]

@interface AFFAlertView()

@property (nonatomic, assign) BOOL isShowInBackgound;///< 判断当前是否有弹出框在后台显示

@end

@implementation AFFAlertView {
    UIView *customSuperView;
    BOOL isKeybordShowing;//键盘
    UIView *viewDisp; // 正在显示的弹框
}

+ (AFFAlertView *)sharedView {
    static AFFAlertView *sharedView;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        sharedView.autoCorner = YES;
    });
    
    return sharedView;
}

+ (void)touchDismiss:(BOOL)dismiss {
    [AFFAlertView sharedView].touchDismiss = dismiss;
}

+ (void)autoCorner:(BOOL)corner {
    [self sharedView].autoCorner = corner;
}

+ (void)specTitleColor:(UIColor *)color {
    [AFFAlertView sharedView].specColor = color;
}

- (BOOL)isShowInBackgound {
    if (self.isShowing) {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                for (UIView *view in window.subviews) {
                    if (view == self && view != window.subviews.lastObject) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

- (void)setIsHandle:(BOOL)isHandle {
    [self clean];
    _isHandle = isHandle;
}

#pragma mark - alert
+ (void)alertWithTitle:(NSString *)title content:(NSString *)content btnTitle:(NSArray *)titles block:(AlertBlock)block {
    [[self sharedView] showAlertWithObject:title content:content btnTitles:titles inView:nil block:block];
}

+ (void)alertWithTitle:(NSString *)title btnTitle:(NSArray *)titles block:(AlertBlock)block {
    [[self sharedView] showAlertWithObject:title content:nil btnTitles:titles inView:nil block:block];
}

+ (void)alertWithView:(UIView *)view btnTitle:(NSArray *)titles block:(AlertBlock)block {
    [[self sharedView] showAlertWithObject:view content:nil btnTitles:titles inView:nil block:block];
}

+ (void)alertWithView:(UIView *)view inView:(UIView *)superView btnTitle:(NSArray *)titles block:(AlertBlock)block {
    [[self sharedView] showAlertWithObject:view content:nil btnTitles:titles inView:superView block:block];
}

+ (void)alertWithView:(UIView *)view block:(AlertBlock)block {
    [[self sharedView] alertWithView:view block:block];
}

+ (void)alertWithTitle:(NSString *)title content:(NSString *)content btnTitle:(NSArray *)titles inView:(UIView *)superView block:(AlertBlock)block {
    [[self sharedView] showAlertWithObject:title content:content btnTitles:titles inView:superView block:block];
}

+ (void)highPriorityAlertWithTitle:(NSString*)title content:(NSString*)content btnTitle:(NSArray*)titles block:(AlertBlock)block {
    [self clean];
//    [[self sharedView] showAlertWithObject:title content:content btnTitles:titles inView:nil block:block];
    [self alertWithTitle:title content:content btnTitle:titles block:block];
}

+ (void)highPriorityAlertWithView:(UIView*)view btnTitle:(NSArray*)titles block:(AlertBlock)block {
    [self clean];
//    [[self sharedView] showAlertWithObject:view content:nil btnTitles:titles inView:nil block:block];
    [self alertWithView:view btnTitle:titles block:block];
}

- (void)showAlertWithObject:(id)obj cbj:(NSObject*)cbj btnTitles:(NSArray *)titles inView:(UIView *)superView block:(AlertBlock)block {
    if(self.isHandle && mArrViews.count>0){
        return;
    }
    
    if(titles==nil){ // lsb 2015-12-16, 这种一定有按钮，如果没提供走默认
        titles = @[kAFLocalize(kActCancel), kAFLocalize(kActConfirm)];
    }
    
    self.touchNaviDisable = YES;
    
    //创建alert的view
    UIView *alerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertViewWidth, 100)];
    CGFloat height = kAlertEdgeWidth;
    
    if ([obj isKindOfClass:[NSString class]]) {//处理文字
        
        NSString *str = obj;
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:kFont_Title, NSStrokeWidthAttributeName:@(kAlertViewWidth-2*kAlertEdgeWidth)}];
        
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertEdgeWidth, height, kAlertViewWidth-2*kAlertEdgeWidth, size.height)];
        labelView.font = kFont_Title;
        labelView.numberOfLines = 0;
        labelView.lineBreakMode = NSLineBreakByWordWrapping;
        labelView.textColor = kColor_Text;
        labelView.backgroundColor = [UIColor clearColor];
        labelView.textAlignment = NSTextAlignmentCenter;
        labelView.text = str;
        [alerView addSubview:labelView];
        
        height += size.height + kAlertEdgeWidth;
    } else if (obj != nil) {//处理view
        alerView = obj;
        
        height = ((UIView *)obj).frame.size.height;
    }
    
    //处理content
    if (cbj) {
        NSString *str = (NSString*)cbj;
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:kFont_Title, NSStrokeWidthAttributeName:@(kAlertViewWidth-2*kAlertEdgeWidth)}];
        
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertEdgeWidth, height, kAlertViewWidth-2*kAlertEdgeWidth, size.height)];
        labelView.font = kFont_Content;
        labelView.numberOfLines = 0;
        labelView.lineBreakMode = NSLineBreakByWordWrapping;
        labelView.textColor = kColor_Content;
        labelView.backgroundColor = [UIColor clearColor];
        labelView.textAlignment = NSTextAlignmentCenter;
        labelView.text = str;
        [alerView addSubview:labelView];
        
        height += size.height + kAlertEdgeWidth;
    }
    
    //添加button
    for (int i = 0; i < titles.count; i++) {
        NSString *title = [titles objectAtIndex:i];
        UIImage *image = [UIImage imageWithColorString:@"#ffffff" frame:CGRectMake(0, 0, 135, 50)] ;
        UIImage *highLighImg = [UIImage imageWithColor:[UIColor colorWithWhite:0. alpha:.15]];//[UIImage imageWithColorString:@"#1fa4ff" frame:CGRectMake(0, 0, 135, 50)];
        
        CGFloat width = titles.count > 1 ? (kAlertViewWidth/2 + 2) : (kAlertViewWidth + 2);
        CGFloat xOffset = (i % 2) * kAlertViewWidth/2 - (i+1)%2;
        
        if (titles.count > 2) {
            width = kAlertViewWidth + 2;
            xOffset = -1;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, height, width, kAlertBtnHeight);
        
        button.titleLabel.font = kFont_Title;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100000 + i;
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:highLighImg forState:UIControlStateHighlighted];
        [button setTitleColor:self.specColor ? self.specColor : [UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        if (!(titles.count > 2 && i != 0 && i != titles.count - 1)) {
            button.layer.borderColor = [UIColor colorWithARGBString:@"#d8d9db"].CGColor;
            button.layer.borderWidth = .5f;
        }
        
        [alerView addSubview:button];
        
        [button addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (titles.count > 2 && i != titles.count - 1) {
            height += kAlertBtnHeight;
        } else if (i == titles.count - 1 || i % 2 == 1){
            height += kAlertBtnHeight - 1;
        }
    }
    
    // 更新自己的frame
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.frame = frame;
    
    // lsb 这里优化，判断自定义view是否超出一定范围，否则采用他的大小
    if(CGRectGetWidth(alerView.frame)>kAlertViewWidth){
        // 控制center
        CGPoint center = CGPointMake((superView?CGRectGetWidth(superView.frame):SCREEN_WIDTH)/2, (superView?CGRectGetHeight(superView.frame):SCREEN_HEIGHT)/2);
        alerView.center = center;
    }else {
        //调整view的frame和样式
        alerView.frame = CGRectMake(SCREEN_WIDTH/2-kAlertViewWidth/2, (SCREEN_HEIGHT-height) / 2, kAlertViewWidth, height);
        alerView.backgroundColor = [UIColor whiteColor];
        alerView.layer.cornerRadius = kAlertViewCorner;
        alerView.layer.masksToBounds = YES;
    }
    
    if (superView) {
        customSuperView = superView;
    }
    
    if (block)
        objc_setAssociatedObject(alerView, @"block_key", block, OBJC_ASSOCIATION_COPY);
    
    //如果当前有弹出框显示
    if (_isShowing) {
        if (!mArrViews)
            mArrViews = [NSMutableArray array];
        
        [mArrViews addObject:alerView];
        
        if (self.isShowInBackgound) {
            [self dismiss];
        }
        return;
    }
    
    self.isShowing = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewKeybordHandle:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewKeybordHandle:) name:UIKeyboardWillHideNotification object:nil];
    
    viewDisp = alerView;
    
    [self addSubview:alerView];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    //    self.touchDismiss = NO;
    
    //显示
    [self show];
}

- (void)showAlertWithObject:(id)obj content:(NSString *)content btnTitles:(NSArray *)titles inView:(UIView *)superView block:(AlertBlock)block {
    [self showAlertWithObject:obj cbj:content btnTitles:titles inView:superView block:block];
}

- (void)alertWithView:(UIView *)view block:(AlertBlock)block {
    if(self.isHandle && mArrViews.count>0){
        return;
    }
    
    if (block)
        objc_setAssociatedObject(view, @"block_key", block, OBJC_ASSOCIATION_COPY);
    
    //如果当前有弹出框显示
    if (_isShowing) {
        if (!mArrViews)
            mArrViews = [NSMutableArray array];
        
        [mArrViews addObject:view];
        
        if (self.isShowInBackgound) {
            [self dismiss];
        }
        return;
    }
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.frame = frame;
    
    if (frame.origin.y > 0) {
        frame.origin.y = 0;
        frame.size.height += CGRectGetHeight(kNaviFrame);
        self.frame = frame;
    }
    
    if (view.tag == 11011011) {//actionsheet
        frame = view.frame;
        frame.origin.y = self.bounds.size.height;
        view.frame = frame;
    } else {
        view.center = self.center;
        if (self.autoCorner) {
            view.layer.cornerRadius = kAlertViewCorner;
            view.layer.masksToBounds = YES;
        }
    }
    
    //第一时间将显示状态设置上
    self.isShowing = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewKeybordHandle:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewKeybordHandle:) name:UIKeyboardWillHideNotification object:nil];
    viewDisp = view;
    [self addSubview:view];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
//    self.touchDismiss = NO;
    
    //显示
    [self show];
}

#pragma mark - actionSheet

+ (void)actionSheetWithTitle:(NSString *)title btnTitle:(NSArray *)titles block:(AlertBlock)block {
    [[self sharedView] actionSheetWithObject:title btnTitles:titles withCancel:NO block:block];
}

+ (void)actionSheetWithView:(UIView *)view withCancel:(BOOL)withCancel block:(AlertBlock)block {
    [[self sharedView] actionSheetWithObject:view btnTitles:nil withCancel:withCancel block:block];
}

+ (void)actionSheetWithView:(UIView *)view block:(AlertBlock)block {
    [[self sharedView] actionSheetWithView:view block:block];
}

- (void)actionSheetWithObject:(id)obj btnTitles:(NSArray *)titles withCancel:(BOOL)cancel block:(AlertBlock)block {
    if(self.isHandle && mArrViews.count>0){
        return;
    }
    
    self.touchNaviDisable = YES;
    
    float width = 0,height = 0;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        width = CGRectGetWidth([UIScreen mainScreen].bounds) - kAlertEdgeWidth;
    } else {
        width = CGRectGetHeight([UIScreen mainScreen].bounds) - kAlertEdgeWidth;
    }
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, width, 0)];
    sheetView.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    headerView.backgroundColor = [UIColor whiteColor];
    [sheetView addSubview:headerView];
    
    if ([obj isKindOfClass:[NSString class]] && obj) {
        height = 16;
        
        NSString *desc = obj;
        CGSize size = [desc sizeWithAttributes:@{NSFontAttributeName:kFont_Title, NSStrokeWidthAttributeName:@(width-2*kAlertEdgeWidth)}];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kAlertEdgeWidth, height, width-2*kAlertEdgeWidth, size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = kFont_Title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kColor_Text;
        label.text = obj;
        label.numberOfLines = 0;
        [headerView addSubview:label];
        
        height += size.height + kAlertEdgeWidth;
    } else {
        if (obj) {
            height = 0;
            
            [headerView addSubview:obj];
            
            height += [(UIView *)obj frame].size.height;
        }
        if (cancel && titles.count == 0) {//需要取消按钮
            titles = @[@"取消"];
        } else if (cancel && titles.count > 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:titles];
            [arr addObject:@"取消"];
            titles = arr;
        }
    }
    
    if (height > 0) {
        headerView.frame = CGRectMake(0, 0, width, height);
        
        UIRectCorner corner = titles.count < 2 ? UIRectCornerAllCorners : (UIRectCornerTopLeft | UIRectCornerTopRight);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(kAlertViewCorner, kAlertViewCorner)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        headerView.layer.mask = layer;
        
        if (titles.count < 2) {
            height += 10;
        } else {
            height += 0.5;
        }
    }
    
    if (titles.count) {
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, height, width, kHeight_Fish)];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = kFont_Title;
            [button setTitleColor:self.specColor ? self.specColor : kColor_Text forState:UIControlStateNormal];
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0. alpha:.15]] forState:UIControlStateHighlighted];
            button.tag = 100000 + i;
            [sheetView addSubview:button];
            [button addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIRectCorner corner = 0;
            if (titles.count == 1 || i == titles.count - 1) {
                corner = UIRectCornerAllCorners;
            } else if (!obj && i == 0) {
                if (titles.count < 3) {
                    corner = UIRectCornerAllCorners;
                } else {
                    corner = UIRectCornerTopLeft | UIRectCornerTopRight;
                }
            } else if (i == titles.count - 2) {
                corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(kAlertViewCorner, kAlertViewCorner)];
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.path = path.CGPath;
            button.layer.mask = layer;
            
            height += kHeight_Fish;
            
            if (i + 3 > titles.count) {
                height += 10;
            } else {
                height += 0.5;
            }
        }
    }
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.frame = frame;
    
    sheetView.frame = CGRectMake(kAlertEdgeWidth/2, self.frame.size.height, width, height);
    sheetView.tag = 11011011;
    
    if (block)
        objc_setAssociatedObject(sheetView, @"block_key", block, OBJC_ASSOCIATION_COPY);
    
    //如果当前有弹出框显示
    if (_isShowing) {
        if (!mArrViews)
            mArrViews = [NSMutableArray array];
        
        [mArrViews addObject:sheetView];
        
        if (self.isShowInBackgound) {
            [self dismiss];
        }
        return;
    }
    
    if (frame.origin.y > 0) {
        frame.origin.y = 0;
        frame.size.height += CGRectGetHeight(kNaviFrame);
        self.frame = frame;
    }
    viewDisp = sheetView;
    [self addSubview:sheetView];
    
    [self show];
}

- (void)actionSheetWithView:(UIView *)view block:(AlertBlock)block {
    view.tag = 11011011;
    [self alertWithView:view block:block];
    self.touchDismiss = YES;
}

#pragma mark - 点击事件
- (void)alertBtnClicked:(UIButton *)btn {
    [self endEditing:YES];
    BOOL isCancel = [[btn titleForState:UIControlStateNormal] isEqualToString:kAFLocalize(kActCancel)] ||
    [[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"];//英文系统中出现中文@“取消”
    
    AlertBlock block = objc_getAssociatedObject(self.subviews.lastObject, @"block_key");
    if (block) {
        block(btn.tag - 100000, isCancel);
    }
    //使用者自己调用dismiss方法消失
    if (isCancel || self.autoDismiss || [self viewWithTag:11011011]) {
        [self dismiss];
    }
}

- (void)alertViewKeybordHandle:(NSNotification *)notification {
    if (self.isShowing) {//只有当弹出框在显示的时候才启用
        if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
            NSDictionary *dic = notification.userInfo;
            NSValue *value = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect kbFrame = value.CGRectValue;
            
            UIView *showingView = self.subviews.firstObject;
            
            CGRect frame = showingView.frame;
            
            if (kbFrame.size.height > 100 && frame.origin.y + frame.size.height > kbFrame.origin.y) {
                frame.origin.y = kbFrame.origin.y - frame.size.height - 5;
                [UIView animateWithDuration:0.25 animations:^{
                    showingView.frame = frame;
                }];
            }
            isKeybordShowing = YES;
        } else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
            UIView *showingView = self.subviews.firstObject;
            
            [UIView animateWithDuration:0.25 animations:^{
                showingView.center = self.center;
            }];
            isKeybordShowing = NO;
        }
    }
}

#pragma mark - 显示
- (void)show {
    // lsb 2016-02-04 必须在统一入口处理啊，不然判断是否上移不准确啊
    if(!_isShowing)
        _isShowing = YES;
    
    //隐藏sheet
    UIView *sheet = [self viewWithTag:11011011];
    __block CGRect frame = sheet.frame;
    frame.origin.y = self.bounds.size.height;
    sheet.frame = frame;
    
    //显示界面
    self.backgroundColor = [UIColor colorWithWhite:.0 alpha:.5];
    
    [self showAlertEx];
    
    if (sheet) {
        //显示动画
        [UIView animateWithDuration:.15 delay:.15 options:UIViewAnimationOptionCurveLinear animations:^{
            frame.origin.y -= sheet.frame.size.height;
            sheet.frame = frame;
        } completion:^(BOOL finished) {
            self.touchDismiss = YES;
        }];
    }
}

- (void)showAlertEx {
    if (customSuperView) {
        [customSuperView addSubview:self];
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
//                window.windowLevel = UIWindowLevelStatusBar;
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    // ios8以下需要强制旋转
    if(IOS_VERSION<8.0){
        if(customSuperView==nil) {
            self.transform = CGAffineTransformIdentity;
        }
    }
    
    [self addTarget:self action:@selector(handleTouch) forControlEvents:UIControlEventTouchDown];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewKeybordHandle:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewKeybordHandle:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 消失
+ (void)dismiss {
    [[self sharedView] dismiss];
}

+ (BOOL)hasSupperView {
    AFFAlertView *al = [self sharedView];
    return al->customSuperView!=nil;
}

+ (void)clean {
    [[self sharedView] clean];
}

+ (void)dismissWhileComfirm:(BOOL)dismiss {
    [self sharedView].autoDismiss = dismiss;
}

- (void)handleTouch {
    if (isKeybordShowing) {
        [self endEditing:YES];
    }
    
    if (self.touchDismiss) {
        
        AlertBlock block = objc_getAssociatedObject(self.subviews.lastObject, @"block_key");
        if (block) {
            block(-1, YES);
        }
        
        [self dismiss];
    }
}

- (void)dismiss {
    if (customSuperView) {
        [self clean];
    } else {
        [UIView animateWithDuration:.2 animations:^{
            UIView *view = [self viewWithTag:11011011];
            if (view) {
                CGRect frame = view.frame;
                frame.origin.y = SCREEN_HEIGHT;
                view.frame = frame;
            }
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (mArrViews.count > 0) {
                for (UIView *view in self.subviews) {//需要将之前的view清理干净
                    [view removeFromSuperview];
                }
                self.isShowing = NO;
                [self alertWithView:mArrViews.firstObject block:nil];
                [mArrViews removeObjectAtIndex:0];
            } else {
                [self clean];
                [self removeFromSuperview];
            }
        }];
    }
}

#pragma mark - 清理
- (void)clean {
    self.autoDismiss = NO;
    self.autoCorner = YES;
    _isHandle = NO;
    
    [mArrViews removeAllObjects];
    mArrViews = nil;
    
    _specColor = nil;
    
    if([self.superview isKindOfClass:[UIWindow class]]){
        UIWindow *window = (UIWindow*)[self superview];
        window.windowLevel = UIWindowLevelNormal;
    }
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
//    if (customSuperView) {
        [self removeFromSuperview];
        customSuperView = nil;
//    }
    
    self.isShowing = NO;
    self.touchNaviDisable = NO;
    self.touchDismiss = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


