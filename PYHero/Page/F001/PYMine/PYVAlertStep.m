//
//  PYVAlertStep.m
//  PYHero
//
//  Created by crow on 2018/8/24.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVAlertStep.h"
#import <CoreMotion/CoreMotion.h>

@interface PYVAlertStep()

@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, weak) UILabel *labContent; ///<
@property (nonatomic, weak) UIButton *btn; ///<

@end

@implementation PYVAlertStep

- (instancetype)initWithType:(NSInteger)type {
    if (self == [super init]) {
        CGFloat width = 270;
        self.frame = CGRectMake(0, 0, width, 0);
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 0, width - 12.f*2, 40)];
        labTitle.textColor = kColor_Title;
        labTitle.text = @"步数兑换";
        labTitle.textAlignment = NSTextAlignmentCenter;
        labTitle.font = kFont_XL;
        [self addSubview:labTitle];
        
        NSString *str = type == 2 ? @"今天已经兑换步数了，请明天再来吧！" : @"";
        UILabel *labContent = [[UILabel alloc] initWithFrame:CGRectMake(12.f, CGRectGetMaxY(labTitle.frame), labTitle.mj_w, 100)];
        labContent.textAlignment = labTitle.textAlignment;
        labContent.font = kFont_Normal;
        labContent.textColor = kColor_Title;
        labContent.numberOfLines = 0;
        labContent.text = str;
        [self addSubview:labContent];
        self.labContent = labContent;
        
        width = 100;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.mj_w - width)/2.f, CGRectGetMaxY(labContent.frame), width, 30)];
        btn.titleLabel.font = kFont_Normal;
        [btn setTitle:@"好的" forState:UIControlStateNormal];
        [btn setTitleColor:kColor_Title forState:UIControlStateNormal];
        btn.layer.borderColor = kColor_Select.CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btn.mj_h/2.f;
        btn.tag = -1;
        [btn addTarget:self action:@selector(btnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.btn = btn;
        
        self.frame = CGRectMake(0, 0, 270, CGRectGetMaxY(btn.frame) + 20);
        
        if (type < 2) {
            [self py_getUserStep:type];
        }
    }
    return self;
}

- (void)btnOnClicked:(UIButton *)btn {
    if (btn.tag != -1) {
        NSInteger point = [PYUserManage py_getPoint].integerValue;
        point += btn.tag/10;
        [PYUserManage py_savePoint:[NSString stringWithFormat:@"%ld",point]];
        
        AlertBlock block = objc_getAssociatedObject(self, @"block_key");
        if (block) {
            block(1,YES);
        }
    }
    
    [AFFAlertView dismiss];
}

- (void)py_getUserStep:(NSInteger)type {
    self.pedometer = [[CMPedometer alloc]init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = (NSDate *)[PYUserManage py_getObjectWithKey:@"ConvertStep"];
    if (!startDate || [self judgeTime:startDate]) {
        startDate = [self getCustomDateWithHour:18 yesterday:YES];
    }
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    //判断记步功能
    if ([CMPedometer isStepCountingAvailable]) {
        [self.pedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    self.labContent.text = @"步数获取失败";
                }else {
                    NSNumber *step = pedometerData.numberOfSteps;
                    
                    if (type == 1) { // 不在时间段内
                        self.labContent.text = [NSString stringWithFormat:@"亲，加油哦，您当前运动步数%@，请于18:00~20:00来兑换吧",step];
                    }else { // 在兑换时间段内
                        if (step.integerValue > 3000) { // 步数可兑换
                            self.labContent.text = [NSString stringWithFormat:@"亲，您当前运动步数%@，可兑换%ld分\n（超过3000步，每10步兑换1分）",step,(step.integerValue - 3000)/10];
                            self.btn.tag = step.integerValue - 3000;
                            [self.btn setTitle:@"收入囊中" forState:UIControlStateNormal];
                        }else { // 步数少于3000，不可兑换
                            self.labContent.text = [NSString stringWithFormat:@"亲，加油哦，您当前运动步数%@，要达到3000步才能兑换哦",step];
                        }
                    }
                }
            });
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labContent.text = @"无法获取步数，请在设置中打开运动与健身权限";
        });
    }
}

- (BOOL)judgeTime:(NSDate *)date {
    NSDate *six = [self getCustomDateWithHour:18 yesterday:YES];
    
    if ([date compare:six] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

- (NSDate *)getCustomDateWithHour:(NSInteger)hour yesterday:(BOOL)yesterday {
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    NSDateComponents *resultComps = [[NSDateComponents alloc]init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:yesterday ? ([currentComps day]-1) : [currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:0];
    [resultComps setSecond:0];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

@end
