//
//  CVCalendarCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKCalendar+Utilities.h"
#import "CVDataHolder.h"


@interface CVCalendarReminderCalendarCellDataHolder : CVDataHolder

#pragma mark - Public Properties
@property (nonatomic, strong) EKCalendar *calendar;
@property (nonatomic) BOOL isSelected;

@end
