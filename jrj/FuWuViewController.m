//
//  FuWuViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/12.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "FuWuViewController.h"
#import "Sdk.h"
#import "FuWuXiangQingViewController.h"

@interface FuWuViewController ()

@end

@implementation FuWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"rest/article-list/%@",[self.data objectForKey:@"id"]];
    [BctAPI get:url data:nil success:^(id json) {
        //NSLog(@"%@",json);
        self.items = json;
        [self.tableView reloadData];
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) geData
{
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    id item = [self.items objectAtIndex:indexPath.row];
    UILabel *fwlabel = (UILabel *) [cell viewWithTag:22];
    UIImageView *fwimage = (UIImageView *) [cell viewWithTag:21];
    fwlabel.text = [NSString stringWithFormat:@"%@",[item safeObjectForKey:@"title"]];
    fwimage.image = [UIImage imageNamed:@"info4"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"info" sender:item];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"info"])
    {
        FuWuXiangQingViewController *v = segue.destinationViewController;
        v.data = sender;
        //v.title = [sender safeObjectForKey:@"title"];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
