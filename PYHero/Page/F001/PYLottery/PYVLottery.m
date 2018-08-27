//
//  PYVLottery.m
//  PYHero
//
//  Created by crow on 2018/8/19.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVLottery.h"

@implementation PYVLottery

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat space1 = 20.f;
        self.frame = CGRectMake(space1, space1, kScreenWidth-space1*2, kScreenWidth-space1*2);
        [self setup:space1];
    }
    return self;
}

- (void)setup:(CGFloat)space1 {
    self.mArrImg = [NSMutableArray array];
    self.backgroundColor = [UIColor redColor];
    
    space1 = 8.f;
    UIView *vBg = [[UIView alloc] initWithFrame:CGRectMake(space1, space1, self.mj_w-space1*2, self.mj_h-space1*2)];
    vBg.backgroundColor = [UIColor colorWithARGBString:@"#FF5A5E"];
    [self addSubview:vBg];
    
    self.layer.cornerRadius = vBg.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = vBg.layer.masksToBounds = YES;
    
    NSArray *arrImg = @[@"oranges",@"melon",@"banana",@"orange",@"mangos",@"seven",@"banana",@"seven",@"cherry",@"mango",@"VR9",@"cherry",@"banana",@"mango",@"sevens",@"melon",@"mango",@"cherry",@"VR9",@"orange"];
    self.arrImgName = arrImg;
    
    CGFloat space2 = 6.f;
    CGFloat width = (vBg.mj_w - space1*2 - space2*5)/6.f;
    for (NSInteger i = 0; i < arrImg.count; i++) {
        CGFloat x = 0;
        CGFloat y = 0;
        if (i < arrImg.count/4) {
            x = space1 + (space2+width)*i;
            y = space1;
        }else if (i < arrImg.count/2) {
            x = space1 + (space2+width)*(arrImg.count/4);
            y = space1 + (space2+width)*(i%(arrImg.count/4));
        }else if (i < arrImg.count/4*3) {
            x = space1 + (space2+width)*(arrImg.count/4) - (space2+width)*(i%(arrImg.count/2));
            y = space1 + (space2+width)*(arrImg.count/4);
        }else {
            x = space1;
            y = space1 + (space2+width)*(arrImg.count/4) - (space2+width)*(i%(arrImg.count/4*3));
        }
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        imgV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        imgV.tag = i;
        imgV.contentMode = UIViewContentModeCenter;
        imgV.image = [UIImage imageNamed:arrImg[i]];
        imgV.layer.cornerRadius = 5.f;
        imgV.layer.masksToBounds = YES;
        [vBg addSubview:imgV];
        
        [self.mArrImg addObject:imgV];
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    btn.center = CGPointMake(vBg.mj_w/2.f, vBg.mj_h/2.f);
    [btn setTitle:@"开始游戏" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10.f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = KColorTheme;
    btn.titleLabel.font = [UIFont fontBold:14.f];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [vBg addSubview:btn];
    self.btnAction = btn;
    
    NSNumber *count = (NSNumber *)[PYUserManage py_getObjectWithKey:@"LotteryCount"];
    if (![NSDate isSameDay:(NSDate *)[PYUserManage py_getObjectWithKey:@"LotteryFirstTime"]]) {
        [PYUserManage py_saveObject:[NSDate date] key:@"LotteryFirstTime"];
        count = @5;
        [PYUserManage py_saveObject:count key:@"LotteryCount"];
    }
    
    CGFloat x = space1 + width;
    CGFloat height = (vBg.mj_h - 40 - 2*x)/2.f;
    width = vBg.mj_w - 2*x;
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(x, x, width, height)];
    lab1.textColor = KColorTheme;
    lab1.text = [NSString stringWithFormat:@"当前可用次数：%@",count];
    [vBg addSubview:lab1];
    self.labCount = lab1;
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(btn.frame), width, height)];
    lab2.textColor = [UIColor whiteColor];
    lab2.text = [NSString stringWithFormat:@"当前积分：%@",[PYUserManage py_getPoint]];
    [vBg addSubview:lab2];
    self.labCurrent = lab2;
    
    lab1.font = lab2.font = [UIFont fontNormal:14.f];
    lab1.textAlignment = lab2.textAlignment = NSTextAlignmentCenter;
}

@end
