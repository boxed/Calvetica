//
//  CVReminderCell.h
//  calvetica
//
//  Created by Adam Kirk on 10/15/13.
//
//

#import "CVColoredDotView.h"
#import "CVStrikethroughLabel.h"


@interface CVReminderCell : UITableViewCell
@property (nonatomic, weak) IBOutlet CVStrikethroughLabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel              *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel              *allDayLabel;
@property (nonatomic, weak) IBOutlet UILabel              *AMPMLabel;
@property (nonatomic, weak) IBOutlet CVColoredDotView     *coloredDotView;
@end
