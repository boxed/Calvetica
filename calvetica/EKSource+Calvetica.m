//
//  EKSource+Calvetica.m
//  calvetica
//
//  Created by Adam Kirk on 10/3/12.
//
//

#import "EKSource+Calvetica.h"
#import "CVEventStore.h"

@implementation EKSource (Calvetica)

- (BOOL)allowsCalendarAdditionsForEntityType:(EKEntityType)type
{
	@try {
		if ([self.title isEqualToString:@"Default"]) return NO;
		EKCalendar *calendar = [EKCalendar calendarForEntityType:type eventStore:[CVEventStore sharedStore].eventStore];
		calendar.source = self;
		NSError *error = nil;
		if(![[CVEventStore sharedStore].eventStore saveCalendar:calendar commit:NO error:&error]) return NO;
		if (error) return NO;
		[[CVEventStore sharedStore].eventStore removeCalendar:calendar commit:NO error:&error];
		return YES;
	}
	@catch (NSException *exception) {
		return NO;
	}
}

- (NSString *)localizedTitle
{
	return [self.title isEqualToString:@"Default"] ? @"Local" : self.title;
}


@end
