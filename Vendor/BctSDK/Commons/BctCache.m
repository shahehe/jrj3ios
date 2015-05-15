//
//  BctCache.m
//  jrj
//
//  Created by 廖兴旺 on 14/12/8.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "BctCache.h"

@implementation BctCache

+ (NSString*)directory:(BCTCacheType)type
{
    int uid = 0;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    switch (type) {
        case BCTCacheTypeJSON:
            cacheDirectory = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%djson",uid]];
            break;
        default:
            cacheDirectory = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%dfile",uid]];
            break;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:cacheDirectory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return cacheDirectory;
}

+ (NSString *) filenameForKey:(NSString*)key andType:(BCTCacheType)type
{
    NSString *filename = [[self directory:type] stringByAppendingPathComponent:key];
    return filename;
}

+ (NSData*) objectForKey:(NSString*)key andType:(BCTCacheType)type{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[self directory:type] stringByAppendingPathComponent:key];
    if ([fileManager fileExistsAtPath:filename])
    {
        NSData *data = [NSData dataWithContentsOfFile:filename];
        return data;
    }
    return nil;
}

+ (id) JSONObjectForKey:(NSString*)key andType:(BCTCacheType)type
{
    NSData *data = [BctCache objectForKey:key andType:type];
    if(data != nil){
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(error) NSLog(@"File Package JSON Parsing Error: %@", error);
        if(json != nil){
            return json;
        }
    }
    return nil;
}

+(void)removeObjectForKey:(NSString*)key andType:(BCTCacheType)type{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[self directory:type] stringByAppendingPathComponent:key];
    if ([fileManager fileExistsAtPath:filename])
    {
        [fileManager removeItemAtPath:filename error:nil];
    }
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key andType:(BCTCacheType)type{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[self directory:type] stringByAppendingPathComponent:key];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:[self directory:type] isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:[self directory:type] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSError *error;
    @try {
        [data writeToFile:filename options:NSDataWritingAtomic error:&error];
        NSLog(@"文件保存成功：%d，key:%@",type,key);
        NSLog(@"Path：%@",filename);
    }
    @catch (NSException * e) {
        NSLog(@"文件无法保存");
        //TODO: error handling maybe
    }
}

+ (BOOL) hasObjectForKey:(NSString*)key andType:(BCTCacheType)type
{
    NSString *filename = [[self directory:type] stringByAppendingPathComponent:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"查询缓存 %d,key:%@",type,filename);
    if([fileManager fileExistsAtPath:filename]){
        NSLog(@"文件存在 %d,key:%@",type,key);
        return YES;
    }else{
        NSLog(@"文件不存在 %d,key:%@",type,key);
        return NO;
    }
}

+ (NSArray *) objectListForType:(BCTCacheType)type
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *dir =[self directory:type];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:dir error:&error];
    NSMutableArray *datas = [NSMutableArray array];
    for (NSString *file in fileList) {
        NSString *path = [dir stringByAppendingPathComponent:file];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(error) NSLog(@"File Package JSON Parsing Error: %@", error);
        if(json != nil){
            [datas addObject:json];
        }
    }
    return datas;
}

+ (NSArray *) fileListForType:(BCTCacheType)type
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *dir =[self directory:type];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:dir error:&error];
    NSMutableArray *files = [NSMutableArray array];
    for (NSString *file in fileList) {
        NSString *path = [dir stringByAppendingPathComponent:file];
        [files addObject:path];
    }
    return files;
}

@end
