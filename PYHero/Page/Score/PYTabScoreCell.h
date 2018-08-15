//
//  PYTabScoreCell.h
//  PYHero
//
//  Created by Bob Lee on 2018/4/4.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYTabScoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgVIcon;
@property (weak, nonatomic) IBOutlet UILabel *labResult;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labGameType;
@property (weak, nonatomic) IBOutlet UILabel *labKill;
@property (weak, nonatomic) IBOutlet UILabel *labDeath;
@property (weak, nonatomic) IBOutlet UILabel *labAssist;

- (void)setupData:(NSDictionary*)dic;

@end
