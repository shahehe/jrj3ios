//
//  StringsJsonParser.h
//  financialDistrict
//
//  Created by USTB on 13-3-13.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringsJsonParser : NSObject

+ (NSDictionary *) parseStringsJson:(NSString *)jsonfName;

@end
