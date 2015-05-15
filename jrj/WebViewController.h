//
//  WebViewController.h
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WebViewController : UIViewController
@property(nonatomic,assign) BOOL isNav;
@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property(nonatomic,retain) NSString *titles;
@property(nonatomic,retain) NSString *content;
@property(nonatomic,retain) NSString *url;
@property(nonatomic,assign) BOOL scalesPageToFit;
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@end
