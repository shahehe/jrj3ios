//
//  ConvenienceStoreViewController.m
//  jrj
//
//  Created by BCT06 on 15/1/14.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "ConvenienceStoreViewController.h"
#import "Sdk.h"
#import "shopInfoViewController.h"

@interface ConvenienceStoreViewController ()

@end

@implementation ConvenienceStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/live" data:nil success:^(id json) {
//        NSLog(@"AAAAAA%@",json);
        self.items = json;
        [self.tableView reloadData];
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *storename = (UILabel *) [cell viewWithTag:1];
    storename.text =[NSString stringWithFormat:@"商铺名称：%@",[[self.items objectAtIndex:indexPath.row]objectForKey:@"title"]];
    UILabel *streetname = (UILabel *) [cell viewWithTag:2];
    streetname.text = [NSString stringWithFormat:@"所属街道：%@",[[self.items objectAtIndex:indexPath.row]objectForKey:@"copyright"]];
    UILabel *address = (UILabel *) [cell viewWithTag:3];
    address.text = [NSString stringWithFormat:@"地址：%@",[[self.items objectAtIndex:indexPath.row]objectForKey:@"summary"]];
    UILabel *phone = (UILabel *) [cell viewWithTag:4];
    phone.text = [NSString stringWithFormat:@"联系电话：%@",[[self.items objectAtIndex:indexPath.row]objectForKey:@"author"]];
    UIImageView *storeimage = (UIImageView *) [cell viewWithTag:5];
    [BctAPI image:storeimage andUrl:[[self.items objectAtIndex:indexPath.row] safeObjectForKey:@"image"]];
    UIImageView * background = (UIImageView *)[cell viewWithTag:6];
    background.image = [UIImage imageNamed:@"arrow.png"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goto" sender:[self.items objectAtIndex:indexPath.row]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goto"])
    {
        shopInfoViewController *shopInfoVC = segue.destinationViewController;
        shopInfoVC.data = sender;
    }
}


@end
