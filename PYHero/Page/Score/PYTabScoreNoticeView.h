//
//  PYTabScoreNoticeView.h
//  PYHero
//
//  Created by Bob Lee on 2018/4/4.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYTabScoreNoticeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgVIcon;
@property (weak, nonatomic) IBOutlet UILabel *labShare;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

- (void)hideNotice;
- (void)showNotice:(UIView*)supView;

@end
