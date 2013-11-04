//
//  CVEventCell.h
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"
#import "CVCalendarItemCellDelegate.h"




@class CVSearchViewController;


@interface CVEventCell : CVCell

@property (nonatomic, weak  ) id<CVCalendarItemCellDelegate> delegate;
@property (nonatomic, strong) NSDate                         *date;
@property (nonatomic, strong) EKEvent                        *event;
@property (nonatomic        ) BOOL                           isAllDay;
@property (nonatomic        ) CGFloat                        durationBarPercent;
@property (nonatomic        ) CGFloat                        secondaryDurationBarPercent;
@property (nonatomic, strong) UIColor                        *durationBarColor;
@property (nonatomic, strong) UIColor                        *secondaryDurationBarColor;

- (void)drawDurationBarAnimated:(BOOL)animated;

@end
