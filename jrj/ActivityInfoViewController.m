//
//  ActivityInfoViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/1/27.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "ActivityInfoViewController.h"
#import "ShopLocationViewController.h"

@interface ActivityInfoViewController ()

@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;
@property(nonatomic,retain)UIWebView *webView;
- (IBAction)playTel;
@end

@implementation ActivityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    
    self.titleLabel.text = [self.data objectForKey:@"title"];
    self.addLabel.text = [NSString stringWithFormat:@"地址：%@",[self.data objectForKey:@"summary"]];
    self.telLabel.text = [NSString stringWithFormat:@"联系电话：%@",[self.data objectForKey:@"author"]];
    
    self.latitude = [[self.data objectForKey:@"latitude"] floatValue];
    self.longitude = [[self.data objectForKey:@"longitude"] floatValue];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"位置" style:UIBarButtonItemStylePlain target:self action:@selector(gotoAction:)];
}

- (void)gotoAction:(id)sender
{
    ShopLocationViewController *vc = [[ShopLocationViewController alloc] init];
    vc.latitude = self.latitude;//39.923195;
    vc.longitude = self.longitude;//116.371117;
    
    NSString *str = [self.data objectForKey:@"title"];
    if (str.length>=11) {
        str = [NSString stringWithFormat:@"%@...",[str substringToIndex:11]];
    }
    vc.title = str;
    vc.gpsTitle = str;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)playTel {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[self.data objectForKey:@"author"]]]]];
    NSLog(@"%@",[self.data objectForKey:@"author"]);
}
@end
