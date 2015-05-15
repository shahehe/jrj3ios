//
//  BPaginator.m
//  school-customer
//
//  Created by 廖兴旺 on 14-2-24.
//  Copyright (c) 2014年 廖兴旺. All rights reserved.
//

#import "BThumbnail.h"
#import "NSDictionary+SSToolkitAdditions.h"

@implementation BThumbnail

+(BThumbnail *)initWithData:(id)data
{
    BThumbnail *obj = [[BThumbnail alloc] init];
    if([data isKindOfClass:[NSDictionary class]]){
        obj.small = [data safeObjectForKey:@"small"];
        obj.medium = [data safeObjectForKey:@"medium"];
        obj.large = [data safeObjectForKey:@"large"];
        if(obj.small != nil) obj.smallUrl = [NSURL URLWithString:obj.small];
        if(obj.medium != nil) obj.mediumUrl = [NSURL URLWithString:obj.medium];
        if(obj.large != nil) obj.largeUrl = [NSURL URLWithString:obj.large];

    }
    return obj;
}

@end
