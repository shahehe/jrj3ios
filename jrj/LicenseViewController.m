//
//  LicenseViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/3/3.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "LicenseViewController.h"
#import "Sdk.h"
#import "LicenseInfoViewController.h"

@interface LicenseViewController ()

@end

@implementation LicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"餐饮许可办理";
    
    [self.tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"product_line.png"]]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.item = [NSMutableArray array];
    
    NSString *str = [NSString stringWithFormat:@"rest/medicinal2/%@",[self.data objectForKey:@"id"]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:str data:nil success:^(id json) {
        //NSLog(@"%@",json);

        self.item = json;
        [self.tableView reloadData];
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"licenseCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    UILabel *label = (UILabel *)[cell viewWithTag:21];
    label.text = [[self.item objectAtIndex:indexPath.row] objectForKey:@"title"];
    UIImageView *icon = (UIImageView *) [cell viewWithTag:20];
    icon.image = [UIImage imageNamed:@"info4"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.item objectAtIndex:indexPath.row];
    LicenseInfoViewController *LVC = [[LicenseInfoViewController alloc] init];
    LVC.data1 = item;
    
    [self.navigationController pushViewController:LVC animated:YES];
}

@end
