//
//  CVEventStoreNotificationCenter.h
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//

#import "CVEventStoreNotification.h"

// notification key
extern NSString *const CVEventStoreChangedNotification;


@interface CVEventStoreNotificationCenter : NSObject
+ (instancetype)sharedCenter;
- (void)listenForNotificationAboutCalendarItem:(EKCalendarItem *)calendarItem
                                    changeType:(CVNotificationChangeType)type;
@end
