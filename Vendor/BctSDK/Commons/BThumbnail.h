//
//  BPaginator.h
//  school-customer
//
//  Created by 廖兴旺 on 14-2-24.
//  Copyright (c) 2014年 廖兴旺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BThumbnail : NSObject

@property(nonatomic,retain) NSString *small;
@property(nonatomic,retain) NSString *medium;
@property(nonatomic,retain) NSString *large;

@property(nonatomic,retain) NSURL *smallUrl;
@property(nonatomic,retain) NSURL *mediumUrl;
@property(nonatomic,retain) NSURL *largeUrl;

+(BThumbnail *) initWithData:(id)data;

@end
