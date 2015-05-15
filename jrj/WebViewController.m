//
//  WebViewController.m
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "WebViewController.h"
#import "CheckConnection.h"
#import "YuXianTableViewController.h"
#import "ShopLocationViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for( UIView *view in [self.webView subviews] ) {
        if( [view isKindOfClass:[UIScrollView class]] ) {
            for( UIView *innerView in [view subviews] ) {
                if( [innerView isKindOfClass:[UIImageView class]] ) {
                    innerView.hidden = YES;
                }
            }
        }
    }
    if(self.content != nil){
        [self.webView loadHTMLString:self.content baseURL:nil];
    }else if(self.url != nil){
        if([CheckConnection connected]){
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
        self.webView.ScalesPageToFit = self.scalesPageToFit;
    }
    if(self.isNav == YES){
    self.title = @"详细信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"位置" style:UIBarButtonItemStylePlain target:self action:@selector(gotoAction:)];
    }
}
-(void)gotoAction:(id)sender
{
    ShopLocationViewController *vc = [[ShopLocationViewController alloc] init];
    vc.gpsTitle = self.titles;
    vc.title = self.titles;
    vc.longitude = self.coordinate.longitude;
    vc.latitude = self.coordinate.latitude;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
