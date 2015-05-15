//
//  shopInfoViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/1/15.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "shopInfoViewController.h"
#import "Sdk.h"
#import "ShopLocationViewController.h"

@interface shopInfoViewController ()
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;
- (IBAction)playTel;
@property(nonatomic,retain)UIWebView *webView;
@end

@implementation shopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
 
    self.latitude = [[self.data objectForKey:@"latitude"] floatValue];
    self.longitude = [[self.data objectForKey:@"longitude"] floatValue];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"位置" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    
    [self loadData];
}

- (void)btnClick
{
    ShopLocationViewController *vc = [[ShopLocationViewController alloc] init];
    vc.latitude = self.latitude;//39.923195;
    vc.longitude = self.longitude;//116.371117;
    
    NSString *str = [self.data objectForKey:@"title"];
    if (str.length>=12) {
        str = [NSString stringWithFormat:@"%@...",[str substringToIndex:12]];
    }
    vc.title = [self.data objectForKey:@"title"];
    vc.gpsTitle = str;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    UILabel *shopTitle = (UILabel *)[self.view viewWithTag:1];
    shopTitle.text = [NSString stringWithFormat:@"商铺名称：%@",[self.data objectForKey:@"title"]];
    
//    UIImageView *iconView = (UIImageView *)[self.view viewWithTag:2];
//    [BctAPI image:iconView andUrl:[self.data objectForKey:@"image"]];
 
    UILabel *shopStreet = (UILabel *)[self.view viewWithTag:3];
    shopStreet.text = [NSString stringWithFormat:@"所属街道：%@",[self.data objectForKey:@"copyright"]];
    
    UILabel *shopAdd = (UILabel *)[self.view viewWithTag:4];
    shopAdd.text = [NSString stringWithFormat:@"地址：%@",[self.data objectForKey:@"summary"]];
    
    UILabel *shopTel = (UILabel *)[self.view viewWithTag:5];
    shopTel.text = [NSString stringWithFormat:@"联系电话：%@",[self.data objectForKey:@"author"]];
    
    UIWebView *shopInfo = (UIWebView *)[self.view viewWithTag:6];
//    shopInfo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];-
    shopInfo.opaque=NO;
    [shopInfo loadHTMLString:[NSString stringWithFormat:@"详细内容：%@",[self.data objectForKey:@"content"]] baseURL:nil];
    
}
- (IBAction)playTel {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[self.data objectForKey:@"author"]]]]];
    NSLog(@"%@",[NSString stringWithFormat:@"tel://%@",[self.data objectForKey:@"author"]]);
}
/*
 NSMutableString *content = [NSMutableString stringWithString:@"<html><body>"];
 [content appendString:@"<meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"];
 
 [content appendString:[NSString stringWithFormat:@"<p><span style=\"font-family:宋体\">%@</span></p>",[self.data objectForKey:@"title"]]];
 [content appendString:[NSString stringWithFormat:@"<p><strong><span style=\"font-family:宋体\">%@</span></strong></p>",[self.data objectForKey:@"copyright"]]];
 [content appendString:[NSString stringWithFormat:@"<p><strong><span style=\"font-family:宋体\">%@</span></strong></p>",[self.data objectForKey:@"summary"]]];
 [content appendString:[NSString stringWithFormat:@"<p><strong><span style=\"font-family:宋体\">%@</span></strong></p>",[self.data objectForKey:@"author"]]];
 [content appendString:[NSString stringWithFormat:@"<p><strong><span style=\"font-family:宋体\">%@</span></strong></p>",[self.data objectForKey:@"content"]]];
 
 [content appendString:@"</body></html>"];
 [self.webView loadHTMLString:content baseURL:nil];
 */


@end
