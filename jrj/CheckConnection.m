//
//  CheckConnection.m
//  financialDistrict
//
//  Created by USTB on 13-4-18.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import "CheckConnection.h"

@implementation CheckConnection

+ (BOOL) connected{
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
//    if (networkStatus == NotReachable){
//         [self showAlert:@"请检查网络连接"];
//    }
//    return !(networkStatus == NotReachable);
    return true;
}

+ (void) showAlert:(NSString *)messageToDisplay{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:messageToDisplay delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertV performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

@end
