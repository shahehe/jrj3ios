//
//  dynamicInfoViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/1/22.
//  Copyright (c) 2015年 bct. All rights reserved.
//
// 工商动态
#import "dynamicInfoViewController.h"

@interface dynamicInfoViewController ()
@property(nonatomic,retain) IBOutlet UIWebView *infowebview;
@end

@implementation dynamicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.infowebview loadHTMLString:[self.data objectForKey:@"content"] baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
