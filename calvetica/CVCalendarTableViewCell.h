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

NS_ASSUME_NONNULL_BEGIN


@interface CVCalendarTableViewCell : UITableViewCell

#pragma mark - IBOutlets
@property (nonatomic, nullable, weak) IBOutlet CVColoredDotView *coloredDotView;
@property (nonatomic, nullable, weak) IBOutlet UILabel *calendarTitleLabel;
@property (nonatomic, nullable, weak) IBOutlet UILabel *calendarTypeLabel;
@property (nonatomic, nullable, weak) IBOutlet CVCheckButton *checkmarkImageButton;
@property (nonatomic, assign) BOOL disabled;

@end

NS_ASSUME_NONNULL_END
