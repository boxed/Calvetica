//
//  EKReminder+UI.h
//  calvetica
//
//  Created by Adam Kirk on 10/19/13.
//
//

#import <EventKit/EventKit.h>
#import "CVColoredDotView.h"

NS_ASSUME_NONNULL_BEGIN


@interface EKReminder (UI)

- (CVColoredShape)colorDotShapeForPriority;

@end

NS_ASSUME_NONNULL_END
