//
//  YuXianTableViewController.m
//  jrj
//
//  Created by 廖兴旺 on 14/11/29.
//  Copyright (c) 2014年 bct. All rights reserved.
//
#import "YuXianTableViewController.h"
#import "Sdk.h"
#import "YuXianTableViewCell.h"
#import "CheckConnection.h"

@interface YuXianTableViewController ()
@end

@implementation YuXianTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [NSArray array];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.items.count == 0) [self getData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/image" data:nil success:^(id json) {
        NSLog(@"%@",json);
        self.items = json;
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
    return 80.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YuXianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setData:[self.items objectAtIndex:indexPath.row]];
    cell.tempViewController = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"web" sender:[self.items objectAtIndex:indexPath.row]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"web"]){
        WebViewController *v = segue.destinationViewController;
        v.titles = [sender safeObjectForKey:@"name"];
        v.content = [sender safeObjectForKey:@"content"];
        v.isNav = YES;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[sender safeObjectForKey:@"latitude"] doubleValue],[[sender safeObjectForKey:@"longitude"] doubleValue]);
        v.coordinate = coordinate;        
    }
}

@end
