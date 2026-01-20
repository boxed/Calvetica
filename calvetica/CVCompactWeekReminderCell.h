//
//  CVCompactWeekReminderCell.h
//  calvetica
//
//  Compact week view reminder cell with day column layout.
//

#import "CVColoredDotView.h"
#import "CVStrikethroughLabel.h"

@interface CVCompactWeekReminderCell : UITableViewCell

@property (nonatomic, strong) CVStrikethroughLabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *allDayLabel;
@property (nonatomic, strong) UILabel *AMPMLabel;
@property (nonatomic, strong) CVColoredDotView *coloredDotView;
@property (nonatomic, copy) NSString *dayLabelText;
@property (nonatomic) BOOL isToday;

+ (instancetype)cellForTableView:(UITableView *)tableView;
- (void)updateBackgroundColor;

@end
