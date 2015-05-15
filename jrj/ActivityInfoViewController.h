//
//  ActivityInfoViewController.h
//  jrj
//
//  Created by bct11-macmini on 15/1/27.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityInfoViewController : UIViewController
@property(nonatomic,retain)id data;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@end
