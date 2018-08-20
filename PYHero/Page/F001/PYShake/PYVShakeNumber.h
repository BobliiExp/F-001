//
//  PYVShakeNumber.h
//  PYHero
//
//  Created by crow on 2018/8/16.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYVShakeNumber : UITableViewCell

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)arr type:(PYLotteryType)type;
- (void)py_setupData:(NSArray *)arr;

@end
