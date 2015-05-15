//
//  MapAnnotation.m
//  Yamss
//
//  Created by 廖兴旺 on 11-8-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BMapAnnotation.h"


@implementation BMapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate
{
    if(self == [super init]){
        coordinate = aCoordinate;
    }
    return self;
}
@end
