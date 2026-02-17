//
//  calveticaAppDelegate.m
//  calvetica
//
//  Created by Adam Kirk on 3/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAppDelegate.h"
#import <CoreFoundation/CoreFoundation.h>
#import "CVRootViewController.h"
#import "dictionarykeys.h"
#import "CVNativeAlertView.h"
#import "CVDebug.h"


@interface CVAppDelegate ()
@property (nonatomic, assign) UIBackgroundTaskIdentifier setLocalNotifsBackgroundTask;
@property (nonatomic, assign) BOOL isLaunching;
@property (nonatomic, strong) NSTimer *refreshTimer;
@end


@implementation CVAppDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLaunching = YES;
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[NSDate mt_setFirstDayOfWeek:PREFS.weekStartsOnWeekday];
	[NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];

    if (PREFS.timeZoneName) {
        NSTimeZone *tz = [NSTimeZone timeZoneWithName:PREFS.timeZoneName];
        [NSDate mt_setTimeZone:tz];
    }

	_setLocalNotifsBackgroundTask = UIBackgroundTaskInvalid;

    self.window.tintColor = RGB(215, 0, 0);

    // Global dark mode appearance configuration for grouped table views
    [[UITableView appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]]
     setBackgroundColor:UIColor.systemGroupedBackgroundColor];
    [[UITableViewCell appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]]
     setBackgroundColor:UIColor.secondarySystemGroupedBackgroundColor];

    // Set up UNUserNotificationCenter
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError *error) {
        if (error) {
            NSLog(@"Notification authorization error: %@", error);
        }
    }];

    return YES;
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    // App is in foreground — show the snooze dialog inline
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSString *soundName = notification.request.content.sound ? notification.request.content.userInfo[@"soundFileName"] : nil;
    [self handleSnoozeActionForNotificationWhileOpen:userInfo soundName:soundName];

    completionHandler(UNNotificationPresentationOptionNone);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
    // User tapped the notification (from background/killed)
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self handleSnoozeActionForNotification:userInfo];

    completionHandler();
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options_
{
    NSString *action = [url host];

    NSString *queryString           = [url query];
    NSMutableDictionary *options    = [NSMutableDictionary new];
    if ([queryString length] > 0) {
        NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
        for (NSString *pair in pairs) {
            NSArray *components = [pair componentsSeparatedByString:@"="];
            if ([components count] == 2) {
                NSString *key   = components[0];
                NSString *value = [components[1] stringByRemovingPercentEncoding];
                [options setObject:value forKey:key];
            }
        }
        NSLog(@"%@", options);
    }

    if ([action isEqualToString:@"add"]) {
        // get title
        NSString *title         = options[@"title"];

        // get date
        NSString *dateString    = options[@"date"];
        NSDate *date            = [NSDate date];
        if ([dateString length] > 0) {
            date = [NSDate mt_dateFromISOString:dateString];
        }

        CVRootViewController *rootViewController = (CVRootViewController *)_window.rootViewController;
        [rootViewController showQuickAddWithTitle:title date:date];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.refreshTimer invalidate];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self setLocalNotifs];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (!self.isLaunching) {
        self.isLaunching = YES;

        CVRootViewController *rvc = (CVRootViewController *)_window.rootViewController;

        // check whether it's a new day, if so update the month buttons to reflect today
        if (![rvc.todaysDate mt_isWithinSameDay:[NSDate date]]) {
            rvc.todaysDate		= [NSDate date];
            rvc.selectedDate	= [NSDate date];
        }
        [rvc refreshUIAnimated:YES];
    }

    // trigger a pull request for remote sources
    [self refreshSources];
    [self scheduleRefreshTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}




#pragma mark - Handle Local Notif Received

