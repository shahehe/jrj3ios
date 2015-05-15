//
//  Utils.m
//  modelinked
//
//  Created by 廖兴旺 on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@implementation Utils

+(NSString *)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@.%@",app_Version,app_build];
}

+(NSString *)formatTime:(NSTimeInterval )times
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = @"刚刚";
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }else{
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        result = [df stringFromDate:date];
    }
//    else if((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%ld月前",temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前",temp];
//    }
    return  result;
}

+(NSString *)getWeekday:(NSDate *)date
{
    int day = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
    switch (day) {
        case 1:
            return @"周一";
        case 2:
            return @"周二";
        case 3:
            return @"周三";
        case 4:
            return @"周四";
        case 5:
            return @"周五";
        case 6:
            return @"周六";
        case 7:
            return @"周日";
    }
    NSLog(@"%d",day);
    return @"";
}

+(void)showAlert:(NSString *)message
{
    [Utils showAlert:nil andMessage:message];
}
+(void)showAlertError:(NSString *)message
{
    [Utils showAlert:@"Error" andMessage:message];
}

+(void)showAlert:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}

+(NSString *)createUUID
{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}

@end
