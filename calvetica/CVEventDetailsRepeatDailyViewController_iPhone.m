//
//  CVEventDetailsRepeatDailyViewController_iPhone.m
//  calvetica
//
//  Created by Quenton Jones on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsRepeatDailyViewController_iPhone.h"


@implementation CVEventDetailsRepeatDailyViewController_iPhone

#pragma mark - Methods

- (EKRecurrenceRule *)recurrenceRule 
{
    EKRecurrenceEnd *end = nil;
    if (self.endTypeButton.currentState == 2) {
        end = [EKRecurrenceEnd recurrenceEndWithOccurrenceCount:[self.endAfterLabel.text intValue]];
    } else if (!self.dateView.hidden) {
        NSDate *date = [NSDate dateFromYear:self.selectedYear month:self.selectedMonth day:self.selectedDay + 1];
        end = [EKRecurrenceEnd recurrenceEndWithEndDate:date];
    }
    
    EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:[self.repeatTimesLabel.text intValue]  end:end];
    return rule;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
