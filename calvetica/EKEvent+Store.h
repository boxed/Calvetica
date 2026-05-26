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

// Events created in calvetica are tagged (via the url field) with a per-user
// token that syncs across the user's own devices via iCloud key-value store, so
// they don't surface as "new" items in the inbox or light up the inbox badge —
// while events others add to a shared calendar still do.
+ (BOOL)isSelfCreatedEvent:(EKEvent *)event;

// YES when url is a calvetica creator tag (regardless of which user it belongs
// to), so it can be hidden from the UI instead of shown as a real link.
+ (BOOL)isCreatorTagURL:(nullable NSURL *)url;

@end

NS_ASSUME_NONNULL_END
