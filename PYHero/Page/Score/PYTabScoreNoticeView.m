//
//  PYTabScoreNoticeView.m
//  PYHero
//
//  Created by Bob Lee on 2018/4/4.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYTabScoreNoticeView.h"

@implementation PYTabScoreNoticeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labShare.font = kFont_Large;
    
    self.imgVIcon.layer.cornerRadius = CGRectGetHeight(self.imgVIcon.frame)/2;
    self.imgVIcon.layer.masksToBounds = YES;
}

- (void)hideNotice {
    if(self.superview==nil)return;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showNotice:(UIView*)supView {
    if(self.superview)return;
    
    self.alpha = 0;
    [supView addSubview:self];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:NULL];
}

- (IBAction)btnClose:(id)sender {
    [self hideNotice];
}

@end
