//
//  CVCalendarCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//




NS_ASSUME_NONNULL_BEGIN

@interface CVCalendarCellModel : NSObject
@property (nonatomic, strong) EKCalendar *calendar;
@property (nonatomic        ) BOOL       isSelected;
@end

NS_ASSUME_NONNULL_END