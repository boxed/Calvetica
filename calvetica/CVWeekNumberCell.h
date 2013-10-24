//
//  CVFriendlyCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//
#import "CVCell.h"

#define WEEK_NUM_CELL_HEIGHT 30.0f


@interface CVWeekNumberCell : CVCell
@property (nonatomic, weak) IBOutlet UILabel *weekNumberLabel;
@end
