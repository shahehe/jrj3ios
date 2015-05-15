//
//  BPaginator.h
//  school-customer
//
//  Created by 廖兴旺 on 14-2-24.
//  Copyright (c) 2014年 廖兴旺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPaginator : NSObject

@property(nonatomic,assign) int pageCount;
@property(nonatomic,assign) int itemCountPerPage;
@property(nonatomic,assign) int first;
@property(nonatomic,assign) int current;
@property(nonatomic,assign) int last;
@property(nonatomic,assign) int next;
@property(nonatomic,assign) int firstPageInRange;
@property(nonatomic,assign) int lastPageInRange;
@property(nonatomic,assign) int currentItemCount;
@property(nonatomic,assign) int totalItemCount;
@property(nonatomic,assign) int firstItemNumber;
@property(nonatomic,assign) int lastItemNumber;

- (id) initWithData:(id)data;

@end
