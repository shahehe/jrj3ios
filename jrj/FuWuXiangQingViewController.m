//
//  FuWuXiangQingViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/16.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "FuWuXiangQingViewController.h"
#import "Sdk.h"

@interface FuWuXiangQingViewController ()

@end

@implementation FuWuXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fwxqwebview loadHTMLString:[self.data safeObjectForKey:@"content" ] baseURL:nil];
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
