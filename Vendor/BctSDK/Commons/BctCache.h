//
//  BctCache.h
//  jrj
//
//  Created by 廖兴旺 on 14/12/8.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BCTCacheTypeJSON = 0,
    BCTCacheTypeFile = 1,
} BCTCacheType;

@interface BctCache : NSObject
//保存一个对象
+ (void) setObject:(NSData*)data forKey:(NSString*)key andType:(BCTCacheType) type;
//取出一个对象
+ (NSData *) objectForKey:(NSString*)key andType:(BCTCacheType)type;
+ (id) JSONObjectForKey:(NSString*)key andType:(BCTCacheType)type;
//移除一个对象
+ (void) removeObjectForKey:(NSString*)key andType:(BCTCacheType)type;
//生成文件名
+ (NSString *) filenameForKey:(NSString*)key andType:(BCTCacheType)type;
//获取一个文件下的所有文件数据
+ (NSArray *) objectListForType:(BCTCacheType)type;

//获取一个文件下的所有文件数据
+ (NSArray *) fileListForType:(BCTCacheType)type;

//判断一个文件是否存在
+ (BOOL) hasObjectForKey:(NSString*)key andType:(BCTCacheType)type;

@end
