//
//  InfoListViewController.m
//  jrj
//
//  Created by BCT06 on 15/1/13.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "InfoListViewController.h"

@interface InfoListViewController ()

@end

@implementation InfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.infowebview loadHTMLString:[self.data objectForKey:@"content"] baseURL:nil];
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
