//
//  ActivityViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/1/27.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "ActivityViewController.h"
#import "Sdk.h"
#import "ActivityInfoViewController.h"

@interface ActivityViewController ()
//@property (nonatomic, assign) NSArray *data;
@end

@implementation ActivityViewController

//- (NSArray *)data
//{
//    if (_data == nil) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [BctAPI get:@"rest/active" data:nil success:^(id json) {
//            self.data = json;
//            [self.tableView reloadData];
//        } failure:^(int code, NSString *message) {
//            [Utils showAlert:message];
//        } complete:^{
//            [hud hide:YES];
//        }];
//    }
//    return _data;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/active" data:nil success:^(id json) {
        self.items = json;
        NSLog(@"社区活动---%@",json);
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
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *storeimage = (UIImageView *) [cell viewWithTag:10];
    [BctAPI image:storeimage andUrl:[[self.items objectAtIndex:indexPath.row] safeObjectForKey:@"image"]];
    
    UILabel *storename = (UILabel *) [cell viewWithTag:11];
    storename.text =[NSString stringWithFormat:@"%@",[[self.items objectAtIndex:indexPath.row]objectForKey:@"title"]];
    
    UILabel *address = (UILabel *) [cell viewWithTag:12];
    address.text = [NSString stringWithFormat:@"地址：%@",[[self.items objectAtIndex:indexPath.row]objectForKey:@"summary"]];
    
    UILabel *phone = (UILabel *) [cell viewWithTag:13];
    phone.text = [NSString stringWithFormat:@"联系电话：%@",[[self.items objectAtIndex:indexPath.row]objectForKey:@"author"]];
    
    UIImageView * background = (UIImageView *)[cell viewWithTag:14];
    background.image = [UIImage imageNamed:@"arrow.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goto" sender:[self.items objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goto"])
    {
        ActivityInfoViewController *vc = segue.destinationViewController;
        vc.data = sender;
    }
}

@end
