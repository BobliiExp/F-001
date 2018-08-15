//
//  PYTabScoreCell.m
//  PYHero
//
//  Created by Bob Lee on 2018/4/4.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYTabScoreCell.h"
#import "NSDate+PYHero.h"
#import "NSDictionary+SafeAccess.h"
#import "UIImage+PYHero.h"

#import <UIImageView+WebCache.h>

#define kImageIconDefault [UIImage getCornerImageFromImage:[UIImage imageNamed:@"ic_avatar_default"] containerFrame:CGRectMake(0, 0, 40, 40) withRadious:5 cornerMask:EImageRadiusTopRight|EImageRadiusBottomLeft]

@implementation PYTabScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 风格统一
    self.labResult.font = kFont_XL;
    self.labResult.textColor = kColor_Normal;
    
    self.labTime.font =
    self.labGameType.font =
    self.labKill.font =
    self.labDeath.font =
    self.labAssist.font = kFont_Normal;
    
    self.labTime.textColor =
    self.labGameType.textColor =
    self.labKill.textColor =
    self.labDeath.textColor =
    self.labAssist.textColor = kColor_Gray;
}

- (void)setupData:(NSDictionary*)dic {
    BOOL result = [dic boolForKey:@"result"];
    self.labResult.text = result ? @"胜利" : @"失败";
    self.labResult.textColor = result ? kColor_Blue : kColor_Red;
    self.labGameType.text = [dic stringForKey:@"gameType"];
    self.labTime.text = [NSDate date2String:[NSDate dateWithTimeIntervalSince1970:[dic integerForKey:@"createdTime"]] formatType:ETimeFormatTimeShortDateTime];
    
    self.labKill.text = [NSString stringWithFormat:@"%ti", [dic integerForKey:@"kill"]];
    self.labDeath.text = [NSString stringWithFormat:@"%ti", [dic integerForKey:@"death"]];
    self.labAssist.text = [NSString stringWithFormat:@"%ti", [dic integerForKey:@"assist"]];
    
    // 头像处理
    @weakify(self);
    [self.imgVIcon sd_setImageWithURL:[NSURL URLWithString:[dic stringForKey:@"urlIcon"]] placeholderImage:kImageIconDefault completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self);
        if(image){
            [self getCornerImage:image frame:self.imgVIcon.frame block:^(UIImage *img) {
                self.imgVIcon.image = img;
                img = nil;
            }];
        }
    }];
}

- (void)getCornerImage:(UIImage*)image frame:(CGRect)frame block:(void(^)(UIImage *img))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *temp = nil;
        @autoreleasepool {
            if(image.size.width>frame.size.width*2 || image.size.height>frame.size.height*2){
                temp = [UIImage adaptToSize:image size:CGSizeMake(frame.size.width*2, frame.size.height*2)];
            }
            
            temp = [UIImage getCornerImageFromImage:image containerFrame:frame withRadious:5 cornerMask:EImageRadiusTopRight|EImageRadiusBottomLeft];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(temp);
        });
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
