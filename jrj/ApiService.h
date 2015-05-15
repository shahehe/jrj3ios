//
//  ApiService.h
//  jrj
//
//  Created by jrj on 13-3-16.
//  Copyright (c) 2013年 jrj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiResult.h"
#import "MKNetworkEngine.h"


#if NS_BLOCKS_AVAILABLE
//typedef void (^SuccessBlock)(BctResultData *data);
//typedef void (^FailureBlock)(BctResultData *data);
//typedef void (^ErrorBlock)(NSError *error);
typedef void (^ApiSuccessBlock)(ApiResult *result);
typedef void (^ApiFailureBlock)(int code,NSString *message);
#endif

@interface ApiService : NSObject

@property NSString* host;
@property Boolean isLogin;
@property int userID;

+(ApiService *) sharedInstance;

+(ApiResult *)parseResult:(id)data;

-(MKNetworkEngine *)getEngine;

+(void)getReportList:(void (^)(ApiResult *result))success andFailure:(void (^)(int code,NSString *message))failure;

+(void)checkUpdate:(void (^)(ApiResult *result))success andFailure:(void (^)(int code,NSString *message))failure;

+(void)getReport:(NSString *)file andSuccess:(void (^)(ApiResult *result))success andFailure:(void (^)(int code,NSString *message))failure;

+(void)setCache:(NSString *)key andData:(id)data;

+(id)getCache:(NSString *)key;

+(void)getProductList:(void (^)(ApiResult *result))success andFailure:(void (^)(int code,NSString *message))failure withUrl:(NSString*) url
;

+(void)checkUpdateForProduct:(void (^)(ApiResult *result))success andFailure:(void (^)(int code,NSString *message))failure withUrl:(NSString*) url
;

+(NSString*) md5:(NSString*) str;
@end
