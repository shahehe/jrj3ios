//
//  YuXianTableViewCell.h
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuXianTableViewCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) IBOutlet UILabel *introLabel;
@property(nonatomic,retain) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property(nonatomic,strong) UIViewController *tempViewController;
-(void)setData:(id)data;
@property(nonatomic,assign) double pointLatitude;
@property(nonatomic,assign) double pointLongitude;
@end
