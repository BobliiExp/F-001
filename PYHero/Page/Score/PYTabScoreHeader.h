//
//  PYTabScoreHeader.h
//  PYHero
//
//  Created by Bob Lee on 2018/4/3.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYTabScoreHeader : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgVRank;
@property (weak, nonatomic) IBOutlet UIImageView *imgVJob;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIconBig;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIconBigCover;
@property (weak, nonatomic) IBOutlet UILabel *labRank;
@property (weak, nonatomic) IBOutlet UILabel *labCombat;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labUserInfo;
@property (weak, nonatomic) IBOutlet UILabel *labGamecount;
@property (weak, nonatomic) IBOutlet UILabel *labWinRate;
@property (weak, nonatomic) IBOutlet UILabel *labMVP;
@property (weak, nonatomic) IBOutlet UILabel *labWinAppend;
@property (weak, nonatomic) IBOutlet UILabel *labDesc1;
@property (weak, nonatomic) IBOutlet UILabel *labDesc2;
@property (weak, nonatomic) IBOutlet UILabel *labDesc3;
@property (weak, nonatomic) IBOutlet UILabel *labDesc4;
@property (weak, nonatomic) IBOutlet UILabel *labHero;
@property (weak, nonatomic) IBOutlet UILabel *labSkin;
@property (weak, nonatomic) IBOutlet UILabel *labLevel;

/// 数据更新
- (void)setupData:(NSDictionary*)dic;

@end
