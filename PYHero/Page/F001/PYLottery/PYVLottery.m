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
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
        [self setup];
    }
    return self;
}

- (void)setup {
    self.mArrImg = [NSMutableArray array];
    CGFloat space1 = 20.f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(space1, space1, self.mj_w-space1*2, self.mj_h-space1*2)];
    view.backgroundColor = [UIColor redColor];
    [self addSubview:view];
    
    space1 = 8.f;
    UIView *vBg = [[UIView alloc] initWithFrame:CGRectMake(space1, space1, view.mj_w-space1*2, view.mj_h-space1*2)];
    vBg.backgroundColor = [UIColor colorWithARGBString:@"#FF5A5E"];
    [view addSubview:vBg];
    
    view.layer.cornerRadius = vBg.layer.cornerRadius = 5.f;
    view.layer.masksToBounds = vBg.layer.masksToBounds = YES;
    
    NSArray *arrImg = @[@"banana",@"melon",@"bananas",@"orange",@"mango",@"seven",@"banana",@"sevens",@"cherry",@"mango",@"VR9",@"cherrys",@"orange",@"mango",@"seven",@"melons",@"mangos",@"cherry",@"VR9",@"orange"];
    
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
}

@end
