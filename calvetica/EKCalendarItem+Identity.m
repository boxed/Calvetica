//
//  EKCalendarItem+Calvetica.m
//  calvetica
//
//  Created by Adam Kirk on 9/15/12.
//
//

#import "EKCalendarItem+Identity.h"

@implementation EKCalendarItem (Identity)

+ (EKCalendarItem *)calendarItemWithIdentifier:(NSString *)identifier
{
	EKCalendarItem *calendarItem = [[[EKEventStore sharedStore] calendarItemsWithExternalIdentifier:identifier] lastObject];
	if (!calendarItem)
		calendarItem = [[EKEventStore sharedStore] calendarItemWithIdentifier:identifier];
	return calendarItem;
}

- (BOOL)isEvent
{
	return [self isKindOfClass:[EKEvent class]] ? YES : NO;
}

- (BOOL)isReminder
{
    return [self isKindOfClass:[EKReminder class]] ? YES : NO;
}

- (NSString *)identifier
{
	NSString *identifier = nil;
	if (self.calendarItemExternalIdentifier)
		identifier = self.calendarItemExternalIdentifier;
	else if (self.calendarItemIdentifier)
		identifier = self.calendarItemIdentifier;

	return identifier;
}

- (BOOL)isEqualToCalendarItem:(EKCalendarItem *)calendarItem
{
	BOOL internal = [self.calendarItemIdentifier			isEqualToString:calendarItem.calendarItemIdentifier];
	BOOL external = [self.calendarItemExternalIdentifier	isEqualToString:calendarItem.calendarItemExternalIdentifier];
	return internal || external;
}

- (BOOL)hasIdentifier:(NSString *)identifier
{
	BOOL internal = [self.calendarItemIdentifier			isEqualToString:identifier];
	BOOL external = [self.calendarItemExternalIdentifier	isEqualToString:identifier];
	return internal || external;
}

@end
