//
//  DOSharedSettings.h
//  DOCore
//
//  Created by Ben Dolman on 6/27/13.
//


#define PREFS [CVSharedSettings defaultSettings]

/**
 * Settings that are stored in iCloud and shared between the Mac and iOS apps using NSUbiquitousKeyValueStore.
 * These properties are all KVO-compliant.
 *
 * You should always use the defaultSettings instance.
 *
 * CVSharedSettings is currently designed to be used only on the main thread.
 */
@interface CVSharedSettings : NSObject

/**
 * Always use this default instance
 */
+ (CVSharedSettings *)defaultSettings;


@property (nonatomic, assign, getter=isICloudEnabled) BOOL iCloudEnabled;


// settings
@property (nonatomic, strong) NSNumber *showReminders;


@end
