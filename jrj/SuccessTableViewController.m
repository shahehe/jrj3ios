//
//  SuccessTableViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/3/23.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "SuccessTableViewController.h"
#import "MessageViewController.h"
#import "ProgressHUD.h"
#import "LoginViewController.h"
#import "BctAPI.h"
#import "ApiService.h"

@interface SuccessTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *ranking;
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;
@property (weak, nonatomic) IBOutlet UILabel *submitNum;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
@property (weak, nonatomic) IBOutlet UILabel *integral;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
- (IBAction)pushMsg;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
- (IBAction)exitLogin;

@property(nonatomic,assign)int isSel;

@property(nonatomic,retain)NSArray *msgArray;
@property(nonatomic, retain)NSArray *levelArray;
@end

@implementation SuccessTableViewController

- (NSArray *)levelArray
{
    if (_levelArray == nil) {
        _levelArray = [NSArray arrayWithObjects:@"注册用户",@"金融街新秀",@"金融街卫士",@"金融街达人", nil];
    }
    return _levelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self getMessageArray];
    [self getInfo];
    [self getRankAndLevel];
    
    [self setBtnStyle:self.exitBtn];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults boolForKey:@"isShow"] == YES) {
        [self.pushBtn setImage:[UIImage imageNamed:@"pushBtn"] forState:UIControlStateNormal];
    } else {
        [self.pushBtn setImage:[UIImage imageNamed:@"pushBtn_sel"] forState:UIControlStateNormal];
    }
    
//    [self.pushBtn setImage:[UIImage imageNamed:@"pushBtn_sel"] forState:UIControlStateNormal];
}

- (void)setBtnStyle:(UIButton *)sender
{
    sender.layer.cornerRadius = 6;
    sender.layer.masksToBounds = YES;
    sender.backgroundColor = [UIColor colorWithRed:237/255.0 green:141/255.0 blue:27/255.0 alpha:1];
}

- (void)getRankAndLevel
{
    NSMutableURLRequest *rankRequest = [[NSMutableURLRequest alloc] init];
    NSString *rankUrl =[NSString stringWithFormat:@"http://%@/jrj/getRank.php?uid=%d",[ApiService sharedInstance].host,[ApiService sharedInstance].userID];
    [rankRequest setURL:[NSURL URLWithString:rankUrl]];
    [rankRequest setHTTPMethod:@"POST"];
    NSData *rankReturnData = [NSURLConnection sendSynchronousRequest:rankRequest returningResponse:nil error:nil];
    NSString *rankReturnString = [[NSString alloc] initWithData:rankReturnData encoding:NSUTF8StringEncoding];
    
    NSDictionary *outputDic = [[NSDictionary alloc] init];
    NSData *jsonData = [rankReturnString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if(jsonObject != nil && error == nil){
        if([jsonObject isKindOfClass:[NSDictionary class]]){
            outputDic = (NSDictionary *)jsonObject;
            
            if ([[outputDic objectForKey:@"credit"] intValue] >= 500) {
                self.ranking.text = [NSString stringWithFormat:@"等级:%@ 排名:%@",self.levelArray[3],[outputDic objectForKey:@"Rank"]];
            } else if ([self.integral.text intValue] >= 150){
                self.ranking.text = [NSString stringWithFormat:@"等级:%@ 排名:第%@名",self.levelArray[2],[outputDic objectForKey:@"Rank"]];
            } else if ([self.integral.text intValue] >= 50){
                self.ranking.text = [NSString stringWithFormat:@"等级:%@ 排名:第%@名",self.levelArray[1],[outputDic objectForKey:@"Rank"]];
            } else {
                self.ranking.text = [NSString stringWithFormat:@"等级:%@ 排名:第%@名",self.levelArray[0],[outputDic objectForKey:@"Rank"]];
            }
        }
    }
}

- (void)getInfo{
    //parsing msg String
    if(self.infoData != nil){
        NSDictionary *outputDic = [[NSDictionary alloc] init];
        
        NSData *jsonData = [self.infoData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if(jsonObject != nil && error == nil){
            if([jsonObject isKindOfClass:[NSDictionary class]]){
                outputDic = (NSDictionary *)jsonObject;
                
                self.userName.text = [NSString stringWithFormat:@"用户名:%@",[[outputDic objectForKey:@"data"] objectForKey:@"name"]];
                
                self.submitNum.text = [[outputDic objectForKey:@"data"] objectForKey:@"report_time"];
                self.integral.text = [[outputDic objectForKey:@"data"] objectForKey:@"credit"];
                
                if ([self.integral.text intValue] >= 500) {
                    self.ranking.text = [NSString stringWithFormat:@"等级:%@ 排名:%@",self.levelArray[3],[[outputDic objectForKey:@"data"] objectForKey:@"name"]];
                } else if ([self.integral.text intValue] >= 150){
                    self.ranking.text = [NSString stringWithFormat:@"等级:%@ 排名:第%@名",self.levelArray[2],[[outputDic objectForKey:@"data"] objectForKey:@"name"]];
                } else if ([self.integral.text intValue] >= 50){
                    self.ranking.text = [NSString stringWithFormat:@"等级:%@ 排名:第%@名",self.levelArray[1],[[outputDic objectForKey:@"data"] objectForKey:@"name"]];
                } else {
                    self.ranking.text = [NSString stringWithFormat:@"等级:%@ 排名:第%@名",self.levelArray[0],[[outputDic objectForKey:@"data"] objectForKey:@"name"]];
                }
            }
        }
//        NSLog(@"-11--%@",[outputDic objectForKey:@"data"]);
    }
}

-(void) getMessageArray{
    //parsing msg String
    if(self.msgData != nil){
        NSDictionary *outputDic = [[NSDictionary alloc] init];
        
        NSData *jsonData = [self.msgData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if(jsonObject != nil && error == nil){
            if([jsonObject isKindOfClass:[NSDictionary class]]){
                outputDic = (NSDictionary *)jsonObject;
            }
        }
        self.msgArray = [outputDic objectForKey:@"data"];
    }
}

- (IBAction)exitLogin {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pushMsg {
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"isShow"] == NO) {
        [self.pushBtn setImage:[UIImage imageNamed:@"pushBtn"] forState:UIControlStateNormal];
    
        [defaults setBool:YES forKey:@"isShow"];
        [defaults synchronize];
    } else {
        [self.pushBtn setImage:[UIImage imageNamed:@"pushBtn_sel"] forState:UIControlStateNormal];

        [defaults setBool:NO forKey:@"isShow"];
        [defaults synchronize];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MessageViewController *msgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"messageVC"];
            msgVC.msgString = self.msgData;
            [self.navigationController pushViewController:msgVC animated:YES];
        }
        if (indexPath.row == 2) {
            [self myClearCacheAction];
        }
    }
}
-(void)myClearCacheAction{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}


-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    [ProgressHUD showSuccess:@"成功清理缓存"];
}
@end
