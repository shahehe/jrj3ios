//
//  ServiceViewController.m
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "ServiceViewController.h"
#import "WebViewController.h"
#import "BicycleViewController.h"
#import "Sdk.h"
#import "YuXianTableViewController.h"
#import "LvYouWenHuaTableViewController.h"
#import "HealthServiceTableViewController.h"
#import "SheQuYiLiaoViewController.h"
#import "ConvenienceStoreViewController.h"
#import "BankServiceViewController.h"
#import "ActivityViewController.h"


@interface ServiceViewController ()
@property (nonatomic, retain)NSArray *data;
@end

@implementation ServiceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"/rest/bike" data:nil success:^(id json) {
        self.data = json;
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
    [self setupView];
}

- (void)btnClick {
//    BViewController *vc = [[BViewController alloc] init];
    BicycleViewController *vc = [[BicycleViewController alloc] init];
    vc.data = self.data;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Navigation

- (void)setupView
{
    int count = 9;
    for (int i = 0; i<count; i++) {
        //创建按钮
        UIButton *btn = [[UIButton alloc] init];
        //设置背景
        NSString *imageName = [NSString stringWithFormat:@"home2_btn%d",i+1];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        //设置frame
        //总的列数
        int totalColums = 3;
        CGFloat margin = 10;
        CGFloat btnH = (self.view.frame.size.height - 114 - 2 * margin) / 3;
        CGFloat btnW = btnH * 0.65;
        
        CGFloat viewW = self.view.frame.size.width;
        CGFloat leftMargin;
        CGFloat space;
        if (self.view.frame.size.height == 480) {
            leftMargin = 20;
            space = 15;
        } else {
            leftMargin = (viewW - totalColums * btnW - (totalColums - 1) * margin) * 0.5;
            space = 0;
        }
        // 列 和 行
        int col = i % totalColums;
        int row = i / totalColums;
        
        CGFloat btnX = leftMargin + col * (btnW + margin + space);
        CGFloat btnY = row * (btnH + margin) + 64;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [self.view addSubview:btn];
        
        //添加待选项按钮的监听事件
        [btn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
    }
}
- (void)optionClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        {
            YuXianTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"yuxiang"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            BicycleViewController *vc = [[BicycleViewController alloc] init];
            vc.data = self.data;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            LvYouWenHuaTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"lvyou"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            SheQuYiLiaoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"yiliao"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shangquan"];
            vc.url = @"http://jrjsq.chinaec.net";
            vc.scalesPageToFit = YES;
            vc.title = @"社区商圈";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            HealthServiceTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"jiankang"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            ActivityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            ConvenienceStoreViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConvenienceStoreViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
            BankServiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"bank"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
