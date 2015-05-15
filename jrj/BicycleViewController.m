//
//  BicycleViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/2/3.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "BicycleViewController.h"
#import "Sdk.h"
#import "CustomAnnotation.h"

@interface BicycleViewController ()

@property (nonatomic, strong)CustomAnnotation *annotation;
@property (nonatomic, retain)NSMutableArray *mutableData;
@property (nonatomic, retain)NSMutableDictionary *mutableDict;
@property (nonatomic, strong)MKMapView *map;


@end

@implementation BicycleViewController

- (NSMutableArray *)mutableData
{
    if (_mutableData == nil) {
        _mutableData =[NSMutableArray array];
    }
    return _mutableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公租自行车";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近网点" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 1000.0f;
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        [self.locationManager requestAlwaysAuthorization];
    }else{
        [self.locationManager startUpdatingLocation];
    }
    self.map = [[MKMapView alloc] initWithFrame:[self.view bounds]];
    self.map.mapType = MKMapTypeStandard;
    self.map.delegate = self;
    [self.view addSubview:self.map];
    
    
    self.mutableDict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i<self.data.count-1; i++) {
        CGFloat latitude = [[self.data[i] objectForKey:@"latitude"] floatValue];
        CGFloat longitude = [[self.data[i] objectForKey:@"longitude"] floatValue];
        NSString *title = [self.data[i] objectForKey:@"name"];
        NSString *subtitle = [self.data[i] objectForKey:@"content"];
        
        if (title.length>=12) {
            title = [NSString stringWithFormat:@"%@...",[title substringToIndex:12]];
        }
        
//        subtitle = [[subtitle componentsSeparatedByString:@";"] lastObject];
        
        NSLog(@"%f-----%f---%@----%@",latitude,longitude,title,subtitle);
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latitude,longitude);
        float zoomLevel = 0.03;
        MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
        [self.map setRegion:[self.map regionThatFits:region] animated:YES];
        [self createAnnotationWithCoords:coords withTitle:title andSubtitle:subtitle];
    }
    
    [self getDistance];
}

- (void)getDistance
{
    for (int i = 0; i<self.data.count-1; i++) {
        CGFloat latitude = [[self.data[i] objectForKey:@"latitude"] floatValue];
        CGFloat longitude = [[self.data[i] objectForKey:@"longitude"] floatValue];
        if (latitude != 0 || longitude != 0 ) {
//            NSLog(@"%f-----%f",latitude,longitude);
            //第一个坐标
            CLLocation *current=[[CLLocation alloc] initWithLatitude:self.startX longitude:self.startY];
            //第二个坐标
            CLLocation *before=[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            // 计算距离
            CLLocationDistance meters = [current distanceFromLocation:before];
//            NSLog(@"----%f",meters);
            self.mutableDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.data[i],@"info",@(meters),@"meters", nil];
            [self.mutableData addObject:self.mutableDict];
        }
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"meters" ascending:YES]];
    [self.mutableData sortUsingDescriptors:sortDescriptors];
    //    NSLog(@"排序后的数组%@",self.mutableData);
}

- (void)btnClick
{
    [self.map removeOverlays:self.map.overlays];
    [self.map removeAnnotations:self.map.annotations];
//    [self getDistance];
    for (int i = 0; i<5; i++) {
        id data = [self.mutableData[i] objectForKey:@"info"];
//        NSLog(@"排序后的数组%@",self.mutableData[i]);
       
        CGFloat latitude = [[data objectForKey:@"latitude"] floatValue];
        CGFloat longitude = [[data objectForKey:@"longitude"] floatValue];
        NSString *title = [data objectForKey:@"name"];
        NSString *subtitle = [data objectForKey:@"content"];
        if (title.length>=12) {
            title = [NSString stringWithFormat:@"%@...",[title substringToIndex:12]];
        }
//        subtitle = [[subtitle componentsSeparatedByString:@";"] lastObject];
        NSLog(@"%f-----%f",latitude,longitude);
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latitude,longitude);
        float zoomLevel = 0.01;
        MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
        [self.map setRegion:[self.map regionThatFits:region] animated:YES];
        [self createAnnotationWithCoords:coords withTitle:title andSubtitle:subtitle];
    }
}

- (void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords withTitle:(NSString *)title andSubtitle:(NSString *)subtitle{
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:
                                    coords];
    annotation.title = title;
    annotation.subtitle = subtitle;
    [self.map addAnnotation:annotation];
//    [map selectAnnotation:annotation animated:YES];
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.annotation = view.annotation;
    NSLog(@"%f-----%f",self.annotation.coordinate.latitude,self.annotation.coordinate.longitude);
}

- (void)startNavi
{
    NSLog(@"%f---a--%f",self.annotation.coordinate.latitude,self.annotation.coordinate.longitude);
    
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
    endNode.pos.x = self.annotation.coordinate.longitude;
    endNode.pos.y = self.annotation.coordinate.latitude;
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
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    self.startX = location.coordinate.longitude;
    self.startY =location.coordinate.latitude;
    //[self startNavi];
    [manager stopUpdatingLocation];
}

//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    [Utils showAlert:@"定位无法使用"];
//}
@end
