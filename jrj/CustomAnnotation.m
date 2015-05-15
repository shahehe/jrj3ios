//
//  CustomAnnotation.m
//  map
//
//  Created by bct11-macmini on 15/2/3.
//  Copyright (c) 2015年 bct11-macmini. All rights reserved.
//

#import "CustomAnnotation.h"

@interface CustomAnnotation ()

@end

@implementation CustomAnnotation

@synthesize coordinate, title, subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coords
{
    if (self = [super init]) {
        coordinate = coords;
    }
    return self;
}


@end
