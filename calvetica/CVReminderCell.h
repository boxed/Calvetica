//
//  CVReminderCell.h
//  calvetica
//
//  Created by Adam Kirk on 10/15/13.
//
//

#import "CVColoredDotView.h"
#import "CVStrikethroughLabel.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVReminderCell : UITableViewCell
@property (nonatomic, nullable, strong) CVStrikethroughLabel *titleLabel;
@property (nonatomic, nullable, strong) UILabel              *timeLabel;
@property (nonatomic, nullable, strong) UILabel              *allDayLabel;
@property (nonatomic, nullable, strong) UILabel              *AMPMLabel;
@property (nonatomic, nullable, strong) CVColoredDotView     *coloredDotView;

+ (instancetype)cellForTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
