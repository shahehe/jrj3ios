//
//  YuXianTableViewController.h
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YuXianTableViewController : UITableViewController <CLLocationManagerDelegate>

@property(nonatomic,retain) NSArray *items;
@end
