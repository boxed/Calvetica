//
//  CVMapLauncher.h
//  calvetica
//

#import <Foundation/Foundation.h>
#import "CVSharedSettings.h"

NS_ASSUME_NONNULL_BEGIN


/// Opens event locations in the user's preferred map app (see PREFS.defaultMapApp).
@interface CVMapLauncher : NSObject

/// Shows the location in the default map app.
+ (void)openLocation:(NSString *)location;

/// Starts directions to the location in the default map app.
+ (void)routeToLocation:(NSString *)location;

/// Display name for a map app, for use in settings and menus.
+ (NSString *)nameForMapApp:(CVMapApp)mapApp;

@end

NS_ASSUME_NONNULL_END
