//
//  Utils.h
//  modelinked
//
//  Created by 廖兴旺 on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h" 

#define IS_PHONE5() ([UIScreen mainScreen].bounds.size.height == 568.0f && [UIScreen mainScreen].scale == 2.f && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IOS_7 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)

@interface Utils : NSObject

+(NSString *)getVersion;

+(NSString *)formatTime:(NSTimeInterval )timeInterval;

+(NSString *)getWeekday:(NSDate *)date;

+(void)showAlert:(NSString *)message;
+(void)showAlertError:(NSString *)message;
+(void)showAlert:(NSString *)title andMessage:(NSString *)message;

+(NSString *)createUUID;

@end
