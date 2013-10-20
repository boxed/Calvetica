//
//  CVCalendarItemCellDelegate.h
//  calvetica
//
//  Created by Adam Kirk on 10/19/13.
//
//

typedef NS_ENUM(NSUInteger, CVCalendarItemCellSwipedDirection) {
    CVCalendarItemCellSwipedDirectionLeft,
    CVCalendarItemCellSwipedDirectionRight
};


@protocol CVCalendarItemCellDelegate <NSObject>

- (void)calendarItemCell:(UITableViewCell *)cell
              tappedTime:(NSDate *)date
                    view:(UIView *)view;

- (void)calendarItemCell:(UITableViewCell *)cell
        wasTappedForItem:(EKCalendarItem *)calendarItem;

- (void)calendarItemCell:(UITableViewCell *)cell
   wasLongPressedForItem:(EKCalendarItem *)calendarItem;

- (void)calendarItemCell:(UITableViewCell *)cell
                 forItem:(EKCalendarItem *)calendarItem
    wasSwipedInDirection:(CVCalendarItemCellSwipedDirection)direction;

- (void)calendarItemCell:(UITableViewCell *)cell
         tappedAlarmView:(UIView *)alarmView
                 forItem:(EKCalendarItem *)calendarItem;

- (void)calendarItemCell:(UITableViewCell *)cell
     tappedDeleteForItem:(EKCalendarItem *)calendarItem;

@end