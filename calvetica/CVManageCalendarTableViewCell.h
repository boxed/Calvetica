//
//  CVCalendarTableViewCell_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/10/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVColoredDotView.h"
#import "UITableViewCell+Nibs.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVManageCalendarTableViewCell : UITableViewCell {}

@property (nonatomic, nullable, weak) IBOutlet CVColoredDotView *coloredDotView;
@property (nonatomic, nullable, weak) IBOutlet UILabel          *calendarTitleLabel;
@property (nonatomic, nullable, weak) IBOutlet UILabel          *calendarTypeLabel;
@property (nonatomic, nullable, weak) IBOutlet UIImageView      *checkmarkImageView;
@property (nonatomic, nullable, weak) IBOutlet UIView           *gestureHitAreaView;

@end

NS_ASSUME_NONNULL_END
