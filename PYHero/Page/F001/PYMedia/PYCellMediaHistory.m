//
//  PYCellMediaHistory.m
//  PYHero
//
//  Created by crow on 2018/8/26.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYCellMediaHistory.h"

@interface PYCellMediaHistory()

@property (nonatomic, weak) UILabel *labTime;       ///< 开始时间
@property (nonatomic, weak) UILabel *labDuration;   ///< 时长
@property (nonatomic, weak) UILabel *labPoint;      ///< 使用积分

@end

@implementation PYCellMediaHistory

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *labTime = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 5, kScreenWidth - 12.f*2, 20)];
    labTime.font = kFont_Normal;
    labTime.textColor = kColor_Normal;
    [self.contentView addSubview:labTime];
    self.labTime = labTime;
    
    UILabel *labDuration = [[UILabel alloc] initWithFrame:CGRectMake(12.f, CGRectGetMaxY(labTime.frame), (kScreenWidth - 12.f*2)/2.f, 20)];
    labDuration.font = kFont_Normal;
    labTime.textColor = kColor_Normal;
    [self.contentView addSubview:labDuration];
    self.labDuration = labDuration;
    
    UILabel *labPoint = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labDuration.frame)+5.f, labDuration.mj_y, labDuration.mj_w, labDuration.mj_h)];
    labPoint.font = kFont_Normal;
    labPoint.textColor = kColor_Normal;
    [self.contentView addSubview:labPoint];
    self.labPoint = labPoint;
}

- (void)setupData:(PYModelSaveMedia *)data {
    self.labTime.text = [NSString stringWithFormat:@"开始时间：%@",data.startTime];
    self.labDuration.text = [NSString stringWithFormat:@"时长：%@",data.duration];
    
    if (!data.beInvited) {
        self.labPoint.text = [NSString stringWithFormat:@"使用积分：%ld",data.point];
    }else {
        self.labPoint.text = @"被邀请，不使用积分";
    }
}

@end
