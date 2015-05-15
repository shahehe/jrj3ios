//
//  ReportCategoryCell.h
//  fdemo
//
//  Created by jrj on 13-3-16.
//  Copyright (c) 2013年 jrj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCategoryCell : UITableViewCell

@property IBOutlet UILabel *titleLabel;
@property IBOutlet UILabel *descLabel;
@property IBOutlet UIImageView *imgView;

-(void)setData:(id)data;
@end
