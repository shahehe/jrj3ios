//
//  MapViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/3/19.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
@property(nonatomic, strong)MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"当前位置";
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
//    self.mapView.delegate = self;
//    
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude = 34.7598711;
//    coordinate.longitude = 113.663221;
//    
//    MKCoordinateSpan span = {100,100};
//    MKCoordinateRegion region = {coordinate,span};
//    [self.mapView setRegion:region];
    [self.view addSubview:self.mapView];
//
//    
//    MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
//    pinAnnotation.coordinate = coordinate;
//    
//    pinAnnotation.title = @"郑州";
//    
//    pinAnnotation.subtitle = @"河南青云信息技术";
//    
//    [self.mapView addAnnotation:pinAnnotation];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000.0f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
    NSLog(@"distance is %f",distance /1000.0);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
    
    NSLog(@"aaaaaaaaaaaaaaaa%f",newLocation.coordinate.latitude);
    MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
    pinAnnotation.coordinate = newLocation.coordinate;

//    pinAnnotation.title = @"";
//
//    pinAnnotation.subtitle = @"";

    [self.mapView addAnnotation:pinAnnotation];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
@end
