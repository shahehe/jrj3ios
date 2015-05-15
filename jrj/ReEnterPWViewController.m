//
//  ReEnterPWViewController.m
//  financialDistrict
//
//  Created by USTB on 13-4-12.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import "ReEnterPWViewController.h"
#import "UIColor+NavigationColor.h"
#import "LoginViewController.h"
#import "ApiService.h"
#import "UIButton+Bootstrap.h"

@interface ReEnterPWViewController ()

@end

@implementation ReEnterPWViewController
@synthesize rePassWord;
@synthesize username;
@synthesize pw;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    rePassWord.backgroundColor = [UIColor whiteColor];
    rePassWord.delegate = self;
    [rePassWord setSecureTextEntry:YES];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    //self.navigationController.navigationBar.tintColor = [UIColor NaviColor];
    
    //self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor],[UIFont systemFontOfSize:20.0f],[UIColor colorWithWhite:0.0 alpha:1], nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor, nil]];
    
    [self setViewStyle:self.btn1];
    [self setTextFieldStyle:self.rePassWord imageName:@"icon_password"];
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
    sender.layer.borderColor = [UIColor colorWithRed:200/255.0 green:138/255.0 blue:18/255.0 alpha:1].CGColor;
    sender.layer.cornerRadius = 6;
    sender.layer.masksToBounds = YES;
}
//close the keyboard
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.rePassWord endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirm:(id)sender {
    [self.rePassWord endEditing:YES];
    if([pw isEqualToString:rePassWord.text]){
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"正在注册";
        [HUD showWhileExecuting:@selector(registerUserTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        [LoginViewController showAlert:@"两次密码不符"];
    }

}


- (void) registerUserTask{
    
    NSMutableURLRequest *registerRequest = [[NSMutableURLRequest alloc] init];
    NSString *registerUrl =[NSString stringWithFormat:@"http://%@/jrj/register.php",[ApiService sharedInstance].host];
    
    NSLog(@"qqqqqqqqq%@",[ApiService sharedInstance].host);
    
    [registerRequest setURL:[NSURL URLWithString:registerUrl]];
    [registerRequest setHTTPMethod:@"POST"];
    
    NSString *post = [NSString stringWithFormat:@"name=%@&password=%@&deviceid=%@",username,pw, @"IOS"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%d", (unsigned int)[postData length]];
    
    [registerRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [registerRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [registerRequest setHTTPBody:postData];
    
    NSData *registerReturnData = [NSURLConnection sendSynchronousRequest:registerRequest returningResponse:nil error:nil];
    NSString *registerReturnString = [[NSString alloc] initWithData:registerReturnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",registerReturnString);
    if([LoginViewController successOrNot:registerReturnString]== 0){
        [LoginViewController showAlert:@"注册失败，用户名已经存在"];
        
    }
    else if ([LoginViewController successOrNot:registerReturnString]== (-1)){
        [LoginViewController showAlert:@"注册失败"];
    }
    else{
        [LoginViewController showAlert:@"注册成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}


@end
