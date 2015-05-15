//
//  StringsJsonParser.m
//  financialDistrict
//
//  Created by USTB on 13-3-13.
//  Copyright (c) 2013年 USTB. All rights reserved.
//

#import "StringsJsonParser.h"



@implementation StringsJsonParser


+ (NSDictionary *) parseStringsJson: (NSString *)jsonfName{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonfName
                                                         ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:NULL];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if(jsonObject == nil){
        NSLog(@"error1");
    }
    else if (error !=nil){
        NSLog(@"error2");
    }
    else if(jsonObject != nil && error == nil){
       //NSLog(@"Successfully deserialized...");
        if([jsonObject isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
            //NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
            return deserializedDictionary;

        }
        else if([jsonObject isKindOfClass:[NSArray class]]){
           //NSArray *deserializedArray = (NSArray *)jsonObject;
           //NSLog(@"Dersialized JSON Array = %@", deserializedArray);
        }
        else{
           //NSLog(@"Error occured while deserializing the Json data");
        }
        
    }
    return nil;
}

@end
