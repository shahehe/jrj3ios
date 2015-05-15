//
//  CategoryArticleViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/26.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "CategoryArticleViewController.h"

@interface CategoryArticleViewController ()

@end

@implementation CategoryArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cageartiwebview loadHTMLString:[self.data objectForKey:@"content"]  baseURL:nil];
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
