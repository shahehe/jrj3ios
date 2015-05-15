//
//  LicenseInfoViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/3/3.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "LicenseInfoViewController.h"
#import "Sdk.h"

@interface LicenseInfoViewController ()
@end

@implementation LicenseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    if (self.data != nil) {
        
        NSString *str = [NSString stringWithFormat:@"rest/medicinal2/%@",[self.data objectForKey:@"id"]];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BctAPI get:str data:nil success:^(id json) {
            NSLog(@"%@",json);
            
            UIWebView *infoWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
            [infoWebView loadHTMLString:[json[0] objectForKey:@"content"] baseURL:nil];
            [self.view addSubview:infoWebView];
            
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
        }];
    }
    
    if (self.data1 != nil) {
        UIWebView *infoWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
        [infoWebView loadHTMLString:[self.data1 objectForKey:@"content"] baseURL:nil];
        [self.view addSubview:infoWebView];
    }   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
