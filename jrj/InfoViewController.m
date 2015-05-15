//
//  InfoViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/2/2.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *infoWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [infoWebView loadHTMLString:self.str baseURL:nil];
    [self.view addSubview:infoWebView];
    
    NSLog(@"%@",self.str);
}



@end
