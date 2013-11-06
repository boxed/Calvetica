//
//  EKCalendar+Settings.m
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import "EKCalendar+Settings.h"
#import "UIColor+Serialization.h"


@implementation EKCalendar (Settings)

- (BOOL)isHidden
{
    return [PREFS.hiddenEventCalendarIdentifiers containsObject:self.calendarExternalIdentifier];
}

- (void)setHidden:(BOOL)hide
{
    NSMutableArray *hiddenCalendarIdentifiers = [PREFS.hiddenEventCalendarIdentifiers mutableCopy];
    if (hide) {
        [hiddenCalendarIdentifiers addObject:self.calendarExternalIdentifier];
    }
    else {
        [hiddenCalendarIdentifiers removeObject:self.calendarExternalIdentifier];
    }
    PREFS.hiddenEventCalendarIdentifiers = [hiddenCalendarIdentifiers copy];
}

- (UIColor *)customColor
{
    NSString *colorString = PREFS.customCalendarColors[self.calendarExternalIdentifier];
    if (colorString) {
        return [UIColor colorFromString:colorString];
    }
    return [UIColor colorWithCGColor:self.CGColor];
}

- (void)setCustomColor:(UIColor *)color
{
    NSMutableDictionary *calendarsDict              = [PREFS.customCalendarColors mutableCopy];
    calendarsDict[self.calendarExternalIdentifier]  = [color stringValue];
    PREFS.customCalendarColors                      = [calendarsDict copy];
}


@end
