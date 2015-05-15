//
//  gongShangServiceViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/1/22.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "gongShangServiceViewController.h"
#import "ProductListHeader.h"
#import "ApiService.h"
#import "Sdk.h"
#import "remindInfoViewController.h"
#import "ProductListHeader.h"
#import "dynamicInfoViewController.h"
#import "InfoViewController.h"

@interface gongShangServiceViewController ()
@property(nonatomic,retain) IBOutlet UISegmentedControl *segmented;
@property(nonatomic,retain) IBOutlet UITableView *proTableView;

@property(nonatomic,copy)NSString *serviceInfo;

@property(nonatomic,retain) NSArray *item1;
@property(nonatomic,retain) NSArray *items;
@property(nonatomic,retain) NSArray *item2;
@end

@implementation gongShangServiceViewController

//- (NSString *)serviceInfo
//{
//    if (_serviceInfo == nil) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [BctAPI get:@"rest/administration/94" data:nil success:^(id json) {
//            _serviceInfo = [json objectForKey:@"content"];
//            [self.describeWebView loadHTMLString:_serviceInfo baseURL:nil];
//        } failure:^(int code, NSString *message) {
//            [Utils showAlert:message];
//        } complete:^{
//            [hud hide:YES];
//        }];
//    }
//    return _serviceInfo;
//}

- (NSArray *)item1
{
    if (_item1 == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BctAPI get:@"rest/administration_info" data:nil success:^(id json) {
            _item1 = json;
            [self.proTableView reloadData];
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
        }];

    }
    return _item1;
}

- (NSArray *)items
{
    if (_items == nil) {
        [ApiService getProductList:^(ApiResult *result) {
            _items = [result.data safeObjectForKey:@"commerce"];
            [self.proTableView reloadData];
        } andFailure:^(int code, NSString *message) {
        }withUrl:@"Commerce.getList"];
    }
    return _items;
}
- (NSArray *)item2
{
    if (_item2 == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BctAPI get:@"rest/administration" data:nil success:^(id json) {
            _item2 = json;
            NSLog(@"%@",json);
            [self.proTableView reloadData];
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
        }];
    }
    return _item2;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segmented addTarget:self action:@selector(clickSegmented) forControlEvents:UIControlEventValueChanged];
//    [self item1];
    [self.proTableView reloadData];
    [self.proTableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"product_line.png"]]];
    self.proTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}

-(void)clickSegmented{
    switch (self.segmented.selectedSegmentIndex) {
        case 0:
            [self item1];
            [self.proTableView reloadData];
            break;
        case 1:
            [self items];
            [self.proTableView reloadData];
            break;
        case 2:
            [self item2];
            [self.proTableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.segmented.selectedSegmentIndex == 2) {
        return self.items.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmented.selectedSegmentIndex == 2) {
        return [[[self.items objectAtIndex:section] objectForKey:@"items"]count];
    }else if (self.segmented.selectedSegmentIndex == 1){
        return self.item2.count;
    } else
    {
        return self.item1.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmented.selectedSegmentIndex == 2) {
        return 60;
    }else{
        return 60;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.segmented.selectedSegmentIndex == 2) {
        return 32.0f;
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.segmented.selectedSegmentIndex == 2) {
        ProductListHeader *v = [[[NSBundle mainBundle] loadNibNamed:@"ProductListHeader" owner:self options:nil] lastObject];
        [v setData:[self.items objectAtIndex:section]];
        return v;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    if (self.segmented.selectedSegmentIndex == 2) {
        UILabel *pronamelabel = (UILabel *) [cell viewWithTag:31];
        UILabel *disclabel = (UILabel *) [cell viewWithTag:32];
        [[cell viewWithTag:31] setHidden:NO];
        [[cell viewWithTag:32] setHidden:NO];
        [[cell viewWithTag:33] setHidden:YES];
        [[cell viewWithTag:34] setHidden:YES];
        [[cell viewWithTag:35] setHidden:YES];
        id item = [[[self.items objectAtIndex:indexPath.section]objectForKey:@"items"] objectAtIndex:indexPath.row];
        pronamelabel.text = [NSString stringWithFormat:@"%@:%@",[item objectForKey:@"number"],[item objectForKey:@"title"]];
        disclabel.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"content"]];
        return  cell;
    }else if (self.segmented.selectedSegmentIndex == 1) {
        UILabel *pronamelabel = (UILabel *) [cell viewWithTag:31];
        UILabel *disclabel = (UILabel *) [cell viewWithTag:32];
        UILabel *timelabel = (UILabel *) [cell viewWithTag:35];
        [[cell viewWithTag:31] setHidden:NO];
        [[cell viewWithTag:32] setHidden:NO];
        [[cell viewWithTag:33] setHidden:NO];
        [[cell viewWithTag:34] setHidden:YES];
        [[cell viewWithTag:35] setHidden:NO];
        id itm2 = [self.item2 objectAtIndex:indexPath.row];
        pronamelabel.text = [itm2 objectForKey:@"title"];
        disclabel.text = [itm2 objectForKey:@"description"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSTimeInterval data = [[itm2 objectForKey:@"create_time"] doubleValue];
        [timelabel setTextColor:[UIColor colorWithRed:241/255.0 green:133/255.0 blue:0 alpha:1]];
        timelabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data]];
        
        return cell;
    } else {
        [[cell viewWithTag:31] setHidden:YES];
        [[cell viewWithTag:32] setHidden:YES];
        [[cell viewWithTag:33] setHidden:YES];
        [[cell viewWithTag:34] setHidden:NO];
        [[cell viewWithTag:35] setHidden:YES];
        UILabel *pronamelabel = (UILabel *) [cell viewWithTag:34];
        pronamelabel.text = [[self.item1 objectAtIndex:indexPath.row] objectForKey:@"title"];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmented.selectedSegmentIndex == 2) {
        id item = [[[self.items objectAtIndex:indexPath.section]objectForKey:@"items"]objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"goinfo" sender:item];
    }else if (self.segmented.selectedSegmentIndex == 1){
        id itm2 = [self.item2 objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"info" sender:itm2];
    } else {
        InfoViewController *vc = [[InfoViewController alloc] init];
        vc.str = [[self.item1 objectAtIndex:indexPath.row] objectForKey:@"content"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goinfo"])
    {
        remindInfoViewController *v =  segue.destinationViewController;
        v.data = sender;
    }else if([segue.identifier isEqualToString:@"info"]){
        dynamicInfoViewController *v2 = segue.destinationViewController;
        v2.data = sender;
    }
}



@end
