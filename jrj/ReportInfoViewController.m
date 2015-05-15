//
//  ReportInfoViewController.m
//  fdemo
//
//  Created by jrj on 13-3-16.
//  Copyright (c) 2013年 jrj. All rights reserved.
//

#import "ReportInfoViewController.h"
#import "ApiService.h"

@interface ReportInfoViewController ()

@end

@implementation ReportInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for( UIView *view in [self.webView subviews] ) {
        if( [view isKindOfClass:[UIScrollView class]] ) {
            for( UIView *innerView in [view subviews] ) {
                if( [innerView isKindOfClass:[UIImageView class]] ) {
                    innerView.hidden = YES;
                }
            }
        }
    }
    [self showData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showData
{
    //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableString *html = [NSMutableString stringWithCapacity:0];
    [html appendString:@"<!DOCTYPE HTML><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"> </head><style>img{width:100%;}</style><body >"];
    //[html appendString:@"<!DOCTYPE HTML><html><head><style>img{width:100%}</style></head><body>"];
    [html appendFormat:@"<h3 contenteditable=\"true\" style=\"padding:0px;margin:0px;text-align:center;\" id=\"title\">%@</h3><hr style=\"color:#666\"/><div style=\"text-align:right;\"><small>%@</small></div>",[self.item valueForKey:@"title"],[self.item valueForKey:@"date"]];
    
    [html appendFormat:@"<div id=\"content\" contenteditable=\"false\">%@</div>",[self.item valueForKey:@"content"]];
    NSString *img = [self.item valueForKey:@"image"];
    if([img length] > 4){
        NSString *url = [NSString stringWithFormat:@"http://%@/jrj/image/%@",[ApiService sharedInstance].host,img];
        [html appendFormat:@"<div><img style=\"width:100%%\" src=\"%@\" /></div>",url];
    }
    
    [html appendString:@"</body></html>"];
    // NSLog(@"html:%@",html);
    [self.webView loadHTMLString:html baseURL:nil];
}

@end
