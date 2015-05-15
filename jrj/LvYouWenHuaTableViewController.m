//
//  LvYouWenHuaTableViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/11.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "LvYouWenHuaTableViewController.h"
#import "Sdk.h"
#import "TourismViewController.h"

@interface LvYouWenHuaTableViewController ()

@end

@implementation LvYouWenHuaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/travel" data:nil success:^(id json) {
        NSLog(@"%@",json);
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
    UILabel *lab1 = (UILabel *) [cell viewWithTag:10];
    UILabel *lab2 = (UILabel *) [cell viewWithTag:11];
    UIImageView *iv = (UIImageView *) [cell viewWithTag:12];
    lab1.text = [NSString stringWithFormat:@"%@",[item safeObjectForKey:@"name"]];
    lab2.text = [NSString stringWithFormat:@"%@",[item safeObjectForKey:@"intro"]];
    [BctAPI image:iv andUrl:[item safeObjectForKey:@"image"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"tourist" sender:item];
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
    if([segue.identifier isEqualToString:@"tourist"]){
        TourismViewController *v = segue.destinationViewController;
        v.title = [sender safeObjectForKey:@"name"];
        v.data = sender;
//        v.pointLongitude = [[sender safeObjectForKey:@"longitude"] doubleValue];
//        v.pointLatitude = [[sender safeObjectForKey:@"latitude"] doubleValue];
    }
}


@end
