
#import "EKEvent+Utilities.h"
#import "NSString+Utilities.h"
#import "times.h"
#import "strings.h"


@implementation EKEvent (Utilities)

- (void)setStartingDate:(NSDate *)startingDate
{
	self.startDate = startingDate;
	if ([self.startingDate mt_isAfter:self.endingDate]) {
        self.endingDate = [self.startingDate copy];
    }
}

- (NSDate *)startingDate
{
    return self.startDate;
//	NSDate *date = self.startDate;
//	return self.allDay ? [self.startDate mt_startOfCurrentDay] : date;
}

- (void)setEndingDate:(NSDate *)endingDate
{
	self.endDate = endingDate;
	if ([self.startingDate mt_isAfter:self.endingDate]) {
        self.startingDate = [self.endingDate copy];
    }
}

- (NSDate *)endingDate
{
    return self.endDate;
//	NSDate *date = self.endDate;
//	return self.allDay ? [self.endDate mt_endOfCurrentDay] : date;
}





#pragma mark - CONSTRUCTORS

+ (EKEvent *)eventWithDefaultsAtDate:(NSDate *)date allDay:(BOOL)isAllDay
{
    return [EKEvent eventWithDefaultsAtStartDate:date
                                         endDate:[date dateByAddingTimeInterval:[CVSettings defaultDuration]]
                                          allDay:isAllDay
                                        calendar:[CVSettings defaultEventCalendar]];
}

+ (EKEvent *)eventWithDefaultsAtStartDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)isAllDay
{
    return [EKEvent eventWithDefaultsAtStartDate:startDate
                                         endDate:endDate
                                          allDay:isAllDay
                                        calendar:[CVSettings defaultEventCalendar]];
}

+ (EKEvent *)eventWithDefaultsAtStartDate:(NSDate *)startDate
                                  endDate:(NSDate *)endDate
                                   allDay:(BOOL)isAllDay
                                 calendar:(EKCalendar *)cal
{
    EKEvent *event = [EKEventStore event];
    
    if (cal) {
        event.calendar = cal;
    }
    else {
        event.calendar = [CVSettings defaultEventCalendar];
    }
    event.title = @"Untitled"; 
    
    NSArray *defaultAlarms;
    
    if (isAllDay) {
        defaultAlarms = [CVSettings defaultAllDayEventAlarms];
        if (event.calendar.source.sourceType == EKSourceTypeExchange && ![CVSettings multipleExchangeAlarms] && defaultAlarms.count > 0) {
            NSNumber *number = [defaultAlarms firstObject];
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[number integerValue]]];
        }
        else {
            for (NSNumber *number in defaultAlarms) {
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:[number integerValue]]];
            } 
        }
    }
    else {
        defaultAlarms = [CVSettings defaultEventAlarms];
        if (event.calendar.source.sourceType == EKSourceTypeExchange && ![CVSettings multipleExchangeAlarms] && defaultAlarms.count > 0) {
            
            NSNumber *number = [defaultAlarms firstObject];
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:-[number integerValue]]];
        }
        else {
            for (NSNumber *number in defaultAlarms) {
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:-[number integerValue]]];
            } 
        }
    }

	if (PREFS.timezoneSupportEnabled) event.timeZone = [CVSettings timezone];

    event.startingDate = startDate;
    if (endDate) {
        event.endingDate = endDate;
    }
    else {
        event.endingDate = [event.startingDate dateByAddingTimeInterval:[CVSettings defaultDuration]];
    }
    event.allDay = isAllDay;
    
    return event;
}




#pragma mark - Methods

- (BOOL)hadRecurrenceRuleOnPreviousSave 
{
	EKEvent *e = [EKEventStore eventWithIdentifier:self.identifier];
	return e != nil && e.hasRecurrenceRules;
}

- (void)shiftEndDateBySettingStartDate:(NSDate *)newDate 
{
    NSTimeInterval shift = [newDate timeIntervalSinceDate:self.startingDate];
    
    if (shift >= 0) {
        self.endingDate = [NSDate dateWithTimeInterval:shift sinceDate:self.endingDate];
        self.startingDate = newDate;
    } else {
        self.startingDate = newDate;
        self.endingDate = [NSDate dateWithTimeInterval:shift sinceDate:self.endingDate];
    }
}

- (void)addSnoozeAlarmWithTimeInterval:(NSTimeInterval)interval 
{
    if (interval > 0) {
		NSDate *whenToGoOff = [NSDate dateWithTimeIntervalSinceNow:interval];
		NSTimeInterval offset = [self.startingDate timeIntervalSinceDate:whenToGoOff];
        [self addAlarm:[EKAlarm alarmWithRelativeOffset:-offset]];
    }
    else {
        [self addAlarm:[EKAlarm alarmWithRelativeOffset:0]];
    }
}

