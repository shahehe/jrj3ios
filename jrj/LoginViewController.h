//
//  LoginViewController.h
//  financialDistrict
//
//  Created by USTB on 13-3-11.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+IdentifierAddition.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property NSString * confirmedPW;
@property BOOL hasConfirmedPW;

@property(nonatomic,retain) IBOutlet UIButton *btn1;
@property(nonatomic,retain) IBOutlet UIButton *btn2;

+ (void) showAlert:(NSString *)messageToDisplay;
+ (int) successOrNot:(NSString *)returnString;

@end
