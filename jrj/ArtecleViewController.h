//
//  ArtecleViewController.h
//  jrj
//
//  Created by BCT06 on 14/12/26.
//  Copyright (c) 2014年 bct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtecleViewController : UIViewController
@property(nonatomic,retain) IBOutlet UIWebView *articlewebview;
@property(nonatomic,retain) id data;
@property(nonatomic,retain) id items;

@end
