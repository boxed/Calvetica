//
//  NSDictionary+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "NSDictionary+Utilities.h"
#import "NSArray+Utilities.h"


@implementation NSDictionary (Utilities)

- (NSString *)stringForKey:(NSString *)key 
{
	id s = [self objectForKey:key];
	if ((NSNull *)s == [NSNull null]) {
		return @"";
	}
	return (NSString *)s;
}

- (NSDictionary *)JSONSafe 
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    NSEnumerator *enumerator = [self keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSMutableArray class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            [dict setObject:[object JSONSafe] forKey:key];
        } else if ([object isKindOfClass:[NSString class]]) {
            [dict setObject:object forKey:key];
        }
        else if ([object isKindOfClass:[NSNumber class]]) {
            [dict setObject:object forKey:key];
        }
        else if ([object isKindOfClass:[NSDate class]]) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *stringValueOfDate = [formatter stringFromDate:object];
            [dict setObject:stringValueOfDate forKey:key];
        }
        else if ([object isKindOfClass:[NSNull class]]) {
            [dict setObject:object forKey:key];
        }
    }
    
    return dict;
}

@end
