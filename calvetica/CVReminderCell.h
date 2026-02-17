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
@property (nonatomic, nullable, weak) IBOutlet CVStrikethroughLabel *titleLabel;
@property (nonatomic, nullable, weak) IBOutlet UILabel              *timeLabel;
@property (nonatomic, nullable, weak) IBOutlet UILabel              *allDayLabel;
@property (nonatomic, nullable, weak) IBOutlet UILabel              *AMPMLabel;
@property (nonatomic, nullable, weak) IBOutlet CVColoredDotView     *coloredDotView;
@end

NS_ASSUME_NONNULL_END
