//
//  EKRecurrenceDayOfWeek+Utilities.m
//  calvetica
//
//  Created by Quenton Jones on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKRecurrenceDayOfWeek+Utilities.h"


static NSArray *daySymbols;

@implementation EKRecurrenceDayOfWeek (Utilities)

#pragma mark - Methods

- (NSString *)description 
{
    NSMutableString *dayOfWeekString = [[NSMutableString alloc] init];
    
    if (self.weekNumber != 0) {
        NSString *weekNumberString = @"";
        if (self.weekNumber == 1) {
            weekNumberString = FIRST_WEEK;
        } else if (self.weekNumber == 2) {
            weekNumberString = SECOND_WEEK;
        } else if (self.weekNumber == 3) {
            weekNumberString = THIRD_WEEK;
        } else if (self.weekNumber == 4) {
            weekNumberString = FOURTH_WEEK;
        } else {
            weekNumberString = LAST_WEEK;
        }
        
        [dayOfWeekString appendFormat:@"%@ ", weekNumberString];
    }
    
    [dayOfWeekString appendFormat:@"%@", [[EKRecurrenceDayOfWeek weekdaySymbols] objectAtIndex:self.dayOfTheWeek - 1]];
    return dayOfWeekString;
}

+ (NSArray *)weekdaySymbols {
    if (!daySymbols) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        daySymbols = [formatter weekdaySymbols];
    }
    
    return daySymbols;
}

@end
