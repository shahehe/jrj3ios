//
//  BctApi.m
//  bctid
//
//  Created by 廖兴旺 on 13-9-1.
//  Copyright (c) 2013年 廖兴旺. All rights reserved.
//

#import "BctAPI.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "NSDictionary+RequestEncoding.h"
#import "NSData+SSToolkitAdditions.h"
#import "MKNetworkKit.h"
#import "BctCache.h"

@interface BctAPI()


@property (nonatomic,retain) MKNetworkEngine *engine;

-(MKNetworkEngine *)getMKNetworkEngine;
@end

@implementation BctAPI

static BctAPI *shareInstance = nil;

+(BctAPI *) sharedInstance
{
	if (!shareInstance) {
		shareInstance = [[self alloc]init];
	}
	return shareInstance;
}

+(void)getContent:(NSString *)url data:(NSDictionary *)data success:(void (^)(NSString *))success failure:(void (^)(int, NSString *))failure complete:(void (^)())complete
{
    BctAPI *bct = [BctAPI sharedInstance];
    MKNetworkOperation *o = [bct getMKNetworkOperation:url params:data httpMethod:@"GET"];
    //查询是否已经有数据缓存
    NSString *key = [o.url md5];
    if([BctCache hasObjectForKey:key andType:BCTCacheTypeJSON]){
        id json = [BctCache objectForKey:key andType:BCTCacheTypeJSON];
        NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        if(success) success(str);
        if(complete != nil) complete();
    }
    [o addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@",[completedOperation responseString]);
        //更新缓存
        [BctCache setObject:[completedOperation responseData] forKey:key andType:BCTCacheTypeJSON];
        success([completedOperation responseString]);
        complete();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%ld",(long)[completedOperation HTTPStatusCode]);
        if(failure != nil){
            if([completedOperation HTTPStatusCode] == 0){
                failure(0,@"No Internet Connection");
            }else if([completedOperation HTTPStatusCode] == 500){
                failure(500,@"Service Error!");
            }else{
                failure((int)[completedOperation HTTPStatusCode],[completedOperation responseString]);
            }
        }
        if(complete != nil) complete();
    }];
    NSLog(@"%@",o);
    [bct.engine enqueueOperation:o];
}
+(void)get:(NSString *)url data:(NSDictionary *)data success:(void (^)(id))success failure:(void (^)(int, NSString *))failure complete:(void (^)())complete
{
    BctAPI *bct = [BctAPI sharedInstance];
    MKNetworkOperation *o = [bct getMKNetworkOperation:url params:data httpMethod:@"GET"];
    //查询是否已经有数据缓存
    NSString *key = [o.url md5];
    if([BctCache hasObjectForKey:key andType:BCTCacheTypeJSON]){
        id json = [BctCache JSONObjectForKey:key andType:BCTCacheTypeJSON];
        if(success) success(json);
        if(complete != nil) complete();
    }
    [o addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@",[completedOperation responseString]);
        //更新缓存
        [BctCache setObject:[completedOperation responseData] forKey:key andType:BCTCacheTypeJSON];
        
        success([completedOperation responseJSON]);
        complete();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%ld",(long)[completedOperation HTTPStatusCode]);
        if(failure != nil){
            if([completedOperation HTTPStatusCode] == 0){
                failure(0,@"No Internet Connection");
            }else if([completedOperation HTTPStatusCode] == 500){
                failure(500,@"Service Error!");
            }else{
                failure((int)[completedOperation HTTPStatusCode],[completedOperation responseString]);
            }
        }
        if(complete != nil) complete();
    }];
    NSLog(@"%@",o);
    [bct.engine enqueueOperation:o];

}

+(void)get:(NSString *)url success:(void (^)(id))success failure:(void (^)(int,NSString *))failure complete:(void (^)())complete
{
    BctAPI *bct = [BctAPI sharedInstance];
    MKNetworkOperation *o = [bct getMKNetworkOperation:url params:nil httpMethod:@"GET"];
    [o addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@",[completedOperation responseString]);
        id json = [completedOperation responseJSON];
        success(json);
        complete();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        //NSLog(@"%d",[completedOperation HTTPStatusCode]);
        if(failure != nil){
            if([completedOperation HTTPStatusCode] == 0){
                failure(0,@"No Internet Connection");
            }else if([completedOperation HTTPStatusCode] == 500){
                failure(500,@"Service Error!");
            }else{
                failure((int)[completedOperation HTTPStatusCode],[completedOperation responseString]);
            }
        }
        if(complete != nil) complete();
    }];
    NSLog(@"%@",o);
    [bct.engine enqueueOperation:o];
}

+(void)post:(NSString *)url data:(NSDictionary *)data success:(void (^)(id))success failure:(void (^)(int, NSString *))failure complete:(void (^)())complete
{
    BctAPI *bct = [BctAPI sharedInstance];
    MKNetworkOperation *o = [bct getMKNetworkOperation:url params:data httpMethod:@"POST"];
    [o addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@",[completedOperation responseString]);
        if(success != nil) {
           success([completedOperation responseJSON]);
        }
        if(complete != nil) complete();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if(failure != nil){
            if([completedOperation HTTPStatusCode] == 0){
                failure(0,@"No Internet Connection");
            }else if([completedOperation HTTPStatusCode] == 500){
                failure(500,@"Service Error!");
            }else{
                failure((int)[completedOperation HTTPStatusCode],[completedOperation responseString]);
            }
        }
        if(complete != nil) complete();
    }];
    NSLog(@"%@",o);
    [bct.engine enqueueOperation:o];
}

