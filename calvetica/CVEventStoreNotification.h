//
//  CVEventStoreNotification.h
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//


typedef NS_ENUM(NSUInteger, CVNotificationSource) {
    CVNotificationSourceUnknown,
    CVNotificationSourceInternal,
    CVNotificationSourceExternal
};

typedef NS_ENUM(NSUInteger, CVNotificationChangeType) {
    CVNotificationChangeTypeUnknown,
    CVNotificationChangeTypeCreate,
    CVNotificationChangeTypeUpdate,
    CVNotificationChangeTypeDelete
};


@interface CVEventStoreNotification : NSObject
@property (nonatomic, strong) EKCalendarItem           *calendarObject;
@property (nonatomic, assign) CVNotificationSource     source;
@property (nonatomic, assign) CVNotificationChangeType changeType;
@end
