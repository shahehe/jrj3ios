//
//  ShopLocationViewController.h
//  jrj
//
//  Created by bct11-macmini on 15/4/1.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

@interface ShopLocationViewController : UIViewController
@property(nonatomic, assign)CGFloat latitude;
@property(nonatomic, assign)CGFloat longitude;
@property(nonatomic, retain)NSString *gpsTitle;
@end
