//
//  BctApi.h
//  bctid
//
//  Created by 廖兴旺 on 13-9-1.
//  Copyright (c) 2013年 廖兴旺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BctAPI : NSObject

+(BctAPI *) sharedInstance;

@property (nonatomic,retain) NSString *client;
@property (nonatomic,retain) NSString *clientScert;
@property (nonatomic,retain) NSString *domain;
@property (nonatomic,retain) NSString *baseUrl;
@property (nonatomic,assign) int uid;


+(void)getContent:(NSString *)url data:(NSDictionary *)data success:(void (^)(NSString *))success failure:(void (^)(int code, NSString *message))failure complete:(void(^)())complete;

+(void)get:(NSString *)url data:(NSDictionary *)data success:(void (^)(id json))success failure:(void (^)(int code, NSString *message))failure complete:(void(^)())complete;

+(void)get:(NSString *)url success:(void (^)(id json))success failure:(void (^)(int code, NSString *message))failure complete:(void(^)())complete;

+(void)post:(NSString *)url data:(NSDictionary *)data success:(void (^)(id json))success failure:(void (^)(int code,NSString *message))failure complete:(void(^)())complete;

+(void)put:(NSString *)url data:(NSDictionary *)data success:(void (^)(id json))success failure:(void (^)(int code,NSString *message))failure complete:(void(^)())complete;;

+(void)del:(NSString *)url success:(void (^)(id json))success failure:(void (^)(int code,NSString *message))failure complete:(void(^)())complete;

+(void)upload:(NSData *)file andKey:(NSString *)key andName:(NSString *)name  andType:(NSString *)type andModule:(NSString *)module andData:(NSDictionary *)data success:(void (^)(id json))success failure:(void (^)(int code,NSString *message))failure complete:(void(^)())complete uploadProgressChanged:(void(^)(double progress))uploadProgressChanged;

+(void)image:(UIImageView *)imageView andUrl:(NSString *)url;

@end
