//
//  ApiService.m
//  jrj
//
//  Created by jrj on 13-3-16.
//  Copyright (c) 2013年 jrj. All rights reserved.
//

#import "ApiService.h"
#import <commoncrypto/CommonDigest.h>

@interface ApiService ()

@property MKNetworkEngine *engine;

@end

@implementation ApiService

static ApiService *shareInstance = nil;

+(ApiService *) sharedInstance
{
	if (!shareInstance) {
		shareInstance = [[self alloc]init];
        shareInstance.host = @"218.249.192.55";
        shareInstance.isLogin = false;
        shareInstance.userID = -1;
	}
	return shareInstance;
}

-(MKNetworkEngine *)getEngine
{
    if(self.engine == nil){
        self.engine = [[MKNetworkEngine alloc] initWithHostName:self.host];
    }
    return self.engine;
}

+(void)getReportList:(void (^)(ApiResult *))success andFailure:(void (^)(int, NSString *))failure
{
    NSString *url = [[NSString alloc] init];
    if([ApiService sharedInstance].isLogin == false){
        url = @"jrj/index.php?file=list.xml";
    }   
    else{
        url = [NSString stringWithFormat:@"jrj/index.php?file=list.xml&uid=%d",[ApiService sharedInstance].userID];               
    }
    
    //NSLog(@"%d",[ApiService sharedInstance].userID);
    NSString *key = [ApiService md5:url];
    //先从缓存取数据:
    id data = [ApiService getCache:key];
    if(data != nil){
        ApiResult *result = [ApiService parseResult:data];
        success(result);
    }else{
        //重新取得数据
        MKNetworkEngine *engine = [[ApiService sharedInstance] getEngine];
        MKNetworkOperation *op = [engine operationWithPath:url];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            //NSLog(@"responeString: %@", [completedOperation responseString]);
            //保存到缓存
            [ApiService setCache:key andData:[completedOperation responseJSON]];
            ApiResult *result = [ApiService parseResult:[completedOperation responseJSON]];
            success(result);
            //NSLog(@"%@",[completedOperation responseString]);
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",[completedOperation responseString]);
            //ApiResult *result = [ApiService parseResult:completedOperation];
            failure(0,@"网络错误");
        }];
        [engine enqueueOperation:op];
    }
    
    
    
}

+(void)checkUpdate:(void (^)(ApiResult *))success andFailure:(void (^)(int, NSString *))failure
{
    NSString *url = [[NSString alloc] init];
    if([ApiService sharedInstance].isLogin == false){
        url = @"jrj/index.php?file=list.xml";
    }
    else{
        url = [NSString stringWithFormat:@"jrj/index.php?file=list.xml&uid=%d",[ApiService sharedInstance].userID];
    }
    //NSLog(@"%d",[ApiService sharedInstance].userID);
    NSString *key = [ApiService md5:url];
    //获取数据 进行对比
    MKNetworkEngine *engine = [[ApiService sharedInstance] getEngine];
    MKNetworkOperation *op = [engine operationWithPath:url];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        //取得缓存数据
        //先从缓存取数据:
        id data = [ApiService getCache:key];
        if(data != nil){
            //进行对比
            NSString *old = [ApiService md5:[NSString stringWithFormat:@"%@",[completedOperation responseJSON]]];
            NSString *new = [ApiService md5:[NSString stringWithFormat:@"%@",data]];
            if(![old isEqualToString:new]){
                //保存到缓存
                [ApiService setCache:key andData:[completedOperation responseJSON]];
                ApiResult *result = [ApiService parseResult:[completedOperation responseJSON]];
                NSLog(@"更新缓存");
                success(result);
            }else{
                failure(1,@"");
                NSLog(@"不用更新缓存");
            }
        
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",[completedOperation responseString]);
        //ApiResult *result = [ApiService parseResult:completedOperation];
        failure(0,@"网络错误");
    }];
    [engine enqueueOperation:op];
    

}

+(void)getReport:(NSString *)file andSuccess:(void (^)(ApiResult *))success andFailure:(void (^)(int, NSString *))failure
{
    NSString *url = [NSString stringWithFormat:@"jrj/index.php?file=%@",file];
    NSString *key = [ApiService md5:url];
    //先从缓存取数据
    id data = [ApiService getCache:key];
    if(data != nil){
        ApiResult *result = [ApiService parseResult:data];
        success(result);
    }else{
        MKNetworkEngine *engine = [[ApiService sharedInstance] getEngine];
        MKNetworkOperation *op = [engine operationWithPath:url];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSLog(@"responeString: %@", [completedOperation responseString]);
            //保存到缓存
            [ApiService setCache:key andData:[completedOperation responseJSON]];
            ApiResult *result = [ApiService parseResult:[completedOperation responseJSON]];
            success(result);
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",[completedOperation responseString]);
            failure(0,@"网络错误");
        }];
        [engine enqueueOperation:op];
    }
}


