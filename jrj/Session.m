//
//  Session.m
//  yjhabit
//
//  Created by 廖兴旺 on 14-4-2.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "Session.h"

@implementation Session

static Session *shareInstance = nil;

+(Session *) sharedInstance
{
	if (!shareInstance) {
		shareInstance = [[self alloc]init];
        shareInstance.reportsData = [NSMutableArray arrayWithCapacity:0];
        //读取用户数据
	}
	return shareInstance;
}

+(void)clear
{
    [Session sharedInstance].uid = 0;
}
@end
