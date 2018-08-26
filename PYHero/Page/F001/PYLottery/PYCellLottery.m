//
//  PYCellLottery.m
//  PYHero
//
//  Created by crow on 2018/8/22.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYCellLottery.h"

@interface PYCellLottery()

@property (nonatomic, weak) UILabel *lab;
@property (nonatomic, weak) UIImageView *imgV;

@end

@implementation PYCellLottery

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 12.f - 30.f, 5.f, 30.f, 30.f)];
    imgV.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imgV];
    self.imgV = imgV;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 0, kScreenWidth - 12*3 - 30, 40.f)];
    lab.font = kFont_XL;
    lab.textColor = kColor_Title;
    [self.contentView addSubview:lab];
    self.lab = lab;
}

- (void)setup:(NSArray *)data {
    self.lab.text = [NSString stringWithFormat:@"获得积分：%@",data.firstObject];
    self.imgV.image = [UIImage imageNamed:data.lastObject];
}

@end