- (void)resetDefaultAlarms 
{
    NSMutableArray *newAlarms = [NSMutableArray new];
    self.alarms = nil;
    if (self.isAllDay) {
        if (self.calendar.source.sourceType == EKSourceTypeExchange && newAlarms.count > 0) {
            NSNumber *number = [[CVSettings defaultAllDayEventAlarms] firstObject];
            [newAlarms addObject:[EKAlarm alarmWithRelativeOffset:[number integerValue]]];
        }
        else {
            for (NSNumber *time in [CVSettings defaultAllDayEventAlarms]) {
                [newAlarms addObject:[EKAlarm alarmWithRelativeOffset:[time integerValue]]];
            }
        }
    }
    else {
        if (self.calendar.source.sourceType == EKSourceTypeExchange && newAlarms.count > 0) {
            NSNumber *number = [[CVSettings defaultEventAlarms] firstObject];
            [newAlarms addObject:[EKAlarm alarmWithRelativeOffset:-[number integerValue]]];
        }
        else {
            for (NSNumber *number in [CVSettings defaultEventAlarms]) {
                [newAlarms addObject:[EKAlarm alarmWithRelativeOffset:-[number integerValue]]];
            }
        }
    }
    
    self.alarms = newAlarms;
}

- (void)resetDurationToDefault 
{
    self.endingDate = [self.startingDate dateByAddingTimeInterval:[CVSettings defaultDuration]];
}

