//
//  ShopLocationViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/4/1.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "ShopLocationViewController.h"
#import "Sdk.h"

@interface ShopLocationViewController ()<MKMapViewDelegate, CLLocationManagerDelegate,BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>
@property(nonatomic, strong)MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (assign, nonatomic) BN_NaviType naviType;
@property (assign, nonatomic) double startX;
@property (assign, nonatomic) double startY;
@end

@implementation ShopLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"位置信息";
 
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.delegate = self;

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;

    MKCoordinateSpan span = {0.01,0.01};
    MKCoordinateRegion region = {coordinate,span};
    [self.mapView setRegion:region];
    [self.view addSubview:self.mapView];


    MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
    pinAnnotation.coordinate = coordinate;

    pinAnnotation.title = self.gpsTitle;
//    pinAnnotation.subtitle = self.gpsTitle;

    [self.mapView addAnnotation:pinAnnotation];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000.0f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        [self.locationManager requestAlwaysAuthorization];
    }else{
        [self.locationManager startUpdatingLocation];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    
    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    customPinView.pinColor = MKPinAnnotationColorPurple;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    UIButton* rightButton = [[UIButton alloc] init];
    rightButton.bounds = CGRectMake(0, 0, 30, 20);
    rightButton.layer.cornerRadius = 4;
    rightButton.layer.masksToBounds = YES;
    rightButton.backgroundColor = [UIColor grayColor];
    [rightButton setTitle:@"导航" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton addTarget:self action:@selector(startNavi) forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
    
    return customPinView;
}

- (void)startNavi
{
    NSLog(@"%f----%f------%f----%f",self.latitude,self.longitude,self.startX,self.startY);
    
    if(self.startX == 0){
        [Utils showAlert:@"定位服务未开启"];
    }
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是百度地图坐标
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = self.startX;
    startNode.pos.y = self.startY;
    startNode.pos.eType = BNCoordinate_OriginalGPS;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = self.longitude;
    endNode.pos.y = self.latitude;
    endNode.pos.eType = BNCoordinate_OriginalGPS;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Highway naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}



#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:_naviType delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
}
#pragma mark - locaiton
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                [manager requestAlwaysAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
            [Utils showAlert:@"定位功能无法使用"];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [manager startUpdatingLocation];
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.startX = newLocation.coordinate.longitude;
    self.startY =newLocation.coordinate.latitude;
    
    NSLog(@"%f----%f",self.startX,self.startY);
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    self.startX = location.coordinate.longitude;
    self.startY =location.coordinate.latitude;
//    NSLog(@"%f----%f",self.startX,self.startY);
//    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [manager stopUpdatingLocation];
}

@end
