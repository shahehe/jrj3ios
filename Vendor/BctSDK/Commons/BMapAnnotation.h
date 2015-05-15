//
//  MapAnnotation.h
//  Yamss
//
//  Created by 廖兴旺 on 11-8-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BMapAnnotation : NSObject<MKAnnotation> {
    
}
-(id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;

@end
