//
//  CVWeekTableViewCellEvents.h
//  calvetica
//
//  Created by Adam Kirk on 3/23/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@class CVCalendarItemShape;
@protocol CVWeekTableViewCellDrawingDataSource;


@interface CVWeekTableViewCellDrawing : UIView

@property (nonatomic, nullable, weak) id<CVWeekTableViewCellDrawingDataSource> delegate;
@property (nonatomic, copy) NSArray<CVCalendarItemShape *>                                  *calendarItems;

- (void)draw;

@end


@protocol CVWeekTableViewCellDrawingDataSource <NSObject>
- (NSDate *)startDateForDrawingView:(CVWeekTableViewCellDrawing *)view;
@end

NS_ASSUME_NONNULL_END