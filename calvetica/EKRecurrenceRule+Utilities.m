//
//  EKRecurrenceRule+Utilities.m
//  calvetica
//
//  Created by Quenton Jones on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EKRecurrenceRule+Utilities.h"


@implementation EKRecurrenceRule (Utilities)

#pragma mark - Methods

+ (void)appendNewLine:(NSMutableString *)string {
    [string appendString:@"\n"];
}

- (BOOL)isValidCalveticaRule 
{
    // Set positions aren't allowed.
    if (self.setPositions && self.setPositions.count > 0) {
        return NO;
    }
    
    if (self.frequency == EKRecurrenceFrequencyDaily) {
        
    } else if (self.frequency == EKRecurrenceFrequencyWeekly) {
        
    } else if (self.frequency == EKRecurrenceFrequencyMonthly) {
        // We can have days of the month or a day of the week.
        if (self.daysOfTheWeek && self.daysOfTheWeek.count > 0 && self.daysOfTheMonth && self.daysOfTheMonth.count > 0) {
            return NO;
        }
        
        // Only one day of the week is allowed.
        if (self.daysOfTheWeek && self.daysOfTheWeek.count > 1) {
            return NO;
        }
    } else if (self.frequency == EKRecurrenceFrequencyYearly) {
        // Days of the year aren't allowed.
        if (self.daysOfTheYear && self.daysOfTheYear.count > 0) {
            return NO;
        }
        
        // Only one day of the week is allowed.
        if (self.daysOfTheWeek.count > 1) {
            return NO;
        }
        
        // Only one month of the year is allowed.
        if (self.monthsOfTheYear.count > 1) {
            return NO;
        }
        
        // Week positions aren't allowed.
        if (self.weeksOfTheYear && self.weeksOfTheYear.count > 0) {
            return NO;
        }
    }
    
    return YES;
}

- (EKRecurrenceRule *)validCalveticaRule 
{
    if (self.frequency == EKRecurrenceFrequencyDaily) {
        return [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:self.frequency interval:self.interval end:self.recurrenceEnd];
    } else if (self.frequency == EKRecurrenceFrequencyWeekly) {
        return [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:self.frequency interval:self.interval daysOfTheWeek:self.daysOfTheWeek daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:self.recurrenceEnd];
    } else if (self.frequency == EKRecurrenceFrequencyMonthly) {
        NSArray *daysOfTheWeek = nil;
        NSArray *daysOfTheMonth = nil;
        
        if (self.daysOfTheWeek && self.daysOfTheWeek.count > 0) {
            EKRecurrenceDayOfWeek *dayOfWeek = [self.daysOfTheWeek objectAtIndex:0];
            if (dayOfWeek.weekNumber == 0) {
                dayOfWeek = [EKRecurrenceDayOfWeek dayOfWeek:dayOfWeek.dayOfTheWeek weekNumber:1];
            }
            daysOfTheWeek = @[dayOfWeek];
        } else {
            daysOfTheMonth = self.daysOfTheMonth;
        }
        
        return [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:self.frequency interval:self.interval daysOfTheWeek:daysOfTheWeek daysOfTheMonth:daysOfTheMonth monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:self.recurrenceEnd];
    } else if (self.frequency == EKRecurrenceFrequencyYearly) {
        NSArray *daysOfTheWeek = nil;
        NSArray *monthsOfTheYear = nil;
        
        if ((self.daysOfTheWeek && self.daysOfTheWeek.count > 0) || (self.monthsOfTheYear && self.monthsOfTheYear.count > 0)) {
            // Only one day of the week is allowed.
            if (self.daysOfTheWeek && self.daysOfTheWeek.count > 0) {
                EKRecurrenceDayOfWeek *dayOfWeek = [self.daysOfTheWeek objectAtIndex:0];
                if (dayOfWeek.weekNumber == 0) {
                    dayOfWeek = [EKRecurrenceDayOfWeek dayOfWeek:dayOfWeek.dayOfTheWeek weekNumber:1];
                }
                daysOfTheWeek = @[dayOfWeek];
            } else {
                daysOfTheWeek = @[[EKRecurrenceDayOfWeek dayOfWeek:1 weekNumber:1]];
            }
            
            // Only one month of the year is allowed.
            if (self.monthsOfTheYear && self.monthsOfTheYear.count > 0) {
                NSNumber *month = [self.monthsOfTheYear objectAtIndex:0];
                month = [month intValue] == 0 ? @1 : month;
                
                monthsOfTheYear = @[month];
            } else {
                monthsOfTheYear = @[@1];
            }
        }
        
        return [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:self.frequency interval:self.interval daysOfTheWeek:daysOfTheWeek daysOfTheMonth:nil monthsOfTheYear:monthsOfTheYear weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:self.recurrenceEnd];
    }
    
    return nil;
}

