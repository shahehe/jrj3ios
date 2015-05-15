//
//  SheQuYiLiaoViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/11.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "SheQuYiLiaoViewController.h"
#import "Sdk.h"

@interface SheQuYiLiaoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *doctorTableView;
@property (retain,nonatomic)NSArray *data;
@end

@implementation SheQuYiLiaoViewController

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segment.selectedSegmentIndex = 0;

    [self.segment addTarget:self action:@selector(clicksegment) forControlEvents:UIControlEventValueChanged];
    [self getContent:@"page/about_doctor"];
    
    self.yiliaowebview.hidden = NO;
    self.doctorTableView.hidden = YES;
    self.doctorTableView.dataSource = self;
    self.doctorTableView.delegate = self;
}

-(void)getContent:(NSString *)url
{
    NSString *str = @"";
    switch (self.segment.selectedSegmentIndex) {
        case 0:
            str = self.content1;
            break;
        case 1:
            str = self.content2;
            break;
        case 2:
            str = self.content3;
            break;
        case 3:
            str = self.content4;
            break;
    }
    if(str != nil){
        [self.yiliaowebview loadHTMLString:str baseURL:nil];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI getContent:url data:nil success:^(id content) {
        switch (self.segment.selectedSegmentIndex) {
            case 0:
                self.content1 = content;
                [self.yiliaowebview loadHTMLString:(NSString *)content baseURL:nil];
                break;
            case 1:
                self.content2 = content;
                [self.yiliaowebview loadHTMLString:(NSString *)content baseURL:nil];
                break;
            case 2:{
                self.content3 = content;
                [self.yiliaowebview loadHTMLString:(NSString *)content baseURL:nil];
            }break;
            case 3:
                self.content4 = content;
                [self.yiliaowebview loadHTMLString:(NSString *)content baseURL:nil];
                break;
        }
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}
- (void)clicksegment
{
    
    switch (self.segment.selectedSegmentIndex) {
            
        case 0:
        {
            [self getContent:@"page/about_doctor"];
        }
            break;
        case 1:
        {
            [self getContent:@"page/institution"];
        }
            break;
        case 2:
        {
            [self getContent:@"doctor"];
        }
            break;
        case 3:
        {
            [self getContent:@"page/health"];
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doctorCell" forIndexPath:indexPath];
    UILabel *name = (UILabel *)[cell viewWithTag:50];
    UILabel *department = (UILabel *)[cell viewWithTag:51];
    
    name.text = @"123";
    department.text = @"123";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
