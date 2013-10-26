//
//  CVCalendarTableViewCell_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/10/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVColoredDotView.h"
#import "UITableViewCell+Nibs.h"


@interface CVManageCalendarTableViewCell : UITableViewCell {}

@property (nonatomic, weak) IBOutlet CVColoredDotView *coloredDotView;
@property (nonatomic, weak) IBOutlet UILabel          *calendarTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel          *calendarTypeLabel;
@property (nonatomic, weak) IBOutlet UIImageView      *checkmarkImageView;
@property (nonatomic, weak) IBOutlet UIView           *gestureHitAreaView;

@end
