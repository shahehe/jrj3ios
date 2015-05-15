//
//  HomeViewController.m
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "HomeViewController.h"
#import "Sdk.h"
#import "flyInfoController.h"
#import "JieDaoViewController.h"
#import "FuWuShiXiangViewController.h"
#import "gongShangServiceViewController.h"
#import "ShiYaoAnQuanViewController.h"
#import "GongAnFuWuViewController.h"
#import "JieDaoZhouBaoTableViewController.h"
#import "ReportCategoryViewController.h"


@interface HomeViewController ()
@property(nonatomic,retain) NSArray *items;
@property(nonatomic,copy)UIImageView *iconView;
@property BOOL isShow;
@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    [self setupFlyView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationController.navigationItem.backBarButtonItem.title = @"返回";
}

- (void)setupView
{
    int count = 6;
    for (int i = 0; i<count; i++) {
        //创建按钮
        UIButton *btn = [[UIButton alloc] init];
        //设置背景
        NSString *imageName = [NSString stringWithFormat:@"home_btn%d",i+1];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        //设置frame
        //总的列数
        int totalColums = 2;
        CGFloat margin = 20;
        CGFloat btnH = (self.view.frame.size.height - 104 - 2 * margin) / 3;
        CGFloat btnW = btnH;
        
        CGFloat viewW = self.view.frame.size.width;
        CGFloat leftMargin;
        CGFloat space;
        if (self.view.frame.size.height == 480) {
            leftMargin = 30;
            space = 20;
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
            JieDaoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"jiedao"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            FuWuShiXiangViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"fuwu"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            gongShangServiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"gongshang"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            ShiYaoAnQuanViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shiyao"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            GongAnFuWuViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"gongan"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            ReportCategoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"jiedaozhoubao"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSArray *)items
{
    if (_items == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BctAPI get:@"/rest/suspending" data:nil success:^(id json) {
            _items = json;
            NSLog(@"%@",json);
            [self setupFlyView];
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
        }];
    }
    return _items;
}

- (void)setupFlyView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isShow = [defaults boolForKey:@"isShow"];
    if (self.isShow == NO) {
        UIButton *cover = [[UIButton alloc] init];
        cover.frame = self.view.bounds;
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0.1;
        cover.tag = 1000;
        [self.view addSubview:cover];
        
        CGFloat space = 5;
        
        CGFloat viewW = self.view.frame.size.width - 2 * space;
        CGFloat viewH = 300;
        CGFloat viewX = space;
        CGFloat viewY = self.view.center.y - viewH / 2;
        UIView *viewT = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        viewT.backgroundColor = [UIColor whiteColor];
        viewT.tag = 1000;
        viewT.layer.cornerRadius = 5;
        viewT.clipsToBounds = YES;
        
        CGFloat titleX = 0;
        CGFloat titleY = 0;
        CGFloat titleW = viewW;
        CGFloat titleH = 35;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        title.text = [self.items.firstObject objectForKey:@"title"];
        title.font = [UIFont systemFontOfSize:20];
        title.textAlignment = NSTextAlignmentCenter;
        [viewT addSubview:title];
        
        CGFloat iconViewX = 0;
        CGFloat iconViewY = titleH + 2;
        CGFloat iconViewW = viewW;
        CGFloat iconViewH = 180;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH)];
        iconView.image = [UIImage imageNamed:@"no_image"];
        [BctAPI image:iconView andUrl:[self.items.firstObject objectForKey:@"image"]];
        [viewT addSubview:iconView];
        
        CGFloat title1X = 5;
        CGFloat title1Y = iconViewY + iconViewH + 2;
        CGFloat title1W = viewW - 10;
        CGFloat title1H = 30;
        UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(title1X, title1Y, title1W, title1H)];
        title1.text = [self.items.firstObject objectForKey:@"description"];
        title1.font = [UIFont systemFontOfSize:17];
        title1.textAlignment = NSTextAlignmentLeft;
        [viewT addSubview:title1];
        
        CGFloat infoBtnX = 2;
        CGFloat infoBtnY = title1Y + title1H + 2;
        CGFloat infoBtnW = (viewW - 8) / 3;
        CGFloat infoBtnH = 40;
        UIButton *infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(infoBtnX, infoBtnY, infoBtnW, infoBtnH)];
        [infoBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        infoBtn.backgroundColor = [UIColor grayColor];
        [infoBtn addTarget:self action:@selector(infoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [viewT addSubview:infoBtn];
        
        CGFloat cancleBtnX = infoBtnX + infoBtnW + 2;
        CGFloat cancleBtnY = infoBtnY;
        CGFloat cancleBtnW = infoBtnW;
        CGFloat cancleBtnH = infoBtnH;
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancleBtnX, cancleBtnY, cancleBtnW, cancleBtnH)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.backgroundColor = [UIColor grayColor];
        [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [viewT addSubview:cancleBtn];
        
        CGFloat showBtnX = cancleBtnX + cancleBtnW + 2;
        CGFloat showBtnY = infoBtnY;
        CGFloat showBtnW = infoBtnW;
        CGFloat showBtnH = infoBtnH;
        UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(showBtnX, showBtnY, showBtnW, showBtnH)];
        [showBtn setTitle:@"不再提示" forState:UIControlStateNormal];
        showBtn.backgroundColor = [UIColor grayColor];
        [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [viewT addSubview:showBtn];
        
        [self.view addSubview:viewT];
    }
}

- (void)infoBtnClick
{
    [self cancleBtnClick];
    flyInfoController *vc = [[flyInfoController alloc] init];
    vc.data = self.items.firstObject;
    vc.title = @"详细信息";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showBtnClick
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isShow"];
    [defaults synchronize];
    
    [self cancleBtnClick];
}

- (void)cancleBtnClick
{
    for(UIView *View in [self.view subviews])
    {
        if(1000 == View.tag)
        {
            [View setHidden:YES];
        }
    }
}
@end
