//
//  PYVAlertStep.h
//  PYHero
//
//  Created by crow on 2018/8/24.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYVAlertStep : UIView

- (instancetype)initWithType:(NSInteger)type; // type == 0：在时间段内，未兑换, type == 1：不在时间段内, type == 2：已兑换

@end
