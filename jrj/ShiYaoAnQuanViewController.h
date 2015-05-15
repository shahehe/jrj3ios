//
//  ShiYaoAnQuanViewController.h
//  jrj
//
//  Created by BCT06 on 14/12/17.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiYaoAnQuanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) IBOutlet UIWebView *describewebciew;
@property(nonatomic,retain) IBOutlet UISegmentedControl *segmented;
@property(nonatomic,retain) IBOutlet UITableView *protableview;

@property(nonatomic,retain) NSArray *items;
@property(nonatomic,retain) NSArray *item2;
@property(nonatomic,retain) NSArray *item3;
@end
