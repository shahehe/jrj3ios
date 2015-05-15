//
//  CategoryViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/26.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "CategoryViewController.h"
#import "Sdk.h"
#import "CategoryArticleViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"/rest/article-list/%@",[self.data objectForKey:@"id"]];
    [BctAPI get:url data:nil success:^(id json) {
        NSLog(@"AAAAAAAAAAAAAAAAAAAA%@",json);
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Info" forIndexPath:indexPath];
    // Configure the cell...
    UILabel *la1 = (UILabel *)[cell viewWithTag:110];
    la1.text = [[self.items objectAtIndex:indexPath.row]objectForKey:@"title"];
    UIImageView *img1 = (UIImageView *) [cell viewWithTag:111];
    img1.image = [UIImage imageNamed:@"info4.png"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"gocate" sender:[self.items objectAtIndex:indexPath.row]];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gocate"]) {
        CategoryArticleViewController *vc = segue.destinationViewController;
        vc.data = sender;
    }
}


@end
