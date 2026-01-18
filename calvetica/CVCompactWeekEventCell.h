//
//  CVCompactWeekEventCell.h
//  calvetica
//
//  Compact week view event cell with day column layout.
//

#import "CVCalendarItemCellDelegate.h"

@class CVCellAccessoryButton;
@class CVColoredDotView;

@interface CVCompactWeekEventCell : UITableViewCell

@property (nonatomic, weak) id<CVCalendarItemCellDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic, copy) NSString *dayLabelText;

+ (instancetype)cellForTableView:(UITableView *)tableView;
- (void)resetAccessoryButton;

@end
