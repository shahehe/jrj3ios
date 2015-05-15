//
//  XiaJiaXiangQingViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/17.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "XiaJiaXiangQingViewController.h"

@interface XiaJiaXiangQingViewController ()

@end

@implementation XiaJiaXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableString *html = [NSMutableString stringWithCapacity:0];
    [html appendString:@"<!DOCTYPE HTML><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"><style>body{padding:0px;margin:0px;}div.box{border-radius: 6px;border:1px solid #f6d8b9;margin:10px;line-height: 32px;} div.t{width: 40%;float:left;color:gray;font-size: 12px;} div.c{font-size: 12px;width: 59%;border-left: 1px solid #ccc;float: left;}div.cl{clear:both;}</style></head><body >"];
    
    [html appendFormat:@"<div class=box><div class=t>&nbsp;商标</div><div class=c>&nbsp;%@</div><div class=cl></div></div>",[self.data valueForKey:@"brand"]];
    
    [html appendFormat:@"<div class=box><div class=t>&nbsp;规格型号</div><div class=c>&nbsp;%@</div><div class=cl></div></div>",[self.data valueForKey:@"model"]];
    
    [html appendFormat:@"<div class=box><div class=t>&nbsp;生产批次</div><div class=c>&nbsp;%@</div><div class=cl></div></div>",[self.data valueForKey:@"batch"]];
    
    [html appendFormat:@"<div class=box><div class=t>&nbsp;不合格项目</div><div class=c>&nbsp;%@</div><div class=cl></div></div>",[self.data valueForKey:@"item"]];
    
    [html appendFormat:@"<div class=box><div class=t>&nbsp;生产单位名称</div><div class=c>&nbsp;%@</div><div class=cl></div></div>",[self.data valueForKey:@"company"]];
    
    [html appendFormat:@"<div class=box><div class=t>&nbsp;当事人姓名或名称</div><div class=c>&nbsp;%@</div><div class=cl></div></div>",[self.data valueForKey:@"party"]];
    
    [html appendString:@"</body></html>"];
    // NSLog(@"html:%@",html);
    [self.xjxqwebview loadHTMLString:html baseURL:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
