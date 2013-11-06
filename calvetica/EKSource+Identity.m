//
//  EKSource+Calvetica.m
//  calvetica
//
//  Created by Adam Kirk on 10/3/12.
//
//

#import "EKSource+Identity.h"

@implementation EKSource (Identity)

+ (EKSource *)defaultSource
{
    if (![EKEventStore isPermissionGranted]) return nil;
    NSArray *array = [EKEventStore sharedStore].sources;
    for (EKSource *source in array) {
        if (source.sourceType == EKSourceTypeLocal || source.sourceType == EKSourceTypeMobileMe) {
            return source;
        }
    }
    return [array lastObject];
}

- (NSString *)localizedTitle
{
	return [self.title isEqualToString:@"Default"] ? @"Local" : self.title;
}

@end
