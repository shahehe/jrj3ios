//
//  GongAnFuWuViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/15.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "GongAnFuWuViewController.h"
#import "Sdk.h"

@interface GongAnFuWuViewController ()
@property (nonatomic, retain)NSArray *data;
- (IBAction)playPhone;
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,copy)NSString *tel;
@end

@implementation GongAnFuWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"出入境服务";
    
    [self.SegmentedControl addTarget:self action:@selector(clickSegmented) forControlEvents:UIControlEventValueChanged];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"/rest/policeinfo" data:nil success:^(id json) {
        //        NSLog(@"AAAAAA%@",json);
        self.data = json;
        self.tel = [self.data[0] objectForKey:@"author"];
        NSLog(@"%@",self.tel);
        [self.gafwwebview loadHTMLString:[self.data[0] objectForKey:@"content"] baseURL:nil];
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}

-(void)clickSegmented{
    switch (self.SegmentedControl.selectedSegmentIndex) {
        case 0:
            [self.gafwwebview loadHTMLString:[self.data[0] objectForKey:@"content"] baseURL:nil];
            break;
        case 1:
            [self.gafwwebview loadHTMLString:[self.data[1] objectForKey:@"content"] baseURL:nil];
            break;
        case 2:
            [self.gafwwebview loadHTMLString:[self.data[2] objectForKey:@"content"] baseURL:nil];
            break;
        default:
            break;
    }
}

- (IBAction)playPhone {

    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.tel]]]];
}
@end
