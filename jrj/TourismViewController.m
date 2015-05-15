//
//  TourismViewController.m
//  jrj
//
//  Created by BCT06 on 15/1/6.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "TourismViewController.h"
#import "Sdk.h"

@interface TourismViewController ()

@end

@implementation TourismViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.data safeObjectForKey:@"image"]==nil) {
        self.touriswebview.hidden = YES;
    }else{
        [BctAPI image:self.tourisimage andUrl:[self.data safeObjectForKey:@"image"]];
    }
    [self.touriswebview loadHTMLString:[self.data safeObjectForKey:@"content"] baseURL:nil];
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
