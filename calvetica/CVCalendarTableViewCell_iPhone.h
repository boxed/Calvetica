//
//  CVCalendarTableViewCell_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/15/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVColoredDotView.h"
#import "UITableViewCell+Nibs.h"

@interface CVCalendarTableViewCell_iPhone : UITableViewCell

#pragma mark - IBOutlets
@property (nonatomic, strong) IBOutlet CVColoredDotView *coloredDotView;
@property (nonatomic, strong) IBOutlet UILabel *calendarTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *calendarTypeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *checkmarkImageView;
@property (nonatomic, strong) IBOutlet UIView *gestureHitAreaView;
@property (nonatomic, assign) BOOL disabled;

@end
