//
//  NewUserViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/3/16.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "NewUserViewController.h"
#import "MBProgressHUD.h"
#import "CheckConnection.h"
#import "Utils.h"
#import "LoginViewController.h"
#import "ApiService.h"

@interface NewUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
- (IBAction)upInfo;
@property (weak, nonatomic) IBOutlet UIButton *updataBtn;

@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userName.backgroundColor = [UIColor whiteColor];
    self.pwd.backgroundColor = [UIColor whiteColor];
    [self.pwd setSecureTextEntry:YES];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];

    [self setViewStyle:self.updataBtn];
    [self setTextFieldStyle:self.userName imageName:@"icon_username"];
    [self setTextFieldStyle:self.pwd imageName:@"icon_password"];

}

- (void)setTextFieldStyle:(UITextField *)sender imageName:(NSString *)imageName
{
    sender.layer.masksToBounds = YES;
    sender.layer.borderColor = [UIColor colorWithRed:200/255.0 green:138/255.0 blue:18/255.0 alpha:1].CGColor;
    sender.layer.borderWidth = 1;
    UIImageView *nameimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    sender.leftView = nameimage;
    sender.leftViewMode = UITextFieldViewModeAlways;
    sender.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)setViewStyle:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithRed:237/255.0 green:141/255.0 blue:27/255.0 alpha:1];
    sender.layer.cornerRadius = 6;
    sender.layer.masksToBounds = YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userName endEditing:YES];
    [self.pwd endEditing:YES];
}

- (IBAction)upInfo {
    
    if([CheckConnection connected])
    {
        if([self.userName.text isEqualToString:@""]){
            [Utils showAlert:@"注册失败，用户名不能为空"];
        }else if([self.pwd.text isEqualToString:@""]){
            [Utils showAlert:@"注册失败，密码不能为空"];
        }else{
            NSMutableURLRequest *registerRequest = [[NSMutableURLRequest alloc] init];
            NSString *registerUrl = [NSString stringWithFormat:@"http://%@/jrj/register.php",[ApiService sharedInstance].host];
            
            NSLog(@"--------%@",[NSString stringWithFormat:@"http://%@/jrj/register.php",[ApiService sharedInstance].host]);
            
            [registerRequest setURL:[NSURL URLWithString:registerUrl]];
            [registerRequest setHTTPMethod:@"POST"];
            
            NSString *post = [NSString stringWithFormat:@"name=%@&password=%@&deviceid=%@",self.userName.text,self.pwd.text, @"IOS"];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length] ];
            
            [registerRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [registerRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [registerRequest setHTTPBody:postData];
            
            NSData *registerReturnData = [NSURLConnection sendSynchronousRequest:registerRequest returningResponse:nil error:nil];
            NSString *registerReturnString = [[NSString alloc] initWithData:registerReturnData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",registerReturnString);
            if([LoginViewController successOrNot:registerReturnString]== 0){
                [LoginViewController showAlert:@"注册失败，用户名已经存在"];
            } else if ([LoginViewController successOrNot:registerReturnString]== (-1)){
                [LoginViewController showAlert:@"注册失败"];
            } else{
                [LoginViewController showAlert:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];

            }
        }
    }
}
@end
