//
//  PYTabScoreCurrentCell.m
//  PYHero
//
//  Created by Bob Lee on 2018/4/4.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYTabScoreCurrentCell.h"

@implementation PYTabScoreCurrentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.labCurrent.font = kFont_XL;
    self.labCurrent.textColor = kColor_Normal;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