- (void)handleSnoozeActionForNotificationWhileOpen:(NSDictionary *)userInfo soundName:(NSString *)soundName
{
    // gather the info from the notification
    NSDate *eventStartDate		= userInfo[NOTIFICATION_EVENT_START_DATE_KEY] ?: [NSDate date];
    NSString *identifier		= userInfo[NOTIFICATION_EVENT_IDENTIFIER_KEY];
    // set up a start and end date that will grab a minimum amount of events, but that will include the event.
    // NOTE: using identifier WILL NOT WORK because it could be a repeating event and pulling the event by the ei will give
    // you the first occurrence.
    NSDate *rightBeforeEvent	= [eventStartDate mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
    NSDate *rightAfterEvent		= [eventStartDate mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:1];
    NSArray *events				= [EKEventStore eventsFromDate:rightBeforeEvent toDate:rightAfterEvent forActiveCalendars:NO];

    for (EKEvent *event in events) {
        if ([event hasIdentifier:identifier]) {

            // get info for the alert
            NSString *title			= @"Calvetica";
            NSString *message		= [NSString stringWithFormat:@"%@\n%@", [event mys_title], [event.startingDate stringWithWeekdayMonthDayYearHourMinute]];
            NSString *cancelTitle	= @"Cancel";
            NSString *otherTitle	= @"Snooze";

            // present a standard style alert view to see if the user wants to snooze
            [CVNativeAlertView showWithTitle:title message:message soundName:soundName cancelButtonTitle:cancelTitle cancelButtonBlock:nil otherButtonTitle:otherTitle otherButtonBlock:^(void) {

                // show the snooze dialogue for this event
                CVRootViewController *rvc = (CVRootViewController *)self.window.rootViewController;
                [rvc showSnoozeDialogForEvent:event];

            }];

            break;
        }
    }
}

- (void)handleSnoozeActionForNotification:(NSDictionary *)userInfo
{
    // gather the info from the notification
    NSDate *eventStartDate	= userInfo[NOTIFICATION_EVENT_START_DATE_KEY];
    NSString *identifier	= userInfo[NOTIFICATION_EVENT_IDENTIFIER_KEY];

    // set up a start and end date that will grab a minimum amount of events, but that will include the event.
    // NOTE: using calendarItemIdentifier WILL NOT WORK because it could be a repeating event and pulling the event by the ei will give
    // you the first occurrence.
    NSDate *rightBeforeEvent	= [eventStartDate mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
    NSDate *rightAfterEvent		= [eventStartDate mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:1];

    [MTq def:^{
        NSArray *events = [EKEventStore eventsFromDate:rightBeforeEvent toDate:rightAfterEvent forActiveCalendars:NO];
        [MTq main:^{
            for (EKEvent *event in events) {
                if ([event hasIdentifier:identifier]) {

                    // show the snooze dialogue for this event
                    CVRootViewController *rvc = (CVRootViewController *)self.window.rootViewController;
                    [rvc showSnoozeDialogForEvent:event];

                    break;
                }
            }
        }];
    }];
}




#pragma mark - Private

#pragma mark (refresh)

- (void)scheduleRefreshTimer
{
    [self.refreshTimer invalidate];
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                         target:self
                                                       selector:@selector(refreshSources)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void)refreshSources
{
    [MTq def:^{
        [[EKEventStore sharedStore] refreshSourcesIfNecessary];
    }];
}

#pragma mark (local notifs)

- (void)setLocalNotifs
{
	UIApplication *app = [UIApplication sharedApplication];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    NSInteger badgeOrAlerts = PREFS.badgeOrAlerts;

    // immediately set the icon badge, notifs are set below
    if (badgeOrAlerts == CVLocalNotificationTypeBadge || badgeOrAlerts == CVLocalNotificationTypeBadgeAndAlerts) {
        app.applicationIconBadgeNumber = [[[NSDate date] mt_startOfCurrentDay] mt_dayOfMonth];
    }
    if (badgeOrAlerts == CVLocalNotificationTypeNone || badgeOrAlerts == CVLocalNotificationTypeAlerts) {
        app.applicationIconBadgeNumber = 0;

        // remove badge notifs immediately so that if the app is killed the
        // badge won't keep updating
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> *requests) {
            NSMutableArray<NSString *> *badgeIdentifiers = [NSMutableArray array];
            for (UNNotificationRequest *request in requests) {
                if (request.content.badge != nil) {
                    [badgeIdentifiers addObject:request.identifier];
                }
            }
            if (badgeIdentifiers.count > 0) {
                [center removePendingNotificationRequestsWithIdentifiers:badgeIdentifiers];
            }
        }];

		if (badgeOrAlerts == CVLocalNotificationTypeNone) return;
    }

	// if a background task is already going, ignore a request to create a new one
	if (_setLocalNotifsBackgroundTask != UIBackgroundTaskInvalid) return;

	// create the background task
	_setLocalNotifsBackgroundTask = [app beginBackgroundTaskWithExpirationHandler:^{
        if (self->_setLocalNotifsBackgroundTask != UIBackgroundTaskInvalid) {
            [app endBackgroundTask:self->_setLocalNotifsBackgroundTask];
            self->_setLocalNotifsBackgroundTask = UIBackgroundTaskInvalid;
		}
	}];

	// if for some reason the task can't run, forget it
	if (_setLocalNotifsBackgroundTask == UIBackgroundTaskInvalid) return;


    // using this queue will make sure two of these dont run at the same time
    [MTq file:^{
        // if the application becomes active, just forget setting alarms until the next time it goes inactive
        if (app.applicationState == UIApplicationStateActive) return;

        /**** START TIMING ****/
        NSDate *methodStart = [NSDate date];
        CVLog(@"STARTED LOCAL NOTIFS");
        /**********************/

        [center removeAllPendingNotificationRequests];

        NSInteger availableNotifsCount = 64;

        // Day of Month Badge Only
        if (badgeOrAlerts == 1) {
            [self scheduleBadgeNotifications:availableNotifsCount];
        }

        // Custom Alerts Only
        else if (badgeOrAlerts == 2) {
            [self setCalveticaAlarms:availableNotifsCount];
        }

        // Badge and Alerts
        else if (badgeOrAlerts == 3) {
            NSInteger alertsCount    = 50;
            NSInteger badgeCount    = availableNotifsCount - alertsCount;
            [self scheduleBadgeNotifications:badgeCount];
            [self setCalveticaAlarms:alertsCount];
        }

        /**** END TIMING ****/
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        CVLog(@"STOPPED LOCAL NOTIFS - TIME: %f", executionTime);
        /**********************/

        // signify the end of the to the OS
        [app endBackgroundTask:self->_setLocalNotifsBackgroundTask];
        self->_setLocalNotifsBackgroundTask = UIBackgroundTaskInvalid;

    }];
}

