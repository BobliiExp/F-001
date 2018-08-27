//
//  PYVLottery.h
//  PYHero
//
//  Created by crow on 2018/8/19.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYVLottery : UIView

@property (nonatomic, strong) NSMutableArray *mArrImg;
@property (nonatomic, strong) NSArray *arrImgName;    ///< 图片名称
@property (nonatomic, weak) UIButton *btnAction; ///< 开始按钮
@property (nonatomic, weak) UILabel *labCurrent; ///< 当前lab
@property (nonatomic, weak) UILabel *labCount; ///< 当前获得的

@end
