//
//  PYImgVLottery.m
//  PYHero
//
//  Created by crow on 2018/8/23.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYImgVLottery.h"

@implementation PYImgVLottery

- (instancetype)initWithFrame:(CGRect)frame imgName:(NSString *)imgName point:(NSInteger)point {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        imgV.image = [UIImage imageNamed:imgName];
        imgV.contentMode = UIViewContentModeCenter;
        [self addSubview:imgV];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width-3, frame.size.width, frame.size.height - frame.size.width)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = kColor_Title;
        lab.font = [UIFont fontBold:15.f];
        lab.text = [NSString stringWithFormat:@"%ld",point];
        [self addSubview:lab];
    }
    return self;
}

@end
