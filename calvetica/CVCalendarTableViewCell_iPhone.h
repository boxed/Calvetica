//
//  CVCalendarTableViewCell_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/15/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVColoredDotView.h"
#import "UITableViewCell+Nibs.h"
#import "CVCheckButton.h"

@interface CVCalendarTableViewCell_iPhone : UITableViewCell

#pragma mark - IBOutlets
@property (nonatomic, weak) IBOutlet CVColoredDotView *coloredDotView;
@property (nonatomic, weak) IBOutlet UILabel *calendarTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *calendarTypeLabel;
@property (nonatomic, weak) IBOutlet CVCheckButton *checkmarkImageButton;
@property (nonatomic, assign) BOOL disabled;

@end
