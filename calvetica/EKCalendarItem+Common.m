//
//  EKCalendarItem+Common.m
//  calvetica
//
//  Created by Adam Kirk on 10/18/13.
//
//

#import "EKCalendarItem+Common.h"

@implementation EKCalendarItem (Common)

- (NSDate *)mys_date
{
    if (self.isEvent) {
        return [(EKEvent *)self startingDate];
    }
    else {
        return [(EKReminder *)self firstAvailableDate];
    }
}

- (NSString *)mys_title
{
    NSString *t = self.title;
	if (t && ![t isEqualToString:@""]) {
		return t;
	} else {
		NSString *hack = [NSString stringWithFormat:@"%@",self];
		if(hack){
            t = self.title;
            if (t && ![t isEqualToString:@""]) {
                return t;
            }
        }
	}
	return NSLocalizedString(@"Untitled",@"Untitled");
}

- (BOOL)mys_isAllDay
{
    if (self.isEvent) {
        return [(EKEvent *)self isAllDay];
    }
    else {
        return [(EKReminder *)self isAllDay];
    }
}


@end
