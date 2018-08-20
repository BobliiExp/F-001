//
//  PYCellShakeNumber.m
//  PYHero
//
//  Created by crow on 2018/8/17.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYCellShakeNumber.h"
#import "PYNumber.h"

@interface PYCellShakeNumber()

@property (nonatomic, strong) NSMutableArray *mArrLabs; ///< 用来装lab
@property (nonatomic, weak) UILabel *labWin; ///< 几等奖

@end

@implementation PYCellShakeNumber

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f, 60.f, 20.f)];
    lab.font = [UIFont fontNormal:13.f];
    lab.textColor = [UIColor redColor];
    [self.contentView addSubview:lab];
    self.labWin = lab;
}

- (void)py_setupData:(NSArray *)arr type:(PYLotteryType)type{
    if (!self.mArrLabs) {
        self.mArrLabs = [NSMutableArray array];
        CGFloat width = 20.f;
        CGFloat space = 10.f;
        NSInteger index = [PYNumber py_getLottoLastZoneIndex:type];
        
        for (NSInteger i = 0; i < arr.count-1; i++) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((self.labWin.mj_x+self.labWin.mj_w) + 10.f + (space + width)*i, (40-width)/2.f, width, width)];
            lab.font = [UIFont fontNormal:13.f];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = [NSString stringWithFormat:@"%02d",[arr[i] intValue]];
            lab.textColor = [UIColor whiteColor];
            lab.backgroundColor = i < index ? [UIColor redColor] : [UIColor blueColor];
            lab.layer.cornerRadius = lab.mj_h/2.f;
            lab.layer.masksToBounds = YES;
            lab.tag = 10+i;
            
            [self.contentView addSubview:lab];
            [self.mArrLabs addObject:lab];
        }
    }else {
        for (NSInteger i = 0; i < self.mArrLabs.count; i++) {
            UILabel *lab = self.mArrLabs[i];
            lab.text = [NSString stringWithFormat:@"%02d",[arr[i] intValue]];
        }
    }
    
    self.labWin.text = arr.lastObject;
}

@end
