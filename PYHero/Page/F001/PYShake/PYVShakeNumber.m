//
//  PYVShakeNumber.m
//  PYHero
//
//  Created by crow on 2018/8/16.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVShakeNumber.h"

@implementation PYVShakeNumber{
    PYLotteryType _type;
}

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)arr type:(PYLotteryType)type {
    if (self == [super initWithFrame:frame]) {
        self.frame = frame;
        _type = type;
        
        NSArray *arrData = [NSArray array];
        if (arr.count) {
            arrData = arr;
        }else {
            if (type == PYLotteryTypeLecaGreati) {
                arrData = @[@"",@"",@"",@"",@"",@"",@"",@""];
            }else if (type == PYLotteryTypeSuperLotto) {
                arrData = @[@"",@"",@"",@"",@"",@"",@""];
            }else {
                arrData = @[@"",@"",@"",@"",@"",@"",@""];
            }
        }
        [self setup:arrData];
    }
    return self;
}

- (void)setup:(NSArray *)arr {
    NSInteger count = arr.count;
    CGFloat margin = 20;
    CGFloat width = 30;
    CGFloat height = width;
    CGFloat space = (self.mj_w-width*count-2*margin)/((CGFloat)(count-1));
    CGFloat y = (CGRectGetHeight(self.frame) - height)/2.f;
    
    // 后区号码
    NSInteger index = count;
    if (_type == PYLotteryTypeLecaGreati) {
        index = count-1;
    }else if (_type == PYLotteryTypeSuperLotto) {
        index = count-2;
    }else {
        index = count-1;
    }
    for (NSInteger i = 0; i < count; i++) {
        NSString *str = arr[i];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(margin + (width+space)*i, y, width, height)];
        lab.tag = 100+i;
        lab.text = KTwoNumber(str);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = kFont_Large;
        lab.textColor = i >= index ? [UIColor blueColor] : [UIColor redColor];
        
        lab.layer.cornerRadius = height/2.f;
        lab.layer.masksToBounds = YES;
        lab.layer.borderWidth = 1.f;
        lab.layer.borderColor = i >= index ? kColor_Select.CGColor : [UIColor redColor].CGColor;
        [self.contentView addSubview:lab];
    }
}

- (void)py_setupData:(NSArray *)arr {
    for (NSInteger i = 0; i<arr.count; i++) {
        NSString *str = arr[i];
        UILabel *lab = [self.contentView viewWithTag:i+100];
        lab.text = KTwoNumber(str);
    }
}

@end
