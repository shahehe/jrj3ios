//
//  ArtecleViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/26.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "ArtecleViewController.h"
#import "Sdk.h"

@interface ArtecleViewController ()

@end

@implementation ArtecleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"/rest/article-list/%@",[self.data objectForKey:@"id"]];
    [BctAPI get:url data:nil success:^(id json) {
        self.items = json;
        [self.articlewebview loadHTMLString: [[self.items objectAtIndex:0] objectForKey:@"content"] baseURL:nil];
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
    
    [self.articlewebview loadHTMLString: [[self.items objectAtIndex:0] objectForKey:@"content"] baseURL:nil];
}

@end
