//
//  flyInfoController.m
//  jrj
//
//  Created by bct11-macmini on 15/1/21.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "flyInfoController.h"
#import "Sdk.h"

@interface flyInfoController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebview;

@end

@implementation flyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconView.image = [UIImage imageNamed:@"no_image"];
    [BctAPI image:self.iconView andUrl:[self.data objectForKey:@"image"]];
    [self.infoWebview loadHTMLString:[self.data objectForKey:@"content"] baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
