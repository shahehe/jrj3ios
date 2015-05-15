//
//  ReEnterPWViewController.h
//  financialDistrict
//
//  Created by USTB on 13-4-12.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface ReEnterPWViewController : UIViewController<UITextFieldDelegate,
    MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *rePassWord;
@property NSString *username;
@property NSString *pw;
@property(nonatomic,retain) IBOutlet UIButton *btn1;

@end
