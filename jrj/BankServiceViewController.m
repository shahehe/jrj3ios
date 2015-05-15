//
//  BankServiceViewController.m
//  jrj
//
//  Created by bct11-macmini on 15/1/23.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "BankServiceViewController.h"
#import "Sdk.h"
#import "BankDynamicViewController.h"

@interface BankServiceViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *bankNameControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *introduceOrInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *iconScrollView;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, retain)NSDictionary *zhaoShangBank;
@property (nonatomic, retain)NSDictionary *guangFaBank;
@property (nonatomic, retain)NSArray *zhaoShangData;
@property (nonatomic, retain)NSArray *guangFaData;
@property (nonatomic, retain)NSArray *bankData;

@property (nonatomic, assign)int imageCounts;

@end

@implementation BankServiceViewController

- (void)getZhaoShangBank
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/bank/9/276" data:nil success:^(id json) {
        _zhaoShangBank = json;
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}
- (void)getGuangFaBank
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"/rest/bank/10/277" data:nil success:^(id json) {
        _guangFaBank = json;
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}

- (void)getZhaoShangData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"rest/bank/9" data:nil success:^(id json) {
        _zhaoShangData = json;
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];
}

- (void)getGuangFaData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BctAPI get:@"/rest/bank/10" data:nil success:^(id json) {
        _guangFaData = json;
    } failure:^(int code, NSString *message) {
        [Utils showAlert:message];
    } complete:^{
        [hud hide:YES];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 28)];
    titleLabel.text = @"招商银行";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 5;
    titleLabel.layer.borderColor = [UIColor blueColor].CGColor;
    titleLabel.layer.borderWidth = 1;
    [self.view addSubview:titleLabel];
    
    
    [self getGuangFaBank];
    [self getGuangFaData];
    [self getZhaoShangBank];
    [self getZhaoShangData];
    
    
    
    self.infoTableView.hidden = YES;
    
    [self setupView:self.zhaoShangBank];
    self.bankData = [self.zhaoShangData copy];
    [self.infoTableView reloadData];
    
    NSLog(@"+++++++++++++%d",(int)self.bankData.count);

    [self.bankNameControl addTarget:self action:@selector(clickBankNameControl) forControlEvents:UIControlEventValueChanged];
    [self.introduceOrInfo addTarget:self action:@selector(clickIntroduceOrInfo) forControlEvents:UIControlEventValueChanged];
}

- (void)clickBankNameControl
{
    switch (self.bankNameControl.selectedSegmentIndex) {
        case 0:
            [self getZhaoShangBank];
            [self setupView:self.zhaoShangBank];
            self.bankData = [self.zhaoShangData copy];
            [self.infoTableView reloadData];
            break;
        case 1:
            [self getGuangFaBank];
            [self setupView:self.guangFaBank];
            self.bankData = [self.guangFaData copy];
            [self.infoTableView reloadData];
            break;
        default:
            break;
    }
}

- (void)clickIntroduceOrInfo
{
    switch (self.introduceOrInfo.selectedSegmentIndex) {
        case 0:
            self.infoWebView.hidden = NO;
            self.iconScrollView.hidden = NO;
            self.infoTableView.hidden = YES;
            break;
        case 1:
            [self getZhaoShangData];
            self.infoWebView.hidden = YES;
            self.iconScrollView.hidden = YES;
            self.infoTableView.hidden = NO;
            [self.infoTableView reloadData];
            break;
        default:
            break;
    }
}

- (void)setupView:(NSDictionary *)bank
{
    self.iconScrollView.showsHorizontalScrollIndicator = NO;
    self.iconScrollView.showsVerticalScrollIndicator = NO;
    self.iconScrollView.pagingEnabled = YES;
    self.iconScrollView.delegate = self;
    
    CGFloat width = self.view.frame.size.width;
    int i=0;
    for(id img in [bank safeObjectForKey:@"thumbnail"]){
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, 160)];
        iconView.image = [UIImage imageNamed:@"no_image"];
        [BctAPI image:iconView andUrl:[[img safeObjectForKey:@"image"] safeObjectForKey:@"large"]];
        [self.iconScrollView addSubview:iconView];
        i++;
    }
    self.imageCounts = i;
    self.pageControl.numberOfPages = self.imageCounts;
    self.pageControl.currentPage = 0;
    self.iconScrollView.contentSize = CGSizeMake(width * [[bank safeObjectForKey:@"thumbnail"] count], 160);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    [self.infoWebView loadHTMLString:[bank objectForKey:@"content"] baseURL:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    UILabel *pronamelabel = (UILabel *) [cell viewWithTag:31];
    UILabel *disclabel = (UILabel *) [cell viewWithTag:32];
    UILabel *timelabel = (UILabel *) [cell viewWithTag:34];
    
    id item = self.bankData[indexPath.row];
    pronamelabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"title"]];
    disclabel.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"description"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval data = [[item objectForKey:@"create_time"] doubleValue];
    [timelabel setTextColor:[UIColor colorWithRed:241/255.0 green:133/255.0 blue:0 alpha:1]];
    timelabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data]];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankDynamicViewController *v = [[BankDynamicViewController alloc] init];
    v.data = self.bankData[indexPath.row];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)nextImage
{
    // 增加pagecontrol的页码
    int page = 0;
    if (self.pageControl.currentPage == self.imageCounts - 1) {
        page = 0;
    }else{
        page = (int)self.pageControl.currentPage + 1;
    }

    // 计算scrollview滚动位置
    CGFloat offsetX = page * self.view.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.iconScrollView setContentOffset:offset animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.pageControl.currentPage = page;
}

- (NSArray *)bankData
{
    if (_bankData == nil) {
        _bankData = [[NSArray alloc] init];
    }
    return _bankData;
}

- (NSDictionary *)zhaoShangBank
{
    if (_zhaoShangBank == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BctAPI get:@"rest/bank/9/276" data:nil success:^(id json) {
            _zhaoShangBank = json;
            [self.infoWebView loadHTMLString:[_zhaoShangBank objectForKey:@"content"] baseURL:nil];
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
        }];
    }
    return _zhaoShangBank;
}

- (NSDictionary *)guangFaBank
{
    if (_guangFaBank == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BctAPI get:@"/rest/bank/10/277" data:nil success:^(id json) {
            _guangFaBank = json;
            [self.infoWebView loadHTMLString:[_guangFaBank objectForKey:@"content"] baseURL:nil];
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
        }];
    }
    return _guangFaBank;
}

- (NSArray *)zhaoShangData
{
    if (_zhaoShangData == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BctAPI get:@"rest/bank/9" data:nil success:^(id json) {
            _zhaoShangData = json;
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
            [self setupView:_zhaoShangBank];
            self.bankData = [_zhaoShangData copy];
        }];
    }
    return _zhaoShangData;
}

- (NSArray *)guangFaData
{
    if (_guangFaData == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BctAPI get:@"/rest/bank/10" data:nil success:^(id json) {
            _guangFaData = json;
        } failure:^(int code, NSString *message) {
            [Utils showAlert:message];
        } complete:^{
            [hud hide:YES];
        }];
    }
    return _guangFaData;
}


@end
