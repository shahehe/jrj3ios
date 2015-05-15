//
//  BViewspot.h
//  xly
//
//  Created by 廖兴旺 on 14-7-18.
//  Copyright (c) 2014年 bctid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BCity : NSObject

@property(nonatomic,assign) int ids;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;

@end
