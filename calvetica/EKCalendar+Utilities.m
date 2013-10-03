
#import "EKCalendar+Utilities.h"
#import "UIColor+Utilities.h"

@implementation EKCalendar (Utilities)

- (NSString *)account 
{
	return self.source.title;
}

- (BOOL)isASelectedCalendar 
{
	if ((self.allowedEntityTypes & EKEntityMaskEvent) == EKEntityMaskEvent) {
		NSMutableArray *selectedCalendars = [CVSettings selectedEventCalendars];
		for (EKCalendar *c in selectedCalendars) {
			if ([c.calendarIdentifier isEqualToString:self.calendarIdentifier]) {
				return YES;
			}
		}
	}
	else {
		NSMutableArray *selectedCalendars = [CVSettings selectedReminderCalendars];
		for (EKCalendar *c in selectedCalendars) {
			if ([c.calendarIdentifier isEqualToString:self.calendarIdentifier]) {
				return YES;
			}
		}
	}
	return NO;
}

- (UIColor *)customColor 
{
    return [UIColor colorWithCGColor:self.CGColor];
}

- (void)setCustomColor:(UIColor *)color 
{
    [CVSettings setCustomColor:color forCalendar:self];
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
	return NSLocalizedString(@"LOCAL",@"The calendar's type:LOCAL");
}

- (NSInteger)indexOfCalendarEditable:(BOOL)editable 
{
    NSArray *cals = editable ? [CVEventStore editableCalendarsForEntityType:EKEntityMaskEvent] : [CVEventStore eventCalendars];
    for (EKCalendar *c in cals) {
        if ([c.calendarIdentifier isEqualToString:self.calendarIdentifier]) {
            return [cals indexOfObject:c];
        }
    }
    return 0;
}

- (BOOL)canAddAttendees 
{
    return self.allowsContentModifications;
}

- (BOOL)save
{
	return [CVEventStore saveCalendar:self] == nil;
}

- (BOOL)remove
{
	return [CVEventStore removeCalendar:self] == nil;
}

@end
