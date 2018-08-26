//
//  YSCRippleView.m
//  AnimationLearn
//
//  Created by yushichao on 16/2/17.
//  Copyright © 2016年 yushichao. All rights reserved.
//

#import "YSCRippleView.h"

@interface YSCRippleView ()

@property (nonatomic, strong) NSTimer *rippleTimer;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) YSCRippleType type;
@property (nonatomic, copy) void(^buttonClicked)(void);
@property (nonatomic, strong) UIColor *ringColor;

@end

@implementation YSCRippleView

- (void)removeFromParentView
{
    if (self.superview) {
        [_rippleButton removeFromSuperview];
        [self closeRippleTimer];
        [self removeAllSubLayers];
        [self removeFromSuperview];
        [self.layer removeAllAnimations];
    }
}

- (void)removeAllSubLayers
{
    for (NSInteger i = 0; [self.layer sublayers].count > 0; i++) {
        [[[self.layer sublayers] firstObject] removeFromSuperlayer];
    }
}

- (void)showWithRippleType:(YSCRippleType)type
{
    _type = type;
    [self setUpRippleButton];
    
    self.rippleTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(addRippleLayer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rippleTimer forMode:NSRunLoopCommonModes];
}

- (void)setUpRippleButton
{
    _rippleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _rippleButton.center = self.center;
    _rippleButton.layer.backgroundColor = [UIColor blueColor].CGColor;
    _rippleButton.layer.cornerRadius = 25;
    _rippleButton.layer.masksToBounds = YES;
    _rippleButton.layer.borderColor = [UIColor yellowColor].CGColor;
    _rippleButton.layer.borderWidth = 2;
    [_rippleButton addTarget:self action:@selector(rippleButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_rippleButton];
}

- (void)rippleButtonTouched:(id)sender
{
//    [self closeRippleTimer];
//    [self addRippleLayer];
    
    _ringColor = [UIColor colorWithARGBString:@"#d7ac6b"];
    [_rippleButton setTitle:kAFLocalize(@"") forState:UIControlStateNormal];
    [_rippleButton setBackgroundImage:[UIImage imageNamed:@"ic_avatar_default"] forState:UIControlStateNormal];
    _rippleButton.layer.borderColor = [UIColor colorWithARGBString:@"#d7ac6b" alpha:0.9].CGColor;
    
    if(_buttonClicked)
        _buttonClicked();
}

- (void)updateButtonFrame:(CGRect)frame {
    _rippleButton.frame = frame;
    _rippleButton.center = self.center;
    _rippleButton.layer.cornerRadius = CGRectGetHeight(frame)/2;
    _rippleButton.layer.backgroundColor = [UIColor colorWithARGBString:@"#16a8ef" alpha:0.7].CGColor;
    _rippleButton.layer.borderColor = [UIColor colorWithARGBString:@"#16a8ef" alpha:0.9].CGColor;
    _rippleButton.layer.masksToBounds = YES;
    _ringColor = [UIColor colorWithARGBString:@"#16a8ef"];
    
    [_rippleButton setTitle:kAFLocalize(@"开始语音") forState:UIControlStateNormal];
}

- (void)onButtonClicked:(void(^)(void))buttonClicked {
    _buttonClicked = buttonClicked;
}

- (void)updateButtonImage:(UIImage *)img {
    [_rippleButton setImage:img forState:UIControlStateSelected];
}

- (void)cleanTheme {
    [_rippleButton setTitle:kAFLocalize(@"开始语音") forState:UIControlStateNormal];
    [_rippleButton setBackgroundImage:nil forState:UIControlStateNormal];
    _rippleButton.selected = NO;
    _ringColor = [UIColor colorWithARGBString:@"#16a8ef"];
    _rippleButton.layer.borderColor = [UIColor colorWithARGBString:@"#16a8ef" alpha:0.9].CGColor;
}

- (CGRect)makeEndRect
{
    CGRect endRect = _rippleButton.frame;// CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 50, 50);
    endRect = CGRectInset(endRect, -300, -300);
    return endRect;
}

- (void)addRippleLayer
{
    CAShapeLayer *rippleLayer = [[CAShapeLayer alloc] init];
    rippleLayer.position = CGPointMake(200, 200);
    rippleLayer.bounds = CGRectMake(0, 0, 400, 400);
    rippleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:_rippleButton.frame];
    rippleLayer.path = path.CGPath;
    rippleLayer.strokeColor = _ringColor ? _ringColor.CGColor: [UIColor greenColor].CGColor;
    
    if (YSCRippleTypeRing == _type) {
        rippleLayer.lineWidth = 5;
    } else {
        rippleLayer.lineWidth = 1.5;
    }
    
    if (YSCRippleTypeLine == _type || YSCRippleTypeRing == _type) {
        rippleLayer.fillColor = [UIColor clearColor].CGColor;
    } else if (YSCRippleTypeCircle == _type) {
        rippleLayer.fillColor = [UIColor greenColor].CGColor;
    } else if (YSCRippleTypeMixed == _type) {
        rippleLayer.fillColor = [UIColor grayColor].CGColor;
    }
    
    [self.layer insertSublayer:rippleLayer below:_rippleButton.layer];
    
    //addRippleAnimation
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:_rippleButton.frame];
    CGRect endRect = CGRectInset([self makeEndRect], -100, -100);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    rippleLayer.path = endPath.CGPath;
    rippleLayer.opacity = 0.0;
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 5.0;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 5.0;
    
    [rippleLayer addAnimation:opacityAnimation forKey:@""];
    [rippleLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:rippleLayer afterDelay:5.0];
}

- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer
{
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

- (void)closeRippleTimer
{
    if (_rippleTimer) {
        if ([_rippleTimer isValid]) {
            [_rippleTimer invalidate];
        }
        _rippleTimer = nil;
    }
}

@end
