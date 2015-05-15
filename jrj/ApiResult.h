//
//  ApiResult.h
//  jrj
//
//  Created by jrj on 13-3-16.
//  Copyright (c) 2013年 jrj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiResult : NSObject

@property id data;

@property BOOL error;

@property int code;

@property NSString *message;

@end
