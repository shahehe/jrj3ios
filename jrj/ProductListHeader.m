//
//  ProductListHeader.m
//  jrj
//
//  Created by jrj on 13-3-25.
//  Copyright (c) 2013年 jrj. All rights reserved.
//

#import "ProductListHeader.h"

@implementation ProductListHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setData:(id)data
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"prouct_moth_bg"]];
    self.title.text = [data valueForKey:@"moth"];
}

@end