- (BOOL)isACurrentAlarm:(EKAlarm *)alarm 
{
    NSTimeInterval alarmRelativeOffset = alarm.relativeOffset;
    if (alarm.absoluteDate) {
        alarmRelativeOffset = [alarm.absoluteDate timeIntervalSinceDate:self.startingDate];
    }
    
    for (EKAlarm *a in self.alarms) {
        NSTimeInterval aRelativeOffset = a.relativeOffset;
        if (a.absoluteDate) {
            aRelativeOffset = [a.absoluteDate timeIntervalSinceDate:self.startingDate];
        }
        if (alarmRelativeOffset == aRelativeOffset) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - COMPARATORS






#pragma mark - UTILITIES

- (EKCalendar *)readCalendar 
{
	EKCalendar *c = self.calendar;
	if (!c) {
		NSString *hack = [NSString stringWithFormat:@"%@",self];
		if(hack){
            c = self.calendar;
        }
	}
	return c;
}

- (NSTimeInterval)eventDuration 
{
    return (NSTimeInterval)abs([self.startingDate timeIntervalSinceDate:self.endingDate]);
}


- (BOOL)fitsWithinWeekOfDate:(NSDate *)date 
{
	return [self.startingDate mt_isWithinSameWeek:date] && [self.endingDate mt_isWithinSameWeek:date];
}

- (BOOL)willBeABar 
{
    return YES;
	BOOL isAnAllDayEvent            = [self spansEntireDayOfOnlyDate:self.startingDate] || self.allDay;
	BOOL isGreaterThanThreshold     = [self eventDuration] >= MIN_EVENT_DURATION;
	BOOL fitsWithinItsStartDay      = [self fitsWithinDayOfDate:self.startingDate];
	BOOL isReadOnly                 = !self.calendar.allowsContentModifications;
	BOOL settingAllowsBar           = PREFS.showDurationOnReadOnlyEvents;
	BOOL isBirthday                 = self.calendar.type == EKCalendarTypeBirthday;
	
			// if its an all day event of only one day (because this is the one case that should pass, but all else will fail in the next test)
    return (isAnAllDayEvent || 
	
			// if it is longer than the threshold duration and it does not completely fit inside the day in which it starts (we only show bars for events that span mutliple days)
			(isGreaterThanThreshold && !fitsWithinItsStartDay)) && 

			// and its either not read only or the setting allows read only events to be bars
			(!isReadOnly || settingAllowsBar || isBirthday);
}




#pragma mark - STRINGS

- (NSString *)availabilityAsString 
{
    if (self.availability == EKEventAvailabilityBusy) {
        return AVAILABILITY_BUSY;
    } else if (self.availability == EKEventAvailabilityFree) {
        return AVAILABILITY_FREE;
    } else if (self.availability == EKEventAvailabilityTentative) {
        return AVAILABILITY_TENTATIVE;
    } else if (self.availability == EKEventAvailabilityUnavailable) {
        return AVAILABILITY_UNAVAILABLE;
    } else {
        return AVAILABILITY_NOT_AVAILABLE;
    }
}

- (NSString *)stringForParticipantStatus: (EKParticipantStatus)status 
{
    switch (status) {
        case EKParticipantStatusUnknown: return NSLocalizedString(@"UNKNOWN", @"When the participant's status is UNKNOWN");
        case EKParticipantStatusPending: return NSLocalizedString(@"PENDING", @"When the participant's status is PENDING");
        case EKParticipantStatusAccepted: return NSLocalizedString(@"ACCEPTED", @"When the participant's status is ACCEPTED");
        case EKParticipantStatusTentative: return NSLocalizedString(@"TENTATIVE", @"When the participant's status is TENTATIVE");
        case EKParticipantStatusDelegated: return NSLocalizedString(@"DELEGATED", @"When the participant's status is DELEGATED");
        case EKParticipantStatusCompleted: return NSLocalizedString(@"COMPLETED", @"When the participant's status is COMPLETED");
        case EKParticipantStatusInProcess: return NSLocalizedString(@"INPROCESS", @"When the participant's status is INPROCESS");
        default: return NSLocalizedString(@"UNKNOWN", @"When the participant's status is UNKNOWN");
    }
}

- (NSString *)stringForParticipantRole: (EKParticipantRole)role 
{
    switch (role) {
        case EKParticipantRoleUnknown: return NSLocalizedString(@"UNKNOWN", @"When the participant's role is UNKNOWN");
        case EKParticipantRoleRequired: return NSLocalizedString(@"Required", @"When the participant's role is required");
        case EKParticipantRoleOptional: return NSLocalizedString(@"Optional", @"When the participant's role is optional");
        case EKParticipantRoleChair: return NSLocalizedString(@"Chair", @"When the participant's role is chair");
        case EKParticipantRoleNonParticipant: return NSLocalizedString(@"Non-Participant", @"When the participant's role is non-participant");
        default: return NSLocalizedString(@"UNKNOWN", @"When the participant's role is UNKNOWN");
    }
}

- (NSString *)stringForParticipantRoleIcalFormat: (EKParticipantRole)role 
{
    switch (role) {
        case EKParticipantRoleUnknown: return @"UNKNOWN";
        case EKParticipantRoleRequired: return @"REQ-PARTICIPANT";
        case EKParticipantRoleOptional: return @"OPT-PARTICIPANT";
        case EKParticipantRoleChair: return @"CHAIR";
        case EKParticipantRoleNonParticipant: return @"NON-PARTICIPANT";
        default: return @"UNKNOWN";
    }
}

- (NSString *)stringForParticipantType: (EKParticipantType)role 
{
    switch (role) {
        case EKParticipantTypeUnknown: return NSLocalizedString(@"UNKNOWN", @"When the participant's type is UNKNOWN");
        case EKParticipantTypeRoom: return NSLocalizedString(@"ROOM", @"When the participant's type is room");
        case EKParticipantTypePerson: return NSLocalizedString(@"INDIVIDUAL", @"When the participant's type is an individual");
        case EKParticipantTypeGroup: return NSLocalizedString(@"GROUP", @"When the participant's type is a calendar ");
        case EKParticipantTypeResource: return NSLocalizedString(@"RESOURCE", @"When the participant's type is a resource");
        default: return NSLocalizedString(@"UNKNOWN", @"When the participant's type is UNKNOWN");
    }
}

- (NSString *)serialize 
{
    NSString *eventId = @"";
	NSString *serialized = @"";
	NSString *eventDescription = [NSString stringWithFormat:@"%@",self];
    
    eventId = self.identifier;
    serialized = [serialized stringByAppendingString:eventId];
    serialized = [serialized stringByAppendingString:@"*eid*"];
    
	NSArray *partsArray = [eventDescription componentsSeparatedByString:@"<"];
	if ([partsArray count] > 1) {
		for (__strong NSString *s in partsArray)
		{
			NSRange r = [s rangeOfString:@">"];
			if (r.location != NSNotFound) {
				s = [s substringFromIndex:r.location+1];
			}
			serialized = [serialized stringByAppendingString:s];
		}
	}
	return serialized;
}

- (NSString *)stringWithRelativeEndTime 
{

	NSString *hourAndMinute = [self.endingDate mt_stringFromDateWithHourAndMinuteFormat:(PREFS.twentyFourHourFormat ? MTDateHourFormat24Hour : MTDateHourFormat12Hour)];

    NSMutableString *string = [NSMutableString stringWithString:@"ENDS: "];

	if ([self.endingDate mt_isWithinSameDay:self.startingDate]) {
		[string appendString:hourAndMinute];
    }
    
    else {
        [string appendString:[self.endingDate mt_stringFromDateWithFullMonth]];
        [string appendString:@" "];
        [string appendFormat:@"%lu", (unsigned long)[self.endingDate mt_dayOfMonth]];
        [string appendString:@" "]; 
        [string appendString:hourAndMinute];
    }
    
    return string;
}

- (NSString *)stringWithRepeat 
{
    
    if (!self.hasRecurrenceRules) return nil;
    
    if ([(EKRecurrenceRule *)[self.recurrenceRules lastObject] frequency] == EKRecurrenceFrequencyDaily) {
        return @"DAILY";
    }
    else if ([(EKRecurrenceRule *)[self.recurrenceRules lastObject] frequency] == EKRecurrenceFrequencyMonthly) {
        return @"MONTHLY";
    }
    else if ([(EKRecurrenceRule *)[self.recurrenceRules lastObject] frequency] == EKRecurrenceFrequencyWeekly) {
        return @"WEEKLY";
    }
    else if ([(EKRecurrenceRule *)[self.recurrenceRules lastObject] frequency] == EKRecurrenceFrequencyYearly) {
        return @"YEARLY";
    }
    return nil;
}

- (NSString *)stringWithRelativeEndTimeAndRepeat 
{
    NSMutableString *string = [NSMutableString string];
    [string appendString:[self stringWithRelativeEndTime]];
    NSString *repeateString = [self stringWithRepeat];
    if (repeateString) {
        [string appendFormat:@" · %@", repeateString];
    }
    return string;
}

- (NSString *)stringWithLocation 
{
    return self.location;
}

- (NSString *)stringWithNotes 
{
    return self.notes;
}

- (NSString *)stringWithPeople 
{
    NSMutableString *peopleString = [NSMutableString string];
    for(EKParticipant *attendee in self.attendees){
        [peopleString appendFormat:@"%@, ", attendee.name];
    }
    return [peopleString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
}

- (NSString *)naturalDescription 
{
    NSMutableString *description = [NSMutableString string];
    
    // Event Title
    [description appendFormat:@"%@:\n %@\n\n",NSLocalizedString(@"Event", @"Description for an event will follow"), self.title];
    //Time
    if (!self.allDay) {
        
        NSString *startDate = nil;
        NSString *endDate = nil;
        if ([self.startingDate mt_isWithinSameDay:self.endingDate]) {
            startDate = [self.startingDate stringWithHourMinuteAndAMPM];
            endDate = [self.endingDate stringWithHourMinuteAndAMPM];
            [description appendFormat:@"%@:\n %@ %@ %@\n %@\n\n",NSLocalizedString(@"Time", @"The time for the event"),startDate, NSLocalizedString(@"to", @"between two times, example: 3 PM 'to' 4 PM"),endDate,[self.startingDate stringWithWeekdayMonthDayYearMonthAbbreviated:NO]];
        } else {
            startDate = [self.startingDate stringWithWeekdayMonthDayYearHourMinute];
            endDate = [self.endingDate stringWithWeekdayMonthDayYearHourMinute];
            [description appendFormat:@"%@:\n %@ %@\n %@\n\n",NSLocalizedString(@"Time", @"The time for the event"),startDate, NSLocalizedString(@"to", @"between two times, example: 3 PM 'to' 4 PM"),endDate];
        }
    }
    else {
        [description appendString:[NSString stringWithFormat:@"%@:\n %@\n %@\n\n",NSLocalizedString(@"Time", @"The time for the event"),NSLocalizedString(@"All-Day",@"Desciption for an event that lasts all day."),[self.startingDate stringWithWeekdayMonthDayYearMonthAbbreviated:NO]]];
    }
    
    // Location
    if (self.location) {
        [description appendFormat:@"%@:\n %@\n\n",NSLocalizedString(@"Location", @"Description for an event's location."), self.location];
    }
    
    // Availability
    if (self.availability > -1) {
        [description appendString:NSLocalizedString(@"Availibility:\n",@"The Event's availibility")];
        if (self.availability == EKEventAvailabilityBusy) {
            [description appendString:NSLocalizedString(@"Busy", @"Description when an event's availability is busy.")];
        } else if (self.availability == EKEventAvailabilityFree) {
            [description appendString:NSLocalizedString(@"Available", @"Description when an event's availability is free.")];
        } else if (self.availability == EKEventAvailabilityTentative) {
            [description appendString:NSLocalizedString(@"Tentative", @"Description when an event's availability is tentative.")];
        } else if (self.availability == EKEventAvailabilityUnavailable) {
            [description appendString:NSLocalizedString(@"Unavailable", @"Description when an event's availability is unavailable.")];
        }
        [description appendString:@"\n\n"];
    }
    
    // People
    if (self.attendees) {
        NSString *NA = NSLocalizedString(@"Unavailable",@"When the participant's name or email is not available");
        [description appendString:@"Participant"];
        if ([self.attendees count] > 1 ) {
            [description appendString:@"s:\n\n"];
        }
        else {
            [description appendString:@":\n\n"];
        }
        for (EKParticipant *attend in self.attendees) {
            NSString *attendeeEmail = [NSString string];
            NSString *attendeeName = attend.name;
            
            NSString *attendeesDetails = [NSString stringWithFormat:@"%@",attend];
            NSArray *partsArray = [attendeesDetails componentsSeparatedByString:@"email = "]; 
            if ([partsArray count] > 1) {
                NSString *secondHalf = [partsArray objectAtIndex:1];
                NSInteger loc = [secondHalf rangeOfString:@";"].location;
                if (loc > 0) {
                    attendeeEmail = [secondHalf substringToIndex:loc];
                }
            }
            [description appendFormat:@"%@: ",NSLocalizedString(@"Name",@"Name of the participant")];
            if (![attendeeName isEqualToString:attendeeEmail]) {
                [description appendFormat:@"%@\n",attend.name];
            }
            else {
                [description appendFormat:@"%@\n",NA];
            }
            [description appendFormat:@"%@: ",NSLocalizedString(@"Email",@"Email of the participant")];
            if (![attendeeEmail isEqualToString:@"(null)"]) {
                [description appendFormat:@"%@\n",attendeeEmail];
            }
            else { 
                [description appendFormat:@"%@\n",NA];
            }

            
            [description appendFormat:@"%@: %@\n",NSLocalizedString(@"Status",@"Status of the participant"),[[self stringForParticipantStatus:attend.participantStatus]capitalizedString]];
            [description appendFormat:@"%@: %@\n\n",NSLocalizedString(@"Role",@"Role of the participant"),[[self stringForParticipantRole:attend.participantRole]capitalizedString]];
        }
    }
    // Recurrence
    if (self.hasRecurrenceRules) {
        [description appendFormat:@"%@:\n %@\n\n",NSLocalizedString(@"Repeats", @"Description for an event's recurrence."), [[self.recurrenceRules lastObject] naturalDescription]];
    }
    
    // Notes
    if (self.notes) {
        [description appendFormat:@"%@:\n %@\n\n",NSLocalizedString(@"Notes", @"Description for an event's notes."), self.notes];
    }
    
    return description;
}

- (NSString *)naturalDescriptionSMS 
{
    NSMutableString *description = [NSMutableString string];
    
    // Event Title
    [description appendFormat:@"%@:\n%@\n",NSLocalizedString(@"Event", @"Description for an event will follow"), self.title];
    //Time
    if (!self.allDay) {
        
        NSString *startDate = nil;
        NSString *endDate = nil;
        if ([self.startingDate mt_isWithinSameDay:self.endingDate]) {
            startDate = [self.startingDate stringWithHourMinuteAndAMPM];
            endDate = [self.endingDate stringWithHourMinuteAndAMPM];
            [description appendFormat:@"%@:\n%@ %@ %@\n %@\n",NSLocalizedString(@"Time", @"The time for the event"),startDate, NSLocalizedString(@"to", @"between two times, example: 3 PM 'to' 4 PM"),endDate,[self.startingDate stringWithWeekdayMonthDayYearMonthAbbreviated:NO]];
        } else {
            startDate = [self.startingDate stringWithWeekdayMonthDayYearHourMinute];
            endDate = [self.endingDate stringWithWeekdayMonthDayYearHourMinute];
            [description appendFormat:@"%@:\n %@ %@ %@\n",NSLocalizedString(@"Time", @"The time for the event"),startDate, NSLocalizedString(@"to", @"between two times, example: 3 PM 'to' 4 PM"),endDate];
        }
    }
    else {
        [description appendString:[NSString stringWithFormat:@"%@:%@\n %@\n",NSLocalizedString(@"Time", @"The time for the event"),NSLocalizedString(@"All-Day",@"Desciption for an event that lasts all day."),[self.startingDate stringWithWeekdayMonthDayYearMonthAbbreviated:NO]]];
    }
    
    // Location
    if (self.location) {
        [description appendFormat:@"%@:\n%@\n",NSLocalizedString(@"Location", @"Description for an event's location."), self.location];
    }
    
    // Availability 
  /*  if (self.availability > -1) {
        [description appendString:NSLocalizedString(@"Availibility:\n",@"The Event's availibility")];
        if (self.availability == EKEventAvailabilityBusy) {
            [description appendString:NSLocalizedString(@"Busy", @"Description when an event's availability is busy.")];
        } else if (self.availability == EKEventAvailabilityFree) {
            [description appendString:NSLocalizedString(@"Available", @"Description when an event's availability is free.")];
        } else if (self.availability == EKEventAvailabilityTentative) {
            [description appendString:NSLocalizedString(@"Tentative", @"Description when an event's availability is tentative.")];
        } else if (self.availability == EKEventAvailabilityUnavailable) {
            [description appendString:NSLocalizedString(@"Unavailable", @"Description when an event's availability is unavailable.")];
        }
        [description appendString:@"\n"];
    }*/
    
    // People
    if (self.attendees) {
        NSString *NA = @"unavailable";
        [description appendString:@"Participant"];
        if ([self.attendees count] > 1 ) {
            [description appendString:@"s:\n"];
        }
        else {
            [description appendString:@":\n"];
        }
        for (EKParticipant *attend in self.attendees) {
            NSString *attendeeEmail = [NSString string];
            NSString *attendeeName = attend.name;
            NSString *attendeesDetails = [NSString stringWithFormat:@"%@",attend];
            NSArray *partsArray = [attendeesDetails componentsSeparatedByString:@"email = "]; 
            if ([partsArray count] > 1) {
                NSString *secondHalf = [partsArray objectAtIndex:1];
                NSInteger loc = [secondHalf rangeOfString:@";"].location;
                if (loc > 0) {
                    attendeeEmail = [secondHalf substringToIndex:loc];
                    
                }
            }
            if (![attendeeName isEqualToString:attendeeEmail]) {
            [description appendFormat:@"%@\n",attend.name];
            }
            else {
                [description appendFormat:@"%@ %@\n",NSLocalizedString(@"Name",@"Name of the participant"),NA];
            }
            if (![attendeeEmail isEqualToString:@"(null)"]) {
                [description appendFormat:@"%@\n",attendeeEmail];
            }
            else { 
                [description appendFormat:@"%@ %@\n",NSLocalizedString(@"Email",@"Email of the participant"),NA];
            }
            //[description appendFormat:@"%@:%@\n",NSLocalizedString(@"Status",@"Status of the participant"),[[self stringForParticipantStatus:attend.participantStatus]capitalizedString]];
            //[description appendFormat:@"%@:%@\n",NSLocalizedString(@"Role",@"Role of the participant"),[[self stringForParticipantRole:attend.participantRole]capitalizedString]];
        }
    }
    // Recurrence
    if (self.hasRecurrenceRules) {
        [description appendFormat:@"%@:\n%@\n",NSLocalizedString(@"Repeats", @"Description for an event's recurrence."), [[self.recurrenceRules lastObject] naturalDescription]];
    }
    
    // Notes
    if (self.notes) {
        [description appendFormat:@"%@:\n%@\n",NSLocalizedString(@"Notes", @"Description for an event's notes."), self.notes];
    }
    
    return description;
}


- (NSMutableString *)iCalString 
{
    
    NSMutableString *iCalString = [NSMutableString string];
    
    // The first line must be "BEGIN:VCALENDAR"
    [iCalString appendString:@"BEGIN:VCALENDAR"];
    [iCalString appendString:@"\nVERSION:2.0"];
	
    // calendar
    
    if (self.calendar.title) {
        //[iCalString appendFormat:@"\r\nX-WR-CALNAME:%@",self.calendar.title];
    }
    //TimeZonef
    NSTimeZone *timeZone = [CVSettings timezone];
    NSString *timeZoneName = [timeZone name];
    NSString *timeZoneAbb = [timeZone abbreviation];

    NSDateFormatter *offsetFormat = [[NSDateFormatter alloc] init];
    [offsetFormat setDateFormat:@"Z"];
    [offsetFormat setTimeZone:timeZone];

    NSDateFormatter *gmtFormatter = [[NSDateFormatter alloc] init];
    [gmtFormatter setDateFormat:@"yyyyMMdd'T'HHmmss"];
    [gmtFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *dayTimeDate = [gmtFormatter dateFromString:@"20070311T020000"];
    NSDate *standardDate = [gmtFormatter dateFromString:@"20071104T020000"];
    
    NSString *dayTimeOffset = [offsetFormat stringFromDate:dayTimeDate];
    NSString *standardOffset = [offsetFormat stringFromDate:standardDate];
    
    [iCalString appendString:@"\nBEGIN:VTIMEZONE"];
    [iCalString appendFormat:@"\nTZID:%@",timeZoneName];
    
    [iCalString appendString:@"\nBEGIN:DAYLIGHT"];
    [iCalString appendString:@"\nDTSTART:20070311T020000\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"];
    [iCalString appendFormat:@"\nTZNAME:%@",timeZoneAbb];
    [iCalString appendFormat:@"\nTZOFFSETFROM:%@",standardOffset];
    [iCalString appendFormat:@"\nTZOFFSETTO:%@",dayTimeOffset];
    [iCalString appendString:@"\nEND:DAYLIGHT"];
    
    [iCalString appendString:@"\nBEGIN:STANDARD"];
    [iCalString appendString:@"\nDTSTART:20071104T020000\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU"];
    [iCalString appendFormat:@"\nTZNAME:%@",timeZoneAbb];
    [iCalString appendFormat:@"\nTZOFFSETFROM:%@",dayTimeOffset];
    [iCalString appendFormat:@"\nTZOFFSETTO:%@",standardOffset];
    [iCalString appendString:@"\nEND:STANDARD"];

    [iCalString appendString:@"\nEND:VTIMEZONE"];


    // Event Start Date
    [iCalString appendString:@"\nBEGIN:VEVENT"];
    
    // allDay
    if (self.allDay) {
        
        NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
        [format1 setDateFormat:@"yyyyMMdd"];
        NSString *allDayDate = [format1 stringFromDate:self.startingDate];
        
        [iCalString appendFormat:@"\nDTSTART;VALUE=DATE:%@",allDayDate];
        
        //get startdate and add 1 day for the end date.
        NSDate *addDay = [self.startingDate dateByAddingTimeInterval:86400];
        NSString *allDayEnd = [format1 stringFromDate:addDay];
        
        [iCalString appendFormat:@"\nDTEND;VALUE=DATE:%@",allDayEnd];
        
        
    }
    
    else {
        if (self.startingDate && self.endingDate) {
           [iCalString appendFormat:@"\nDTSTART;TZID=%@:",timeZoneName];
            
            NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
            [format2 setDateFormat:@"yyyyMMdd'T'HHmmss"];
            
            NSString *dateAsString = [format2 stringFromDate:self.startingDate];
            [iCalString appendString:dateAsString];
            //end date
            
           [iCalString appendFormat:@"\nDTEND;TZID=%@:",timeZoneName];
            
            NSString *dateAsString1 = [format2 stringFromDate:self.endingDate];
            
            [iCalString appendString:dateAsString1];
            
            
        }        
    }   

    [iCalString appendString:@"\nDTSTAMP:"];    //date the event was created
    NSDateFormatter *format3 = [[NSDateFormatter alloc] init];
    [format3 setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
    
    NSString *dateAsString2 = [format3 stringFromDate:(self.lastModifiedDate ? self.lastModifiedDate : [NSDate date])];
    [iCalString appendString:dateAsString2];
    
    // lastModifiedDate
    if (self.lastModifiedDate) {
        
        [iCalString appendString:@"\nLAST-MODIFIED:"];
        
        NSString *dateAsString2 = [format3 stringFromDate:self.lastModifiedDate];
        [iCalString appendString:dateAsString2];
        
    }
    
    // UID is generated randomly
    [iCalString appendFormat:@"\nUID:%@", [NSString stringWithUUID]];
    
    //availability
    if (self.availability == 1) {
        [iCalString appendString:@"\nTRANSP:TRANSPARENT"];    //free
    }
    else {
        [iCalString appendString:@"\nTRANSP:OPAQUE"];    //busy
    }
    //calendarItemExternalIdentifier- New id's are created randomly for ical calendar
    
    //isDetached- Not 100% positive but I think this is not used for Ical calendar
    
    //location
    if (self.location) {
        [iCalString appendFormat:@"\nLOCATION:%@",self.location];
    }
    
    //recurrenceRule
    NSString *recurrenceString = [NSString stringWithFormat:@"%@", [self.recurrenceRules lastObject]];
    NSArray *partsArray = [recurrenceString componentsSeparatedByString:@"RRULE "];
    
    if ([partsArray count] > 1) {
        NSString *secondHalf = [partsArray objectAtIndex:1];
        // NSInteger loc = [secondHalf rangeOfString:@"Z"].location;
        //if (loc > 0) {
        //   [secondHalf substringToIndex:loc];
        [iCalString appendFormat:@"\nRRULE:%@",secondHalf];
    }
    
    //When a calendar component is created, its sequence number is zero 
    [iCalString appendString:@"\nSEQUENCE:0"];
    
    //status
    if (self.status == 1) {
        [iCalString appendString:@"\nSTATUS:CONFIRMED"];
    }
    if (self.status == 2) {
        [iCalString appendString:@"\nSTATUS:TENTATIVE"];
    }
    if (self.status == 3) {
        [iCalString appendString:@"\nSTATUS:CANCELLED"];
    }
    
    //Event Title
    if (self.title) {
        [iCalString appendFormat:@"\nSUMMARY:%@",self.title];
    }
    
    //organizer 
        if  (self.organizer != nil) {
            [iCalString appendString:@"\nORGANIZER"];
            if (self.organizer.name) {
                [iCalString appendFormat:@";CN=%@",self.organizer.name];
                //mailto appears last
                NSMutableString *containsMailto = [NSMutableString string];
                [containsMailto appendFormat:@"%@",self.organizer.URL];
                if ([containsMailto rangeOfString:@"mailto:"].location == NSNotFound) {
                } 
                else {
                    [iCalString appendFormat:@":%@",self.organizer.URL];
                }
            }
        }
    
    //attendees @todo: Attendees are always labeled as optional...Needs more testing
    if (self.attendees) {
        for (EKParticipant *attend in self.attendees) {
            [iCalString appendString:@"\nATTENDEE"];
            [iCalString appendFormat:@";CN=%@",attend.name];
            //Status
            [iCalString appendFormat:@";PARTSTAT=%@",[self stringForParticipantStatus:attend.participantStatus]];
            //Type
            [iCalString appendFormat:@";CUTYPE=%@",[self stringForParticipantType:attend.participantType]];
            //Role
            [iCalString appendFormat:@";ROLE=%@",[self stringForParticipantRoleIcalFormat:attend.participantRole]];
            //mailto appears last
            NSMutableString *containsMailto = [NSMutableString string];
            [containsMailto appendFormat:@"%@",attend.URL];
            if ([containsMailto rangeOfString:@"mailto:"].location == NSNotFound) {
            } 
            else {
                [iCalString appendFormat:@":%@",attend.URL];
            }
        }
    }
    
    //Notes
    if (self.notes) {
        [iCalString appendFormat:@"\nDESCRIPTION:%@",self.notes];
    }
    
    //Alarm 
    for (EKAlarm *alarm in self.alarms) {
        [iCalString appendString:@"\nBEGIN:VALARM"];
        [iCalString appendString:@"\nACTION:DISPLAY"];//a message(usually the title of the event) will be displayed
        [iCalString appendString:@"\nDESCRIPTION:event reminder"]; //notes with the alarm--not the message.
        
        if (alarm.absoluteDate) {
            
            NSDateFormatter *format3 = [[NSDateFormatter alloc] init];
            [format3 setDateFormat:@"yyyyMMdd'T'HHmmss"];
            
            NSString *dateAsString3 = [format3 stringFromDate:alarm.absoluteDate];
            
            [iCalString appendFormat:@"\nTRIGGER;VALUE=DATE-TIME:%@",dateAsString3];
            
        }
        if (alarm.relativeOffset <= 0) {
            
            //converts offset to D H M S then appends it to iCalString
            NSInteger offset = alarm.relativeOffset;
            if (offset == 0) {
                [iCalString appendString:@"\nTRIGGER:PT0S"];
            }
            else {
                
                NSInteger i = offset * - 1;
                
                NSInteger day = i / (24*60*60);
                i = i % (24*60*60);
                
                NSInteger hour = i / (60*60);
                i = i % (60*60);
                
                NSInteger minute = i / 60;
                i = i % 60;
                
                NSInteger second = i;
                
                [iCalString appendFormat:@"\nTRIGGER:-P"];
                
                if (day != 0) {
                    [iCalString appendFormat:@"%ldD", (long)day];
                }
                
                if (hour || minute || second != 0) {
                    [iCalString appendString:@"T"];
                    
                    if (hour != 0) {
                        [iCalString appendFormat:@"%ldH", (long)hour];
                    }
                    
                    if (minute != 0) {
                        [iCalString appendFormat:@"%ldM", (long)minute];
                    }
                    
                    if (second != 0) {
                        [iCalString appendFormat:@"%ldS", (long)second];
                    }
                }
            }
        }
        
        [iCalString appendFormat:@"\nX-WR-ALARMUID:%@", [NSString stringWithUUID]];
        [iCalString appendString:@"\nEND:VALARM"];
        
    }
    
    
    [iCalString appendString:@"\nEND:VEVENT"];
    
    // The last line must be "END:VCALENDAR"
    [iCalString appendString:@"\nEND:VCALENDAR"];
    
    return iCalString;
}




@end
