//
//  BankDynamicViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/1/24.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "BankDynamicViewController.h"

@interface BankDynamicViewController ()

@end

@implementation BankDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *infoWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [infoWebView loadHTMLString:[self.data objectForKey:@"content"] baseURL:nil];
    [self.view addSubview:infoWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
