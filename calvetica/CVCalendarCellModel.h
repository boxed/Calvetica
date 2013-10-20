//
//  CVCalendarCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



@interface CVCalendarCellModel : NSObject
@property (nonatomic, strong) EKCalendar *calendar;
@property (nonatomic        ) BOOL       isSelected;
@end
