//
//  NSDate+PYHero.m
//  PYHero
//
//  Created by Bob Lee on 2018/4/2.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "NSDate+PYHero.h"

@implementation NSDate (PYHero)

+(NSDateFormatter *)formatter {
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
//        [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    });
    
    return formatter;
}

+ (NSString *)currentTimeString:(PYTimeFormatType)type {
    NSDateFormatter *dateFormatter = [NSDate formatter];
    [dateFormatter setDateFormat:[self formatString:type]];
    
    NSString *curTime = [dateFormatter stringFromDate:[NSDate date]];
    
    return curTime;
}

+ (NSString*)formatString:(PYTimeFormatType)type {
    if(type == ETimeFormatTimeDate){
        return @"yyyy-MM-dd";
    }else if(type == ETimeFormatTimeDate_CN){
        return @"yyyy年MM月dd日";
    }
    else if(type == ETimeFormatTimeDateEx)
    {
        return @"yyyy.MM.dd";
    }
    else if(type == ETimeFormatTimeCommon){
        return @"yyyy-MM-dd HH:mm:ss";
    }
    else if(type == ETimeFormatTimeShort){
        return @"yyyy-MM-dd HH:mm";
    }else if(type == ETimeFormatTimeTime){
        return @"HH:mm";
    }else if(type == ETimeFormatTimeYear){
        return @"yyyy";
    }else if(type == ETimeFormatTimeMonth){
        return @"MM";
    }else if(type == ETimeFormatTimeDay){
        return @"dd";
    }else if(type == ETimeFormatTimeHour){
        return @"HH";
    }else if(type == ETimeFormatTimeMinute){
        return @"mm";
    }else if(type == ETimeFormatTimeSecond){
        return @"ss";
    }else if(type == ETimeFormatTimeLong){
        return @"yyyy-MM-dd HH:mm:ss.SSS";
    }else if(type == ETimeFormatTimeMask){
        return @"yyyyMMddHHmmssSSS";
    }else if(type == ETimeFormatTimeShortDate){
        return @"MM-dd";
    }else if(type == ETimeFormatTimeShortDateTime){
        return @"MM-dd HH:mm";
    }else if(type == ETimeFormatTimeShortDateTime_CN){
        return @"M月d日 HH:mm";
    }else if(type == ETimeFormatTimeShortDate_CN){
        return @"M月d日";
    }else if(type == ETimeFormatTimeDateDotSpan){
        return @"yyyy.MM.dd";
    }else if(type == ETimeFormatTimeMonth_CN){
        return @"yyyy年MM月";
    }
    
    return @"yyyy-MM-dd HH:mm";
}

+ (NSString *)date2String:(NSDate *)date formatType:(PYTimeFormatType)type {
    if(date==nil)
        return nil;
    
    NSDateFormatter *dateFormatter = [NSDate formatter];
    [dateFormatter setDateFormat:[self formatString:type]];
    
    NSString *curTime = [dateFormatter stringFromDate:date];
    
    return curTime;
}

+ (NSString *)date2StringWithInterval:(NSInteger)interval {
    return [self date2String:[NSDate dateWithTimeIntervalSince1970:interval]];
}

+ (NSString *)date2String:(NSDate*)date {
    NSString *formatStr = nil;
    
    //1.获取当前时间所在的年月日，时分
    NSString *dateStr = [self currentTimeString:ETimeFormatTimeShort];
    
    NSArray *dateArr = [[dateStr componentsSeparatedByString:@" "][0] componentsSeparatedByString:@"-"];
    NSArray *timeArr = [[dateStr componentsSeparatedByString:@" "][1] componentsSeparatedByString:@":"];
    if(dateArr.count==0 || timeArr.count==0)
        return @"";
    
    NSInteger yearNow = [[dateArr[0] substringFromIndex:2] integerValue],monthNow = [dateArr[1] integerValue],dayNow = [dateArr[2] integerValue];
    //    NSInteger hourNow = [timeArr[0] integerValue],minuteNow = [timeArr[1] integerValue];
    
    
    //2.获取目标时间所在年月日，时分
    dateStr = [self date2String:date formatType:ETimeFormatTimeShort];
    
    dateArr = [[dateStr componentsSeparatedByString:@" "][0] componentsSeparatedByString:@"-"];
    timeArr = [[dateStr componentsSeparatedByString:@" "][1] componentsSeparatedByString:@":"];
    if(dateArr.count==0 || timeArr.count==0)
        return @"";
    
    NSInteger yearTarget = [[dateArr[0] substringFromIndex:2] integerValue],monthTarget = [dateArr[1] integerValue],dayTarget = [dateArr[2] integerValue];
    
    NSInteger hourTarget = [timeArr[0] integerValue],minuteTarget = [timeArr[1] integerValue];
    
    //3.判断是否本年
    if(yearNow>yearTarget){
        if((labs(12-monthTarget+monthNow)>3) || (yearNow-1)>yearTarget){
            formatStr = [NSString stringWithFormat:@"%02ti-%02ti-%02ti",yearTarget,monthTarget,dayTarget];
        }
    }else{
        if(monthNow==monthTarget){
            if(dayNow-2 == dayTarget){
                // 前天
                formatStr = [NSString stringWithFormat:@"前天 %02ti:%02ti", hourTarget, minuteTarget];
            }else if(dayNow-1 == dayTarget){
                // 昨天
                formatStr = [NSString stringWithFormat:@"昨天 %02ti:%02ti", hourTarget, minuteTarget];
            }else if(dayNow == dayTarget){
                // 当天
                formatStr = [NSString stringWithFormat:@"%02ti:%02ti", hourTarget, minuteTarget];
            }
        }
    }
    
    if(formatStr==nil){
        formatStr = [NSString stringWithFormat:@"%02ti-%02ti %02ti:%02ti", monthTarget, dayTarget, hourTarget, minuteTarget];
    }
    
    return formatStr;
}

@end
