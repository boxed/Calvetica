//
//  EKReminder+Sorting.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKReminder (Sorting)
- (NSComparisonResult)compareWithReminder:(EKReminder *)reminder;
@end

NS_ASSUME_NONNULL_END
