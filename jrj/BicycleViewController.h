//
//  BicycleViewController.h
//  jrj
//
//  Created by bct11-macmini on 15/2/3.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

@interface BicycleViewController : UIViewController<MKMapViewDelegate,BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate,CLLocationManagerDelegate>

@property (nonatomic, retain)NSArray *data;
@property (retain, nonatomic)CLLocationManager *locationManager;
@property (assign, nonatomic) double startX;
@property (assign, nonatomic) double startY;
@property(nonatomic,assign) CLLocationCoordinate2D gps;
@property (assign, nonatomic) BN_NaviType naviType;
@end
