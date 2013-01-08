//
//  NSJSONSerialization+Utilities.m
//  calvetica
//
//  Created by Adam Kirk on 12/14/11.
//  Copyright (c) 2011 Mysterious Trousers. All rights reserved.
//

#import "NSJSONSerialization+Utilities.h"
#import "NSDictionary+Utilities.h"
#import "NSArray+Utilities.h"

@implementation NSJSONSerialization (Utilities)

+ (NSString *)serialize:(id)obj {
    // create the JSON string
    id JSONObject = [obj JSONSafe];
    NSString *JSONString = nil;
    if ([NSJSONSerialization isValidJSONObject:JSONObject]) {
        NSError *JSONerror = nil;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSONObject options:0 error:&JSONerror];
        if ([JSONData length] > 1) {
            JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        }
    }
    return JSONString;
}

+ (id)unserializeData:(NSData *)JSONData {

    // if nothing is returned just return an empty array
    if ([JSONData length] <= 1) {
        return @[];
    }
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    if (error)
        return nil;
    else if (obj)
        return obj;
    else
        return @[];
}

+ (id)unserializeString:(NSString *)JSONString {
    
    // if nothing is returned just return an empty array
    if ([JSONString length] <= 1) {
        return @[];
    }
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error)
        return nil;
    else if (obj)
        return obj;
    else
        return @[];
}

@end