- (NSString *)naturalDescription 
{
    // @todo: Put all NSLocalizedStrings into string.h.
    
    NSMutableString *daysOfTheWeek = nil;
    if (self.frequency != EKRecurrenceFrequencyDaily && self.daysOfTheWeek.count > 0) {
        daysOfTheWeek = [NSMutableString string];
        
        for (int i = 0; i < self.daysOfTheWeek.count; i++) {
            if (i == self.daysOfTheWeek.count - 1) {
                [daysOfTheWeek appendString:[[self.daysOfTheWeek objectAtIndex:i] description]];
            } else {
                [daysOfTheWeek appendFormat:@"%@, ", [self.daysOfTheWeek objectAtIndex:i]];
            }
        }
    }
    
    NSMutableString *recurrenceString = [NSMutableString string];
    
    if (![self isValidCalveticaRule]) {
        // Frequency
        if (self.frequency == EKRecurrenceFrequencyMonthly) {
            // Frequency
            [recurrenceString appendFormat:NSLocalizedString(@"Frequency: %1$i month(s)", @"Frequency when an event repeats monthly. %1$i: the interval the event repeats on."), self.frequency];
            
            // Days of the Week
            if (daysOfTheWeek) {
                [EKRecurrenceRule appendNewLine:recurrenceString];
                
                [recurrenceString appendFormat:NSLocalizedString(@"Repeats on: %1$@", @"The days of the week an event repeats on. %1$@: the days of the week as a comma separated list."), daysOfTheWeek];
            }
                                                            
            // Days of the Month
            if (self.daysOfTheMonth && self.daysOfTheMonth.count > 0) {
                [EKRecurrenceRule appendNewLine:recurrenceString];
                
                NSMutableString *daysOfTheMonth = [NSMutableString string];
                for (int i = 0; i < self.daysOfTheMonth.count; i++) {
                    if (i == self.daysOfTheMonth.count - 1) {
                        [daysOfTheMonth appendFormat:@"%i", [[self.daysOfTheMonth objectAtIndex:i] intValue]];
                    } else {
                        [daysOfTheMonth appendFormat:@"%i, ", [[self.daysOfTheMonth objectAtIndex:i] intValue]];
                    }
                }
                
                [recurrenceString appendFormat:NSLocalizedString(@"Repeats on the following day(s) of the month: %1$@", @"The days of the month an event repeats on. %1$@: the days of the month as a comma separated list."), daysOfTheMonth]; 
            }
        } else if (self.frequency == EKRecurrenceFrequencyYearly) {
            // Frequency
            [recurrenceString appendFormat:NSLocalizedString(@"Frequency: %1$i year(s)", @"Frequency when an event repeats yearly. %1$i: the interval the event repeats on."), self.frequency];
            
            // Days of the Week
            if (daysOfTheWeek) {
                [EKRecurrenceRule appendNewLine:recurrenceString];
                
                [recurrenceString appendFormat:NSLocalizedString(@"Repeats on: %1$@", @"The days of the week an event repeats on. %1$@: the days of the week as a comma separated list."), daysOfTheWeek];
            }
            
            // Months of the Year
            if (self.monthsOfTheYear && self.monthsOfTheYear.count > 0) {
                [EKRecurrenceRule appendNewLine:recurrenceString];
                
                NSMutableString *monthsOfTheYear = [NSMutableString string];
                for (int i = 0; i < self.monthsOfTheYear.count; i++) {
                    if (i == self.monthsOfTheYear.count - 1) {
                        [monthsOfTheYear appendFormat:@"%i", [[self.monthsOfTheYear objectAtIndex:i] intValue]];
                    } else {
                        [monthsOfTheYear appendFormat:@"%i, ", [[self.monthsOfTheYear objectAtIndex:i] intValue]];
                    }
                }
                
                [recurrenceString appendFormat:NSLocalizedString(@"Repeats during the following month(s): %1$@", @"The months of the year an event repeats on. %1$@: the months of the year as a comma separated list."), monthsOfTheYear]; 
            }
            
            // Days of the Year
            if (self.daysOfTheYear && self.daysOfTheYear.count > 0) {
                [EKRecurrenceRule appendNewLine:recurrenceString];
                
                NSMutableString *daysOfTheYear = [NSMutableString string];
                for (int i = 0; i < self.daysOfTheYear.count; i++) {
                    if (i == self.daysOfTheYear.count - 1) {
                        [daysOfTheYear appendFormat:@"%i", [[self.daysOfTheYear objectAtIndex:i] intValue]];
                    } else {
                        [daysOfTheYear appendFormat:@"%i, ", [[self.daysOfTheYear objectAtIndex:i] intValue]];
                    }
                }
                
                [recurrenceString appendFormat:NSLocalizedString(@"Repeats on the following day(s) of the year: %1$@", @"The days of the year an event repeats on. %1$@: the days of the year as a comma separated list."), daysOfTheYear]; 
            }
            
            // Weeks of the Year
            // @todo(Quenton): Confirm what weeks of the year actually does.
            if (self.weeksOfTheYear && self.weeksOfTheYear.count > 0) {
                [EKRecurrenceRule appendNewLine:recurrenceString];
                
                NSMutableString *weeksOfTheYear = [NSMutableString string];
                for (int i = 0; i < self.weeksOfTheYear.count; i++) {
                    if (i == self.weeksOfTheYear.count - 1) {
                        [weeksOfTheYear appendFormat:@"%i", [[self.weeksOfTheYear objectAtIndex:i] intValue]];
                    } else {
                        [weeksOfTheYear appendFormat:@"%i, ", [[self.weeksOfTheYear objectAtIndex:i] intValue]];
                    }
                }
                
                [recurrenceString appendFormat:NSLocalizedString(@"Repeats during the following week(s) of the year: %1$@", @"The weeks of the year an event repeats on. %1$@: the weeks of the year as a comma separated list."), weeksOfTheYear]; 
            }
        } else {
            return EVENT_UNKNOWN;
        }
        
        if (self.recurrenceEnd) {
            [EKRecurrenceRule appendNewLine:recurrenceString];
            
            [recurrenceString appendString:[self recurrenceEndNaturalDescription]];
        }
    } else {    
        // Frequency. (This is long and complicated logic, but it makes for extremely well-formatted text that should, hopefully, be easy to localize.)
        if (self.frequency == EKRecurrenceFrequencyDaily) {
            if (self.interval == 1) {
                [recurrenceString appendString:NSLocalizedString(@"Every day.", @"Frequency when an event repeats every day.")];
            } else {
                [recurrenceString appendFormat:NSLocalizedString(@"Every %1$i days.", @"Frequency when an event repeats daily. %1$i: the interval the event repeats on."), self.interval];
            }
        } else if (self.frequency == EKRecurrenceFrequencyWeekly) {
            if (self.interval == 1 && daysOfTheWeek) {
                [recurrenceString appendFormat:NSLocalizedString(@"Every week on %1$@.", @"Frequency when an event repeats every week. %1$@: the days of the week the event repeats on as a comma separated list."), daysOfTheWeek];
            } else if (self.interval == 1 && !daysOfTheWeek) {
                [recurrenceString appendString:NSLocalizedString(@"Every week.", @"Frequency when an event repeats every week.")];
            } else if (self.interval > 1 && daysOfTheWeek) {
                [recurrenceString appendFormat:NSLocalizedString(@"Every %1$i weeks on %2$@.", @"Frequency when an event repeats weekly. %1$i: the interval the event repeats on. %2$@: the days of the week the event repeats on as a comma separated list."), self.interval, daysOfTheWeek];
            } else if (self.interval > 1 && !daysOfTheWeek) {
                [recurrenceString appendFormat:NSLocalizedString(@"Every %1$i weeks.", @"Frequency when an event repeats weekly. %1$i: the interval the event repeats on."), self.interval];
            }
        } else if (self.frequency == EKRecurrenceFrequencyMonthly) {
            NSMutableString *monthlyRepeatString = nil;
            if (self.daysOfTheWeek) {
                monthlyRepeatString = daysOfTheWeek;
            } else {
                monthlyRepeatString = [NSMutableString string];
                
                NSArray *daysOfTheMonthSorted = [self.daysOfTheMonth sortedArrayUsingSelector:@selector(compare:)];
                for (int i = 0; i < daysOfTheMonthSorted.count; i++) {
                    if (i == daysOfTheMonthSorted.count - 1) {
                        [monthlyRepeatString appendFormat:@"%i", [[daysOfTheMonthSorted objectAtIndex:i] intValue]];
                    } else {
                        [monthlyRepeatString appendFormat:@"%i, ", [[daysOfTheMonthSorted objectAtIndex:i] intValue]];
                    }
                }
            }
            
            if (self.interval == 1) {
                [recurrenceString appendFormat:NSLocalizedString(@"Every month on the %1$@.", @"Frequency when an event repeats every month. %1$@: the week and day the event repeats on or the days of the month. For example, Last Sunday."), monthlyRepeatString];
            } else {
                [recurrenceString appendFormat:NSLocalizedString(@"Every %1$i months on the %2$@.", @"Frequency when an event repeats monthly. %1$@: the interval the event repeats on. %2$@: the week and day the event repeats on or the days of the month. For example, Last Sunday."), self.interval, monthlyRepeatString];
            }
            
        } else if (self.frequency == EKRecurrenceFrequencyYearly) {
            // Yearly recurrence also has a month attached to the day of the week. For example, Last Sunday in October.".
            if (daysOfTheWeek && self.monthsOfTheYear.count > 0) {
                NSNumber *month = [self.monthsOfTheYear objectAtIndex:0];
                
                daysOfTheWeek = [NSMutableString stringWithFormat:NSLocalizedString(@"%1$@ in %2$@", @"The day of the week and month for a yearly recurring event. %1$@: the week and day of the week. For example, Last Sunday. %2$@: the month the event repeats on."), daysOfTheWeek, [[NSDate mt_monthlySymbols] objectAtIndex:[month intValue] - 1]];
            }
            
            if (self.interval == 1 && daysOfTheWeek) {
                [recurrenceString appendFormat:NSLocalizedString(@"Once a year on the %1$@.", @"Frequency when an event repeats once a year. %1$@: the date or the week, day and month the event repeats on. For example, First Sunday in March."), daysOfTheWeek];
            } else if (self.interval == 1 && !daysOfTheWeek) {
                [recurrenceString appendString:NSLocalizedString(@"Once a year.", @"Frequency when an event repeats once a year.")];
            } else if (self.interval > 1 && daysOfTheWeek) {
                [recurrenceString appendFormat:NSLocalizedString(@"Every %1$i years on the %2$@.", @"Frequency when an event repeats once a year. %1$i: the interval the event repeats on. %2$@: the date or the week, day and month the event repeats on. For example, First Sunday in March."), self.interval, daysOfTheWeek];
            } else if (self.interval > 1 && !daysOfTheWeek) {
                [recurrenceString appendFormat:NSLocalizedString(@"Every %1$i years.", @"Frequency when an event repeats once a year. %1$i: the interval the event repeats on."), self.interval];
            }
        }
        
        if (self.recurrenceEnd) 
        {
            [recurrenceString appendFormat:@" %@", [self recurrenceEndNaturalDescription]];
        }
    }
    
    return recurrenceString;
}

- (NSString *)recurrenceEndNaturalDescription 
{
    NSString *recurrenceEndString = nil;
    
    if (self.recurrenceEnd.endDate) {
        recurrenceEndString = [NSString stringWithFormat:NSLocalizedString(@"Ends on %1$@.", @"End date for a recurring event. %1$@: the date the event ends on."), [self.recurrenceEnd.endDate stringWithWeekdayMonthDayYearMonthAbbreviated:NO]];
    } else {
        if (self.recurrenceEnd.occurrenceCount == 1) {
            recurrenceEndString = NSLocalizedString(@"Occurs once.", @"Description when an event only repeats once.");
        } else {
            recurrenceEndString = [NSString stringWithFormat:NSLocalizedString(@"Ends after %1$i times.", @"Describes the number of times an event will repeat before ending."), self.recurrenceEnd.occurrenceCount];
        }
    }
    
    return recurrenceEndString;
}

@end
