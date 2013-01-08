//
//  EKSource+Calvetica.h
//  calvetica
//
//  Created by Adam Kirk on 10/3/12.
//
//

#import <EventKit/EventKit.h>

@interface EKSource (Calvetica)

- (BOOL)allowsCalendarAdditionsForEntityType:(EKEntityType)type;
- (NSString *)localizedTitle; // TODO: not localized

@end
