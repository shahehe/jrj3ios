//
//  AppDelegate.m
//  jrj
//
//  Created by 廖兴旺 on 14/11/23.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "AppDelegate.h"
#import "BctAPI.h"
#import "BNCoreServices.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CLLocationManager *locationManager;

    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
    [locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription

    // Override point for customization after application launch.
    [BctAPI sharedInstance].client = @"21232f297a57a5a743894a0e4a801fc3";
    [BctAPI sharedInstance].clientScert = @"21232f297a57a5a743894a0e4a801fc3";
//    [BctAPI sharedInstance].baseUrl = @"demo.bctid.com/jrj-web/public";
    //http://218.249.192.55/jrj-web/public/
    [BctAPI sharedInstance].baseUrl = @"218.249.192.55/jrj-web/public";
    
    //初始化导航SDK
    [BNCoreServices_Instance initServices:@"51q6V0dnce5Eil6gKEqiNdPf"];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
//    return YES;
//}

@end
