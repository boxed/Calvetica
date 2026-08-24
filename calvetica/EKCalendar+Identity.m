//
//  EKCalendar+Identity.m
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import "EKCalendar+Identity.h"


@implementation EKCalendar (Identity)

+ (instancetype)calendarWithExternalIdentifier:(NSString *)externalIdentifier
{
    for (EKCalendar *calendar in [[EKEventStore sharedStore] mt_allCalendars]) {
        if ([calendar.calendarExternalIdentifier isEqualToString:externalIdentifier]) {
            return calendar;
        }
    }
    return nil;
}



#pragma mark - Public

#pragma mark (properties)

- (NSString *)calendarExternalIdentifier
{
    return self.calendarIdentifier;
    // freaking caused i tot crash on ios 13
//    return [NSString stringWithFormat:@"%d-%@-%d-%d-%@-%d-%d",
//            (int)self.allowsContentModifications,
//            self.title,
//            (int)self.type,
//            (int)self.allowedEntityTypes,
//            self.source.title,
//            (int)self.subscribed,
//            (int)self.supportedEventAvailabilities];
}

- (BOOL)isSystemGenerated
{
	if (self.type == EKCalendarTypeBirthday)						return YES;
	if (self.type == EKCalendarTypeSubscription)					return YES;
	if (self.subscribed)											return YES;
	if (self.source.sourceType == EKSourceTypeBirthdays)			return YES;
	if (self.source.sourceType == EKSourceTypeSubscribed)			return YES;
	// A local calendar the user can't write to isn't one they made: this is how
	// "Siri Found in Apps" and friends show up.
	if (self.source.sourceType == EKSourceTypeLocal && !self.allowsContentModifications) return YES;
	return NO;
}

- (NSString *)accountName
{
	return self.source.title;
}

- (NSString *)sourceString
{
	switch (self.source.sourceType) {
		case EKSourceTypeLocal:			return NSLocalizedString(@"LOCAL",			@"The calendar's type:LOCAL");
		case EKSourceTypeMobileMe:		return NSLocalizedString(@"ICLOUD",			@"The calendar's type:ICLOUD");
		case EKSourceTypeCalDAV:		return NSLocalizedString(@"CALDAV",			@"The calendar's type:CALDAV");
		case EKSourceTypeExchange:		return NSLocalizedString(@"EXCHANGE",		@"The calendar's type:EXCHANGE");
		case EKSourceTypeSubscribed:	return NSLocalizedString(@"SUBSCRIPTION",	@"The calendar's type:SUBSCRIPTION");
		case EKSourceTypeBirthdays:		return NSLocalizedString(@"BIRTHDAY",		@"The calendar's type:BIRTHDAY");
	}
	return NSLocalizedString(@"LOCAL", @"The calendar's type:LOCAL");
}


@end
