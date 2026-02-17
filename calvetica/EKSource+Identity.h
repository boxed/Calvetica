//
//  EKSource+Calvetica.h
//  calvetica
//
//  Created by Adam Kirk on 10/3/12.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKSource (Identity)

+ (EKSource *)defaultSource;
- (NSString *)localizedTitle; // TODO: not localized

@end

NS_ASSUME_NONNULL_END
