//
//  PYVAlertStep.m
//  PYHero
//
//  Created by crow on 2018/8/24.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVAlertStep.h"

@implementation PYVAlertStep

- (instancetype)initWithStep:(NSInteger)step {
    if (self == [super init]) {
        CGFloat width = 270;
        self.frame = CGRectMake(0, 0, width, 0);
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 0, width - 12.f*2, 40)];
        labTitle.textColor = kColor_Title;
        labTitle.text = @"步数兑换";
        labTitle.textAlignment = NSTextAlignmentCenter;
        labTitle.font = kFont_XL;
        [self addSubview:labTitle];
        
        UILabel *labContent = [[UILabel alloc] initWithFrame:CGRectMake(12.f, CGRectGetMaxY(labTitle.frame), labTitle.mj_w, 100)];
        labContent.textAlignment = labTitle.textAlignment;
        labContent.font = kFont_Normal;
        labContent.textColor = kColor_Title;
        labContent.numberOfLines = 0;
        labContent.text = step ? [NSString stringWithFormat:@"现有%ld步，可兑换积分%ld\n（100步兑1分）",step,step/100] : @"今天已经兑换步数了，请明天再来吧";
        [self addSubview:labContent];
        
        width = 100;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.mj_w - width)/2.f, CGRectGetMaxY(labContent.frame), width, 30)];
        btn.titleLabel.font = kFont_Normal;
        [btn setTitle:step ? @"收入囊中" : @"好的" forState:UIControlStateNormal];
        [btn setTitleColor:kColor_Title forState:UIControlStateNormal];
        btn.layer.borderColor = KColorTheme.CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btn.mj_h/2.f;
        btn.tag = step;
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(btnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.frame = CGRectMake(0, 0, 270, CGRectGetMaxY(btn.frame) + 20);
    }
    return self;
}

- (void)btnOnClicked:(UIButton *)btn {
    if (btn.tag) {
        NSInteger point = [PYUserManage py_getPoint].integerValue;
        point += (btn.tag - 3000)/100;
        [PYUserManage py_savePoint:[NSString stringWithFormat:@"%ld",point]];
        
        AlertBlock block = objc_getAssociatedObject(self, @"block_key");
        if (block) {
            block(1,YES);
        }
    }
    
    [AFFAlertView dismiss];
}

@end
