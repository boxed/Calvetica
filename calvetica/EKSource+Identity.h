//
//  EKSource+Calvetica.h
//  calvetica
//
//  Created by Adam Kirk on 10/3/12.
//
//

#import <EventKit/EventKit.h>

@interface EKSource (Identity)

+ (EKSource *)defaultSource;
- (NSString *)localizedTitle; // TODO: not localized

@end
