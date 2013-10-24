//
//  GVUserDefaults+Settings.m
//  calvetica
//
//  Created by Adam Kirk on 10/23/13.
//
//

#import "GVUserDefaults+Settings.h"

@implementation GVUserDefaults (Settings)
@dynamic showReminders;

- (NSString *)transformKey:(NSString *)key
{
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"CVUserDefault%@", key];
}

- (NSDictionary *)setupDefaults {
    return @{
             @"showReminders": @YES
             };
}

@end
