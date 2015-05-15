//
//  BPaginator.m
//  school-customer
//
//  Created by 廖兴旺 on 14-2-24.
//  Copyright (c) 2014年 廖兴旺. All rights reserved.
//

#import "BPaginator.h"
#import "NSDictionary+SSToolkitAdditions.h"

@implementation BPaginator

-(id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        self.pageCount = [[data safeObjectForKey:@"pageCount"] intValue];
        self.itemCountPerPage = [[data safeObjectForKey:@"itemCountPerPage"] intValue];
        self.first = [[data safeObjectForKey:@"first"] intValue];
        self.current = [[data safeObjectForKey:@"current"] intValue];
        self.last = [[data safeObjectForKey:@"last"] intValue];
        self.next = [[data safeObjectForKey:@"next"] intValue];
        self.firstPageInRange = [[data safeObjectForKey:@"firstPageInRange"] intValue];
        self.lastPageInRange = [[data safeObjectForKey:@"lastPageInRange"] intValue];
        self.currentItemCount = [[data safeObjectForKey:@"currentItemCount"] intValue];
        self.totalItemCount = [[data safeObjectForKey:@"totalItemCount"] intValue];
        self.firstItemNumber = [[data safeObjectForKey:@"firstItemNumber"] intValue];
        self.lastItemNumber = [[data safeObjectForKey:@"lastItemNumber"] intValue];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.first = 1;
        self.last = 1;
        self.next = 1;
    }
    return self;
}

@end
