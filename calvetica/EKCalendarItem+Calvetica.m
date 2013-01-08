//
//  EKCalendarItem+Calvetica.m
//  calvetica
//
//  Created by Adam Kirk on 9/15/12.
//
//

#import "EKCalendarItem+Calvetica.h"

@implementation EKCalendarItem (Calvetica)

+ (EKCalendarItem *)calendarItemWithIdentifier:(NSString *)identifier
{
	EKCalendarItem *calendarItem = [[[CVEventStore sharedStore].eventStore calendarItemsWithExternalIdentifier:identifier] lastObject];
	if (!calendarItem)
		calendarItem = [[CVEventStore sharedStore].eventStore calendarItemWithIdentifier:identifier];
	return calendarItem;
}

- (BOOL)isEvent
{
	return [self isKindOfClass:[EKEvent class]] ? YES : NO;
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
