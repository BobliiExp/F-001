//
//  PYVAlertLottery.m
//  PYHero
//
//  Created by crow on 2018/8/23.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVAlertLottery.h"

@implementation PYVAlertLottery

- (instancetype)initWithImgName:(NSString *)imgName point:(NSString *)point {
    if (self == [super init]) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    
        CGFloat width = 260;
        self.frame = CGRectMake(0, 0, width, 0);
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 0, width-12.f*2, 40)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = kFont_Title;
        lab.textColor = kColor_Title;
        lab.text = point.integerValue ? [NSString stringWithFormat:@"%@ %@ %@",KLocalizable(@"congratulations"),point,KLocalizable(@"point")] : KLocalizable(@"playAgain");
        [self addSubview:lab];
        
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(0, lab.mj_h, width, 1.f);
        line.backgroundColor = kColor_Background.CGColor;
        [self.layer addSublayer:line];
        
        width = 50;
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.mj_w - width)/2.f, CGRectGetMaxY(line.frame) + 12.f, width, width)];
        imgV.image = [UIImage imageNamed:imgName];
        imgV.contentMode = point.integerValue ? UIViewContentModeCenter : UIViewContentModeScaleAspectFit;
        [self addSubview:imgV];
        
        width = 100;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.mj_w - width)/2.f, CGRectGetMaxY(imgV.frame) + 12.f, width, 35)];
        btn.titleLabel.font = [UIFont fontNormal:13.f];
        [btn setTitleColor:kColor_Title forState:UIControlStateNormal];
        [btn setTitle:point.integerValue ? KLocalizable(@"incomePocket") : KLocalizable(@"ok") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnOnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.layer.cornerRadius = btn.mj_h/2.f;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kColor_Background.CGColor;
        btn.layer.borderWidth = 1.f;
        
        self.frame = CGRectMake(0, 0, 260, CGRectGetMaxY(btn.frame) + 20);
    }
    return self;
}

- (void)btnOnClicked {
    [AFFAlertView dismiss];
}

@end
