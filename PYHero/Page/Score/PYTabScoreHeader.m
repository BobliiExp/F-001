//
//  PYTabScoreHeader.m
//  PYHero
//
//  Created by Bob Lee on 2018/4/3.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYTabScoreHeader.h"
#import <Masonry.h>

@interface PYTabScoreHeader()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopContraint;

@end

@implementation PYTabScoreHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerTopContraint.constant = -kCurrentStatusBarHeight;
    
    CGRect frame = self.frame;
    frame.size.height = 270+kCurrentStatusBarHeight;
    self.frame = frame;
    
    [self setupUI];
}

- (instancetype)init {
    self = [super init];
    if(self){
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.backgroundColor = kColor_Graylight;
    
    // tableview header
    self.imgVIconBig.layer.cornerRadius = CGRectGetHeight(self.imgVIconBig.frame)/2;
    self.imgVIconBig.layer.masksToBounds = YES;
    
    self.labRank.textColor =
    self.labCombat.textColor =
    self.labGamecount.textColor =
    self.labWinRate.textColor =
    self.labMVP.textColor =
    self.labWinAppend.textColor = kColor_HighLight;
    
    self.labRank.font =
    self.labCombat.font = kFont_Normal;
    
    self.labGamecount.font =
    self.labWinRate.font =
    self.labMVP.font =
    self.labWinAppend.font = kFont_Large;
    
    self.labDesc1.textColor =
    self.labDesc2.textColor =
    self.labDesc3.textColor =
    self.labDesc4.textColor =  kColor_Gray;
    
    self.labDesc1.font =
    self.labDesc2.font =
    self.labDesc3.font =
    self.labDesc4.font =  kFont_Small;
    
    self.labName.textColor = kColor_Normal;
    self.labName.font = kFont_XL;
    self.labUserInfo.textColor = kColor_Gray;
    self.labUserInfo.font = kFont_Normal;
    
    self.labHero.font =
    self.labSkin.font =
    self.labLevel.font = kFont_XL;
    
    self.labHero.textColor =
    self.labSkin.textColor =
    self.labLevel.textColor = kColor_Normal;
}

- (void)setupData:(NSDictionary*)dic {
    NSInteger total = 79;
    NSString *value = @"1";
    NSString *desc = [NSString stringWithFormat:@"英雄 %@/%ti", value, total];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:desc];
    [attrString addAttributes:@{NSForegroundColorAttributeName:kColor_HighLight} range:NSMakeRange(3, value.length)];
    self.labHero.attributedText = attrString;
    
    total = 181;
    value = @"0";
    desc = [NSString stringWithFormat:@"皮肤 %@/%ti", value, total];
    attrString = [[NSMutableAttributedString alloc] initWithString:desc];
    [attrString addAttributes:@{NSForegroundColorAttributeName:kColor_HighLight} range:NSMakeRange(3, value.length)];
    self.labSkin.attributedText = attrString;
    
    value = @"1";
    desc = [NSString stringWithFormat:@"铭文 %@ 级", value];
    attrString = [[NSMutableAttributedString alloc] initWithString:desc];
    [attrString addAttributes:@{NSForegroundColorAttributeName:kColor_HighLight} range:NSMakeRange(3, value.length)];
    self.labLevel.attributedText = attrString;
}

@end
