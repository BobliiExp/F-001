//
//  NSDate+PYHero.h
//  PYHero
//
//  Created by Bob Lee on 2018/4/2.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * TimeFormatType
 * 说明
 */
typedef NS_ENUM(char, PYTimeFormatType) {
    /** yyyy-MM-dd */
    ETimeFormatTimeDate, //日期
    /** yyyy年MM月dd日 */
    ETimeFormatTimeDate_CN,
    /** yyyy.MM.dd */
    ETimeFormatTimeDateEx, //日期
    /** yyyy-MM-dd hh:mm:ss */
    ETimeFormatTimeCommon,//普通
    /** yyyy-MM-dd hh:mm */
    ETimeFormatTimeShort, //
    /** yyyy-MM-dd hh:mm:ss SSS */
    ETimeFormatTimeLong, //
    /** yyyyMMddhhmmSSS */
    ETimeFormatTimeMask, //
    /** hh:mm */
    ETimeFormatTimeTime, //
    /** hh */
    ETimeFormatTimeHour,
    /** mm */
    ETimeFormatTimeMinute,
    /** yyyy */
    ETimeFormatTimeYear,
    /** MM */
    ETimeFormatTimeMonth,
    /** yyyy年MM月 */
    ETimeFormatTimeMonth_CN,
    /** dd */
    ETimeFormatTimeDay,
    /** SSS */
    ETimeFormatTimeSecond,
    /** MM-dd */
    ETimeFormatTimeShortDate,
    /** MM-dd hh:mm */
    ETimeFormatTimeShortDateTime,
    /** MM月dd日 hh:mm */
    ETimeFormatTimeShortDateTime_CN,
    /** MM月dd日 */
    ETimeFormatTimeShortDate_CN,
    
    // 特殊格式
    
    /** yyyy.MM.dd */
    ETimeFormatTimeDateDotSpan
    
    
} ;

@interface NSDate (PYHero)

+ (NSString *)currentTimeString:(PYTimeFormatType)type;
+ (NSString*)formatString:(PYTimeFormatType)type;
+ (NSString *)date2String:(NSDate*)date;
+ (NSString *)date2StringWithInterval:(NSInteger)interval;
+ (NSString *)date2String:(NSDate *)date formatType:(PYTimeFormatType)type;

@end
