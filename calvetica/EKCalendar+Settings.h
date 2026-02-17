//
//  EKCalendar+Settings.h
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKCalendar (Settings)
@property (nonatomic, assign, getter=isHidden) BOOL    hidden;
@property (nonatomic, strong                 ) UIColor *customColor;
@end

NS_ASSUME_NONNULL_END
