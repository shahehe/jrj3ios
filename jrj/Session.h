//
//  Session.h
//
//  Created by 廖兴旺 on 14-11-05.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCity.h"

@interface Session : NSObject

@property(nonatomic,assign) int uid;
@property(nonatomic,retain) BCity *city;
@property(nonatomic,retain) UIViewController *suggestionViewController;
@property NSMutableArray *reportsData;

+(Session *) sharedInstance;

+(void)clear;


@end
