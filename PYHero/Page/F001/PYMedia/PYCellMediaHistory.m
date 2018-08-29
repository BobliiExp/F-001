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
    UILabel *labTime = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 5, kScreenWidth - 15.f*2, 20)];
    labTime.font = kFont_Normal;
    labTime.textColor = kColor_Title;
    [self.contentView addSubview:labTime];
    self.labTime = labTime;
    
    UILabel *labDuration = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(labTime.frame), (kScreenWidth - 15.f*2)/2.f, 20)];
    labDuration.font = kFont_Normal;
    labTime.textColor = kColor_Title;
    [self.contentView addSubview:labDuration];
    self.labDuration = labDuration;
    
    UILabel *labPoint = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labDuration.frame)+5.f, labDuration.mj_y, labDuration.mj_w, labDuration.mj_h)];
    labPoint.font = kFont_Normal;
    labPoint.textColor = kColor_Title;
    [self.contentView addSubview:labPoint];
    self.labPoint = labPoint;
}

- (void)setupData:(PYModelSaveMedia *)data {
    PYModelAttr *model = [[PYModelAttr alloc] init];
    model.arrText = @[@"开始时间：", data.startTime];
    model.arrFgColor = @[kColor_Title, kColor_Select];
    [self.labTime setAttributedTextWithModel:model];
    
    model = [[PYModelAttr alloc] init];
    model.arrText = @[@"时长：", data.duration];
    model.arrFgColor = @[kColor_Title, kColor_Select];
    [self.labDuration setAttributedTextWithModel:model];
    
    if (!data.beInvited) {
        model = [[PYModelAttr alloc] init];
        model.arrText = @[@"使用积分：", [NSString stringWithFormat:@"%ld",data.point]];
        model.arrFgColor = @[kColor_Title, kColor_Select];
        [self.labPoint setAttributedTextWithModel:model];
    }else {
        self.labPoint.text = @"被邀请，不使用积分";
    }
}

@end
