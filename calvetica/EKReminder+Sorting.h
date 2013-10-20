//
//  EKReminder+Sorting.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

@interface EKReminder (Sorting)
- (NSComparisonResult)compareWithReminder:(EKReminder *)reminder;
@end
