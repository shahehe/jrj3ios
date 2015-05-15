//
//  ShiYaoAnQuanViewController.m
//  jrj
//
//  Created by BCT06 on 14/12/17.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import "ShiYaoAnQuanViewController.h"
#import "ProductListHeader.h"
#import "ApiService.h"
#import "Sdk.h"
#import "XiaJiaXiangQingViewController.h"
#import "ProductListHeader.h"
#import "InfoListViewController.h"
#import "LicenseViewController.h"
#import "LicenseInfoViewController.h"

@interface ShiYaoAnQuanViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playPhone;
- (IBAction)playPhoneClick;
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,copy)NSString *drugInfo;
@property(nonatomic,copy)NSString *drugData;
@property (nonatomic, retain)NSMutableArray *mutableData3;
@end

@implementation ShiYaoAnQuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.protableview.delegate = self;
    self.protableview.dataSource = self;
    self.protableview.hidden = YES;
    [self getData1];
    [self getData2];
    [self getData];
    [self getData3];
    
    [self.protableview setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"product_line.png"]]];
    self.protableview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.describewebciew loadHTMLString:self.drugInfo baseURL:nil];
    [self.segmented addTarget:self action:@selector(clickSegmented) forControlEvents:UIControlEventValueChanged];
    
    self.mutableData3 = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)getData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/medicinal/90" data:nil success:^(id json) {
        self.drugData = [json objectForKey:@"author"];
        NSString *drugInfo = [json objectForKey:@"content"];
        self.drugInfo = drugInfo;
        [self.describewebciew loadHTMLString:_drugInfo baseURL:nil];
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
    }];
}
-(void) getData1{
    [ApiService getProductList:^(ApiResult *result) {
        self.items = [result.data safeObjectForKey:@"products"];
        //NSLog(@"%@",self.items);
        [self.protableview reloadData];
        NSLog(@"%lu",(unsigned long)self.items.count);
    } andFailure:^(int code, NSString *message) {
    }withUrl:@"Product.getList"];
}

-(void) getData2{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/medicinal" data:nil success:^(id json) {
        //NSLog(@"%@",json);
        self.item2 = json;
        [self.protableview reloadData];
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}
-(void) getData3{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/category-list/2" data:nil success:^(id json) {
        self.item3 = json;
        for (int i = 0; i<self.item3.count; i++) {
            if ([[self.item3[i] objectForKey:@"pid"] intValue] != 0){
                [self.mutableData3 addObject:self.item3[i]];
            }
        }
//        NSLog(@"zzzzzz%@",self.mutableData3);
        [self.protableview reloadData];
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}

-(void)clickSegmented{
    switch (self.segmented.selectedSegmentIndex) {
        case 0:
            self.protableview.hidden = YES;
            self.describewebciew.hidden = NO;
            self.playPhone.hidden = NO;
            [self getData];
            [self.describewebciew loadHTMLString:self.drugInfo baseURL:nil];
            break;
        case 1:
            [self.protableview reloadData];
            self.playPhone.hidden = YES;
            self.protableview.hidden = NO;
            self.describewebciew.hidden = YES;
            break;
        case 2:
            [self.protableview reloadData];
            self.playPhone.hidden = YES;
            self.protableview.hidden = NO;
            self.describewebciew.hidden = YES;
            break;
        case 3:
            [self.protableview reloadData];
            self.playPhone.hidden = YES;
            self.protableview.hidden = NO;
            self.describewebciew.hidden = YES;
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.segmented.selectedSegmentIndex == 2) {
        return self.items.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (self.segmented.selectedSegmentIndex == 2) {
        return [[[self.items objectAtIndex:section] objectForKey:@"items"]count];
    }else if ((self.segmented.selectedSegmentIndex == 1)){
        return self.item2.count;
    } else {
        return self.mutableData3.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmented.selectedSegmentIndex == 2) {
        return 80;
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
    
    if (self.segmented.selectedSegmentIndex == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *pronamelabel = (UILabel *) [cell viewWithTag:31];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        [[cell viewWithTag:32] setHidden:NO];
        [[cell viewWithTag:33] setHidden:YES];
        [[cell viewWithTag:34] setHidden:YES];
        [[cell viewWithTag:35] setHidden:YES];
        UILabel *disclabel = (UILabel *) [cell viewWithTag:32];
        id item = [[[self.items objectAtIndex:indexPath.section]objectForKey:@"items"] objectAtIndex:indexPath.row];
        pronamelabel.text = [NSString stringWithFormat:@"%@:%@",[item objectForKey:@"number"],[item objectForKey:@"name"]];
        disclabel.text = [NSString stringWithFormat:@"商标：%@；标注生产单位名称：%@；规格型号：%@",[item valueForKey:@"brand"],[item valueForKey:@"company"],[item valueForKey:@"model"]];
        return  cell;
    }else if ((self.segmented.selectedSegmentIndex == 1)){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *pronamelabel = (UILabel *) [cell viewWithTag:31];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        [[cell viewWithTag:32] setHidden:YES];
        [[cell viewWithTag:33] setHidden:NO];
        [[cell viewWithTag:34] setHidden:NO];
        [[cell viewWithTag:35] setHidden:NO];
        UILabel *timelabel = (UILabel *)[cell viewWithTag:34];
        UILabel *disclabel = (UILabel *) [cell viewWithTag:35];
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
        UINib *nib = [UINib nibWithNibName:@"LicenseViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"Cells"];
        
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"Cells"];
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *label = (UILabel *)[cell viewWithTag:21];
        id itm3 = [self.mutableData3 objectAtIndex:indexPath.row];
        label.text = [itm3 objectForKey:@"name"];
        UIImageView *image2 = (UIImageView *)[cell viewWithTag:20];
        image2.image = [UIImage imageNamed:@"info4"];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmented.selectedSegmentIndex == 2) {
        id item = [[[self.items objectAtIndex:indexPath.section]objectForKey:@"items"]objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"info" sender:item];
    }else if ((self.segmented.selectedSegmentIndex == 1)){
        id item2 = [self.item2 objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"goinfo" sender:item2];
    }else if ((self.segmented.selectedSegmentIndex == 3)){
        id item3 = [self.mutableData3 objectAtIndex:indexPath.row];
        if ([[item3 objectForKey:@"type"] isEqualToString:@"article"]) {
            [self performSegueWithIdentifier:@"info2" sender:item3];
        } else {
            [self performSegueWithIdentifier:@"license" sender:item3];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"info"])
    {
        XiaJiaXiangQingViewController *v =  segue.destinationViewController;
        v.data = sender;
        //[v.xjxqwebview loadHTMLString:[v.data objectForKey:@"content"] baseURL:nil];
    }else if([segue.identifier isEqualToString:@"goinfo"]){
        InfoListViewController *v2 = segue.destinationViewController;
        v2.data = sender;
    } else if([segue.identifier isEqualToString:@"license"]){
        LicenseViewController *v3 = segue.destinationViewController;
        v3.data = sender;
    }   else if([segue.identifier isEqualToString:@"info2"]){
        LicenseInfoViewController *v3 = segue.destinationViewController;
        v3.data = sender;
    }
}
- (IBAction)playPhoneClick {

    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.drugData]]]];

}
@end
