//
//  EKEvent+Sorting.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKEvent (Sorting)
- (NSComparisonResult)compareWithEvent:(EKEvent *)event;
@end

NS_ASSUME_NONNULL_END
