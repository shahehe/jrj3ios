//
//  JieDaoViewController.h
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JieDaoViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIWebView *webView;

@end
