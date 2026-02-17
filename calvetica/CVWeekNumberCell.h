//
//  CVFriendlyCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//
#import "CVCell.h"

NS_ASSUME_NONNULL_BEGIN


#define WEEK_NUM_CELL_HEIGHT 30.0f


@interface CVWeekNumberCell : CVCell
@property (nonatomic, nullable, weak) IBOutlet UILabel *weekNumberLabel;
@end

NS_ASSUME_NONNULL_END
