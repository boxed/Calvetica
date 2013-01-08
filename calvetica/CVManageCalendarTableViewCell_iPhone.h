//
//  CVCalendarTableViewCell_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/10/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVColoredDotView.h"
#import "UITableViewCell+Nibs.h"


@interface CVManageCalendarTableViewCell_iPhone : UITableViewCell {}

@property (nonatomic, strong) IBOutlet CVColoredDotView *coloredDotView;
@property (nonatomic, strong) IBOutlet UILabel *calendarTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *calendarTypeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *checkmarkImageView;
@property (nonatomic, strong) IBOutlet UIView *gestureHitAreaView;

@end
