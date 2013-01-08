//
//  NSArray+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "NSArray+Utilities.h"
#import "NSDictionary+Utilities.h"


@implementation NSArray (NSArray_Utilities)

- (id)firstObject 
{
	if ([self lastObject]) {
		return [self objectAtIndex:0];
	}
	return nil;
}

- (NSArray *)JSONSafe 
{
    NSMutableArray *array = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSMutableArray class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            [array addObject:[object JSONSafe]];
        } else if ([object isKindOfClass:[NSString class]]) {
            [array addObject:object];
        }
        else if ([object isKindOfClass:[NSNumber class]]) {
            [array addObject:object];
        }
        else if ([object isKindOfClass:[NSDate class]]) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *stringValueOfDate = [formatter stringFromDate:object];
            [array addObject:stringValueOfDate];
        }
        else if ([object isKindOfClass:[NSNull class]]) {
            [array addObject:object];
        }
    }
    return array;
}


@end