- (void)scheduleBadgeNotifications:(NSInteger)count
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	NSTimeZone *tz = PREFS.timeZoneName ? [NSTimeZone timeZoneWithName:PREFS.timeZoneName] : nil;

    NSDate *today = [[NSDate date] mt_startOfCurrentDay];

    // schedule the next count badges
    for (int i = 1; i < count; i++) {

        NSDate *fireDate = [today mt_dateByAddingYears:0 months:0 weeks:0 days:i hours:0 minutes:0 seconds:0];

        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.badge = @([fireDate mt_dayOfMonth]);

        NSCalendar *calendar = [NSCalendar currentCalendar];
        if (tz) calendar.timeZone = tz;
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:fireDate];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];

        NSString *identifier = [NSString stringWithFormat:@"badge-%d", i];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
    }
}

- (void)setCalveticaAlarms:(NSInteger)count
{
    NSDate *rightNow		= [NSDate date];
	NSDate *startDate		= [rightNow mt_dateDaysBefore:3];
	NSDate *endDate			= [startDate mt_dateWeeksAfter:5];
	UIApplication *app		= [UIApplication sharedApplication];
	NSTimeZone *tz			= PREFS.timeZoneName ? [NSTimeZone timeZoneWithName:PREFS.timeZoneName] : nil;
	NSString *soundToPlay	= PREFS.customAlertSoundFileName;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

    // fetch month events
    NSMutableArray *monthEvents = [NSMutableArray arrayWithArray:[EKEventStore eventsFromDate:startDate
                                                                                       toDate:endDate
                                                                           forActiveCalendars:NO]];

    NSMutableArray *notifDicts = [NSMutableArray array];

    for (EKEvent *event in monthEvents) {

		// if the application becomes active, just forget setting alarms until the next time it goes inactive
		if (app.applicationState == UIApplicationStateActive) return;

        for (EKAlarm *alarm in event.alarms) {

            NSDate *fireDate = nil;
            if (alarm.absoluteDate)
                fireDate = alarm.absoluteDate;
            else
                fireDate = [event.startingDate dateByAddingTimeInterval:alarm.relativeOffset];

			// if the alarm fire date has already past, ignore it
            if ([fireDate mt_isBefore:rightNow]) continue;

            // add 10 seconds offset like before
            NSDate *adjustedFireDate = [fireDate mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:10];

            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.body = [NSString stringWithFormat:@"%@\n%@", [event mys_title], [event.startingDate stringWithWeekdayMonthDayYearHourMinuteAlarmNotif:fireDate]];
            content.categoryIdentifier = @"SNOOZE_CATEGORY";

            if (soundToPlay) {
                content.sound = [UNNotificationSound soundNamed:soundToPlay];
            } else {
                content.sound = [UNNotificationSound defaultSound];
            }

            // we need the start date because repeating events could have the same ei,
            // so its insufficient to grab the specific event
            content.userInfo = @{
                NOTIFICATION_EVENT_START_DATE_KEY: event.startingDate,
                NOTIFICATION_EVENT_IDENTIFIER_KEY: event.identifier,
                @"soundFileName": soundToPlay ?: @""
            };

            [notifDicts addObject:@{@"fireDate": adjustedFireDate, @"content": content}];
        }
    }

    NSSortDescriptor *notifSort = [NSSortDescriptor sortDescriptorWithKey:@"fireDate" ascending:YES];
    NSArray *sortedArray = [notifDicts sortedArrayUsingDescriptors:@[notifSort]];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (tz) calendar.timeZone = tz;

    for (NSInteger i = 0; i < sortedArray.count && i < count; i++) {
        NSDictionary *dict = sortedArray[i];
        NSDate *fireDate = dict[@"fireDate"];
        UNMutableNotificationContent *content = dict[@"content"];

        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:fireDate];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];

        NSString *identifier = [NSString stringWithFormat:@"alarm-%ld", (long)i];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
    }
}

+ (BOOL)hasNotch
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.top > 20.0;
    }

    return false;
}

@end
