//
//  JieDaoZhouBaoTableViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/9.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "JieDaoZhouBaoTableViewController.h"
#import "Sdk.h"
#import"MKNetworkKit.h"
#import "ZhouBaoTableViewController.h"

@interface JieDaoZhouBaoTableViewController ()

@end

@implementation JieDaoZhouBaoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MKNetworkEngine *engine  = [[MKNetworkEngine alloc] init];
    MKNetworkOperation *op = [engine operationWithURLString:@"http://218.249.192.55/jrj/index.php?file=list.xml"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
//        NSLog(@"[operation responseData]-->>%@", [operation responseJSON]);
        self.items = [[[[operation responseJSON] safeObjectForKey:@"data"] safeObjectForKey:@"items"] safeObjectForKey:@"item"];
        NSLog(@"%@",self.items);
        [self.tableView reloadData];
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];

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
    return [self.items count];
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    id item = [self.items objectAtIndex:indexPath.row];
    UILabel *lab1 = (UILabel *) [cell viewWithTag:1];
    UILabel *lab2 = (UILabel *) [cell viewWithTag:2];
    //UIImageView *iv = (UIImageView *) [cell viewWithTag:3];
    lab1.text = [NSString stringWithFormat:@"%@",[item safeObjectForKey:@"title"]];
    lab2.text = [NSString stringWithFormat:@"%@",[item safeObjectForKey:@"desc"]];
    
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
    if([segue.identifier isEqualToString:@"info"]){
        ZhouBaoTableViewController *v = segue.destinationViewController;
        v.data = sender;
        v.title = [sender safeObjectForKey:@"title"];
    }
}

@end
