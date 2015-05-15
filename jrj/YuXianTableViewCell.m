//
//  YuXianTableViewCell.m
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "YuXianTableViewCell.h"
#import "NSDictionary+SSToolkitAdditions.h"
#import "UIImageView+WebCache.h"
#import "BctAPI.h"
#import "CheckConnection.h"
#import "YuXianTableViewController.h"

@interface YuXianTableViewCell()
@end

@implementation YuXianTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.cellView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setData:(id)data
{
    self.nameLabel.text = [data safeObjectForKey:@"name"];
    self.introLabel.text = [data safeObjectForKey:@"intro"];
    self.pointLatitude = [[data safeObjectForKey:@"latitude"] doubleValue];
    self.pointLongitude = [[data safeObjectForKey:@"longitude"] doubleValue];
    [BctAPI image:self.photoImageView andUrl:[data safeObjectForKey:@"image"]];
    //读取缓存图片
//    [self.photoImageView setImageWithURL:[NSURL URLWithString:[data safeObjectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
}

@end
