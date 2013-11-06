//
//  EKCalendar+Settings.h
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import <EventKit/EventKit.h>

@interface EKCalendar (Settings)
@property (nonatomic, assign, getter=isHidden) BOOL    hidden;
@property (nonatomic, strong                 ) UIColor *customColor;
@end
