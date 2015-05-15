//
//  SheQuYiLiaoViewController.h
//  jrj
//
//  Created by BCT06 on 14/12/11.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheQuYiLiaoViewController : UIViewController

@property(nonatomic,retain) IBOutlet UIWebView *yiliaowebview;
@property(nonatomic,retain) IBOutlet UISegmentedControl *segment;
@property(nonatomic,retain) NSString *content1;
@property(nonatomic,retain) NSString *content2;
@property(nonatomic,retain) NSString *content3;
@property(nonatomic,retain) NSString *content4;

-(void)clicksegment;
@end
