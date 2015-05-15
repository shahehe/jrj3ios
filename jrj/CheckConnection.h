//
//  CheckConnection.h
//  financialDistrict
//
//  Created by USTB on 13-4-18.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface CheckConnection : NSObject

+ (BOOL) connected;


@end
