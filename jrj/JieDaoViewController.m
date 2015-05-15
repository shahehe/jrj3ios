//
//  JieDaoViewController.m
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "JieDaoViewController.h"
#import "Sdk.h"
#import "NSDictionary+SSToolkitAdditions.h"
#import "UIImageView+WebCache.h"


@interface JieDaoViewController()
@property(assign, nonatomic)int imageCounts;
@end

@implementation JieDaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];

    [self getData];
}

-(void)getData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/page/about_jrj" data:nil success:^(id json) {
        NSLog(@"%@",json);
        NSMutableString *content = [NSMutableString stringWithString:@"<html><body>"];
        [content appendString:@"<meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"];
        [content appendString:[json safeObjectForKey:@"content"]];
        [content appendString:@"</body></html>"];
        [self.webView loadHTMLString:content baseURL:nil];
        //生成广告图标
        CGFloat width = self.view.frame.size.width;
        int i=0;
        for(id img in [json safeObjectForKey:@"thumbnail"]){
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, 160)];
            iv.image = [UIImage imageNamed:@"no_image"];
            [BctAPI image:iv andUrl:[[img safeObjectForKey:@"image"] safeObjectForKey:@"large"]];
            [self.scrollView addSubview:iv];
            i++;
        }
        self.imageCounts = i;
        self.pageControl.numberOfPages = self.imageCounts;
        self.pageControl.currentPage = 0;
        self.scrollView.contentSize = CGSizeMake(width * self.imageCounts, 160);
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}

- (void)nextImage
{
    // 增加pagecontrol的页码
    int page = 0;
    if (self.pageControl.currentPage == self.imageCounts - 1) {
        page = 0;
    }else{
        page = (int)self.pageControl.currentPage + 1;
    }
    
    // 计算scrollview滚动位置
    CGFloat offsetX = page * self.view.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.pageControl.currentPage = page;
}

@end
