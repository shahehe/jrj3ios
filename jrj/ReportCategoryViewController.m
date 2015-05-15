//
//  ReportCategoryViewController.m
//  fdemo
//
//  Created by jrj on 13-3-16.
//  Copyright (c) 2013年 jrj. All rights reserved.
//

#import "ReportCategoryViewController.h"
#import "MBProgressHUD.h"
#import "ApiService.h"
#import "ReportCategoryCell.h"
#import "ReportListViewController.h"
#import "Session.h"
#import "CheckConnection.h"
#import "Utils.h"

@interface ReportCategoryViewController ()

@end

@implementation ReportCategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([CheckConnection connected]){
        self.data = [Session sharedInstance].reportsData;
        if(self.data.count == 0){
            [self getData];
        }else{
            [self checkUpdate];
        }
        
        self.refreshControl = [[UIRefreshControl alloc]init];
        [self.refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
        [self.tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"product_line.png"]]];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    //取得缓存数据;
    [ApiService getReportList:^(ApiResult *result) {
        if([self.refreshControl isRefreshing]){
            [self.data removeAllObjects];
        }
        [self.data addObjectsFromArray:[[result.data valueForKey:@"items"] valueForKey:@"item"]];
        NSLog(@"-------%@",self.data);
        [self.tableView reloadData];
        if([self.refreshControl isRefreshing]){
            [self.refreshControl endRefreshing];
        }
        [self checkUpdate];
    } andFailure:^(int code, NSString *message) {
        [Utils showAlert:message];
    }];
}

-(void)checkUpdate
{
    [ApiService checkUpdate:^(ApiResult *result) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已经更新！";
        [hud hide:YES afterDelay:1];
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:[[result.data valueForKey:@"items"] valueForKey:@"item"]];
        [self.tableView reloadData];
        
    } andFailure:^(int code, NSString *message) {
        if(code == 1){
        }else{
            
            UIAlertView *av =[[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    id item = [self.data objectAtIndex:indexPath.row];
    [cell setData:item];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"wwwww%@",[self.data objectAtIndex:indexPath.row]);
    id sender = [self.data objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"list" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"list"]){
        ReportListViewController *v = segue.destinationViewController;
        v.item = sender;
        v.title = [sender valueForKey:@"title"];
    }
}

@end
