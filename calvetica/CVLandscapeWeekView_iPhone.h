//
//  CVLandscapeWeekView_iPhone.h
//  Calvetica
//
//  Created by Adam Kirk on 4/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



#import "CVLandscapeWeekView.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVLandscapeWeekView_iPhone : CVLandscapeWeekView

- (void)openQuickAddWithDate:(NSDate *)datePressed allDay:(BOOL)allDay;
- (void)openJumpToDateWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