+(void)getProductList:(void (^)(ApiResult *))success andFailure:(void (^)(int, NSString *))failure withUrl:(NSString*) url
{
    //NSString *url = @"Product.getList";
    NSString *key = [ApiService md5:url];
    //先从缓存取数据:
    id data = [ApiService getCache:key];
    if(data != nil){
        ApiResult *result = [[ApiResult alloc] init];
        result.code = 1;
        result.data = data;
        success(result);
    }else{
        //重新取得数据
        MKNetworkEngine* engine = [[ApiService sharedInstance] getMKNetworkEngine];
        MKNetworkOperation* op = [[ApiService sharedInstance] getMKnetworkOperation:engine andMethod:url andParams:nil];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            //保存到缓存
            id json = [completedOperation responseJSON];
            [ApiService setCache:key andData:[json objectForKey:@"result"]];
            
            ApiResult *result = [[ApiResult alloc] init];
            result.code = 1;
            result.data = [json objectForKey:@"result"];
            success(result);
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            failure(0,nil);
        }];
        [engine enqueueOperation:op];
    }
}
+(void)checkUpdateForProduct:(void (^)(ApiResult *))success andFailure:(void (^)(int, NSString *))failure withUrl:(NSString*) url

{
    //NSString *url = @"Product.getList";
    NSString *key = [ApiService md5:url];
    //获取数据 进行对比
    MKNetworkEngine* engine = [[ApiService sharedInstance] getMKNetworkEngine];
    MKNetworkOperation* op = [[ApiService sharedInstance] getMKnetworkOperation:engine andMethod:url andParams:nil];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        //取得缓存数据
        //先从缓存取数据:
        id data = [ApiService getCache:key];
        if(data != nil){
            id json = [completedOperation responseJSON];
            //进行对比
            NSString *old = [ApiService md5:[NSString stringWithFormat:@"%@",[json valueForKey:@"result"]]];
            NSString *new = [ApiService md5:[NSString stringWithFormat:@"%@",data]];
            if(![old isEqualToString:new]){
                //保存到缓存
                [ApiService setCache:key andData:[json valueForKey:@"result"]];
                ApiResult *result = [[ApiResult alloc] init];
                result.code = 1;
                result.data = [json objectForKey:@"result"];
                NSLog(@"更新缓存");
                success(result);
            }else{
                failure(1,@"");
                NSLog(@"不用更新缓存");
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        failure(0,nil);
    }];
    [engine enqueueOperation:op];
}

-(MKNetworkOperation *)getMKnetworkOperation:(MKNetworkEngine *)engine andMethod:(NSString *)method andParams:(NSArray *)params
{
    if(params == nil) params = [NSArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
	[dic setObject:method forKey:@"method"];
	[dic setObject:params forKey:@"params"];
	[dic setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"id"];
    [dic setObject:@"2.0" forKey:@"jsonrpc"];
    
    MKNetworkOperation *o = [engine operationWithPath:@"jrj/api.php" params:dic httpMethod:@"POST"];
    [o setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    NSLog(@"params:%@",dic);
    NSLog(@"URL:%@",o.url);
    return o;
}
-(MKNetworkEngine *)getMKNetworkEngine
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:self.host];
    return engine;
}

+(ApiResult *)parseResult:(id)data
{
    ApiResult *result = [[ApiResult alloc] init];
    @try {
        result.code = [[data valueForKey:@"code"] intValue];
        id error = [data valueForKey:@"error"];
        if(error == nil){
            result.data = [data objectForKey:@"data"];
            result.error = NO;
        }else{
            result.error = YES;
            result.message = [data objectForKey:@"error"];
        }
    }
    @catch (NSException *exception) {
        result.error = YES;
        result.message = @"数据解析错误！";
    }
    @finally {
        return result;
    }
}

+(void)setCache:(NSString *)key andData:(id)data
{
    //文件名
    //NSString *md5 = [self md5:key];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // the path to write file
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    //保存到缓存
    NSMutableDictionary *dict = [[NSMutableDictionary  alloc] initWithContentsOfFile:filePath];
    if(dict == nil){
        dict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    [dict setObject:data forKey:key];
    [dict writeToFile:filePath atomically:YES];
}

+(id)getCache:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // the path to write file
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    //保存到缓存
    NSMutableDictionary *dict = [[NSMutableDictionary  alloc] initWithContentsOfFile:filePath];
    id json = [dict objectForKey:key];
    NSLog(@"%@",[json class]);
    if(json){
        return json;
         //[NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
    }else{
        //return json;
    }
    return nil;
}

+(NSString*) md5:(NSString*) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

