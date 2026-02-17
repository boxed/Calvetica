//
//  CVCompactWeekEventCell.h
//  calvetica
//
//  Compact week view event cell with day column layout.
//

#import "CVCalendarItemCellDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@class CVCellAccessoryButton;
@class CVColoredDotView;

@interface CVCompactWeekEventCell : UITableViewCell

@property (nonatomic, nullable, weak) id<CVCalendarItemCellDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic) BOOL isToday;
@property (nonatomic, copy) NSString *dayLabelText;

+ (instancetype)cellForTableView:(UITableView *)tableView;
- (void)resetAccessoryButton;

@end

NS_ASSUME_NONNULL_END
