//
//  EKReminder+Store.m
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import "EKReminder+Store.h"
#import "CVEventStoreNotificationCenter.h"


@implementation EKReminder (Store)

- (BOOL)saveWithError:(NSError *__autoreleasing *)error
{
    CVNotificationChangeType type = self.isNew ? CVNotificationChangeTypeCreate : CVNotificationChangeTypeUpdate;
    [[CVEventStoreNotificationCenter sharedCenter] listenForNotificationAboutCalendarItem:self
                                                                               changeType:type];
    return [[EKEventStore sharedStore] saveReminder:self commit:YES error:error];
}

- (BOOL)deleteWithError:(NSError *__autoreleasing *)error
{
    CVNotificationChangeType type = self.isNew ? CVNotificationChangeTypeCreate : CVNotificationChangeTypeUpdate;
    [[CVEventStoreNotificationCenter sharedCenter] listenForNotificationAboutCalendarItem:self
                                                                               changeType:type];
    return [[EKEventStore sharedStore] removeReminder:self commit:YES error:error];
}

@end