+(void)put:(NSString *)url data:(NSDictionary *)data success:(void (^)(id))success failure:(void (^)(int,NSString *))failure complete:(void (^)())complete
{
    BctAPI *bct = [BctAPI sharedInstance];
    MKNetworkOperation *o = [bct getMKNetworkOperation:url params:data httpMethod:@"PUT"];
    [o addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@",[completedOperation responseString]);
        success([completedOperation responseJSON]);
        complete();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if(failure != nil){
            if([completedOperation HTTPStatusCode] == 0){
                failure(0,@"No Internet Connection");
            }else if([completedOperation HTTPStatusCode] == 500){
                failure(500,@"Service Error!");
            }else{
                failure((int)[completedOperation HTTPStatusCode],[completedOperation responseString]);
            }
        }
        if(complete != nil) complete();
    }];
    NSLog(@"%@",o);
    [bct.engine enqueueOperation:o];
}

+(void)del:(NSString *)url success:(void (^)(id))success failure:(void (^)(int,NSString *))failure complete:(void (^)())complete
{
    BctAPI *bct = [BctAPI sharedInstance];
    MKNetworkOperation *o = [bct getMKNetworkOperation:url params:nil httpMethod:@"DELETE"];
    [o addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@",[completedOperation responseString]);
        if(success != nil) success([completedOperation responseJSON]);
        if(complete != nil) complete();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if(failure != nil){
            if([completedOperation HTTPStatusCode] == 0){
                failure(0,@"No Internet Connection");
            }else if([completedOperation HTTPStatusCode] == 500){
                failure(500,@"Service Error!");
            }else{
                failure((int)[completedOperation HTTPStatusCode],[completedOperation responseString]);
            }
        }
        if(complete != nil) complete();
    }];
    NSLog(@"%@",o);
    [bct.engine enqueueOperation:o];
}

+(void)upload:(NSData *)file andKey:(NSString *)key andName:(NSString *)name andType:(NSString *)type andModule:(NSString *)module andData:(NSDictionary *)data success:(void (^)(id))success failure:(void (^)(int, NSString *))failure complete:(void (^)())complete uploadProgressChanged:(void (^)(double progress))uploadProgressChanged
{
    NSString *url = [NSString stringWithFormat:@"/files/%@/file",module];
    BctAPI *bct = [BctAPI sharedInstance];
    MKNetworkOperation *o = [bct getMKNetworkOperation:url params:data httpMethod:@"POST"];
    [o addData:file forKey:key mimeType:type fileName:name];
    [o addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@",[completedOperation responseString]);
        if(success != nil) {
            success([completedOperation responseJSON]);
        }
        if(complete != nil) complete();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if(failure != nil){
            if([completedOperation HTTPStatusCode] == 0){
                failure(0,@"No Internet Connection");
            }else{
                failure((int)[completedOperation HTTPStatusCode],[completedOperation responseString]);
            }
        }
        if(complete != nil) complete();
    }];
    [o onUploadProgressChanged:^(double progress) {
        uploadProgressChanged(progress);
    }];
    [bct.engine enqueueOperation:o];
}


+(void)image:(UIImageView *)imageView andUrl:(NSString *)url
{
    if(url == nil || [url length] == 0 ) return;
    //读取缓存数据
    NSString *key = [url md5];
    NSData *data = [BctCache objectForKey:key andType:BCTCacheTypeFile];
    if(data != nil){
        imageView.image = [UIImage imageWithData:data];
    }else{
        MKNetworkEngine *engine = [[MKNetworkEngine alloc] init];
        MKNetworkOperation *o = [engine operationWithURLString:url];
        [o addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSData *data = [completedOperation responseData];
            [BctCache setObject:data forKey:key andType:BCTCacheTypeFile];
            imageView.image = [UIImage imageWithData:data];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            imageView.image = [UIImage imageNamed:@"no_image"];
        }];
        if(o != nil) [engine enqueueOperation:o];
    }
    
}


-(MKNetworkEngine *)getMKNetworkEngine
{
    if(self.engine == nil){
        self.engine = [[MKNetworkEngine alloc] initWithHostName:self.baseUrl];

    }
    return self.engine;
}

-(MKNetworkOperation *)getMKNetworkOperation:(NSString *)url params:(NSDictionary *)params httpMethod:(NSString *)method
{
    MKNetworkOperation *o = nil;
    o = [[self getMKNetworkEngine] operationWithPath:url params:params httpMethod:method];
    [self signature:o];
    return o;
}

-(void)signature:(MKNetworkOperation *)operation
{
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%d%f",self.uid,timestamp];
    NSData* secretData = [self.clientScert dataUsingEncoding:NSUTF8StringEncoding];
    NSData* stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *signatureData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, secretData.bytes, secretData.length, stringData.bytes, stringData.length, signatureData.mutableBytes);
    NSString *sig = [signatureData MD5Sum];
    
    [operation addHeader:@"BCTSIGNATURE" withValue:sig];
    [operation addHeader:@"BCTUID" withValue:[NSString stringWithFormat:@"%d",self.uid]];
    [operation addHeader:@"BCTCLIENT" withValue:self.client];
    [operation addHeader:@"BCTTIMESTAMP" withValue:[NSString stringWithFormat:@"%f",timestamp]];
}
                            

@end
