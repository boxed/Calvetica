//
//  EKEvent+Store.h
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface EKEvent (Store)

- (void)saveThenDoActionBlock:(void (^)(void))saveActionBlock cancelBlock:(void (^)(void))cancelBlock;
- (void)saveForThisOccurrence;
- (void)removeThenDoActionBlock:(void (^)(void))removeActionBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
