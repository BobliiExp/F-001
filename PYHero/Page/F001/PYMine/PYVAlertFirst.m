//
//  PYVAlertFirst.m
//  PYHero
//
//  Created by crow on 2018/8/26.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVAlertFirst.h"

@implementation PYVAlertFirst

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, 270, 0);
    
    CGFloat width = 270;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 0, width - 12.f*2, 40.f)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = kFont_XL;
    lab.textColor = kColor_Title;
    lab.text = @"喜迎新人";
    [self addSubview:lab];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.mj_w - 12.f - 20, 10, 20, 20)];
    [btnClose setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [btnClose setContentMode:UIViewContentModeCenter];
    [btnClose addTarget:self action:@selector(btnClosedOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    
    CALayer *line1 = [[CALayer alloc] init];
    line1.backgroundColor = kColor_Background.CGColor;
    line1.frame = CGRectMake(0, CGRectGetMaxY(lab.frame), self.mj_w, 1.f);
    [self.layer addSublayer:line1];
    
    width = 60;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.mj_w - width)/2.f, CGRectGetMaxY(line1.frame) + 12.f, width, width)];
    imgV.layer.cornerRadius = imgV.mj_h/2.f;
    imgV.layer.masksToBounds = YES;
    imgV.image = [UIImage imageNamed:@"ic_avatar_default"];
    [self addSubview:imgV];
    
    UILabel *labContent = [[UILabel alloc] initWithFrame:CGRectMake(12.f, CGRectGetMaxY(imgV.frame) + 12.f, lab.mj_w, 60)];
    labContent.textAlignment = lab.textAlignment;
    labContent.font = kFont_Normal;
    labContent.textColor = kColor_Title;
    labContent.numberOfLines = 0;
    labContent.text = @"恭喜您获得新人奖励20积分！\n赶快去更新自己的头像和昵称吧！";
    [self addSubview:labContent];
    
    width = (self.mj_w - 12.f*3)/2.f;
    UIButton *btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(12.f, CGRectGetMaxY(labContent.frame) + 12.f, width, 35)];
    btnSetting.tag = 10;
    [btnSetting setTitle:@"去设置" forState:UIControlStateNormal];
    [btnSetting setTitleColor:kColor_Title forState:UIControlStateNormal];
    [self addSubview:btnSetting];
    [btnSetting addTarget:self action:@selector(btnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnPoint = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnSetting.frame) + 12.f, btnSetting.mj_y, width, 35)];
    btnPoint.tag = 11;
    [btnPoint setTitle:@"了解积分" forState:UIControlStateNormal];
    [btnPoint setTitleColor:kColor_Title forState:UIControlStateNormal];
    [self addSubview:btnPoint];
    [btnPoint addTarget:self action:@selector(btnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btnPoint.titleLabel.font = btnSetting.titleLabel.font = kFont_Normal;
    btnPoint.layer.cornerRadius = btnSetting.layer.cornerRadius = btnSetting.mj_h/2.f;
    btnPoint.layer.masksToBounds = btnSetting.layer.masksToBounds = YES;
    btnPoint.layer.borderColor = btnSetting.layer.borderColor = kColor_Background.CGColor;
    btnPoint.layer.borderWidth = btnSetting.layer.borderWidth = 1.f;
    
    self.frame = CGRectMake(0, 0, 270, CGRectGetMaxY(btnPoint.frame) + 12.f);
}

- (void)btnOnClicked:(UIButton *)btn {
    AlertBlock block = objc_getAssociatedObject(self, @"block_key");
    if (block) {
        block(btn.tag, NO);
    }
    
    [AFFAlertView dismiss];
}

- (void)btnClosedOnClicked {
    [AFFAlertView dismiss];
}

@end
