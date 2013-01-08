//
//  calveticaAppDelegate.m
//  calvetica
//
//  Created by Adam Kirk on 3/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAppDelegate.h"
#import <CoreFoundation/CoreFoundation.h>
#import "NSURLConnection+Utilities.h"
#import "NSJSONSerialization+Utilities.h"
#import "CVRootViewController.h"
#import "EKEvent+Utilities.h"
#import "CVEventStore.h"
#import "CVDevice.h"
#import "dictionarykeys.h"
#import "CVNativeAlertView.h"
#import "CVDebug.h"
#import "EKCalendarItem+Calvetica.h"

#import "CVEventStore.h"



@interface CVAppDelegate ()
@property (nonatomic) UIBackgroundTaskIdentifier setLocalNotifsBackgroundTask;
@property (nonatomic) UIBackgroundTaskIdentifier syncWithPocketLintBackgroundTask;
@end



@implementation CVAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    [self.window makeKeyAndVisible];

//	NSDate *now = [NSDate date];
//	NSDate *start = [now startOfCurrentDay];
//	NSDate *end	= [now endOfCurrentDay];
//	NSArray *events = [CVEventStore eventsFromDate:start toDate:end forActiveCalendars:NO];
////	for (EKEvent *event in events) {
////		event.allDay = YES;
////	}

	[NSDate setFirstDayOfWeek:[CVSettings weekStartsOnWeekday]];
	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];

	NSTimeZone *tz = [CVSettings timezone];
	if (tz && [CVSettings timeZoneSupport]) {
		[NSDate setTimeZone:tz];
	}

	_setLocalNotifsBackgroundTask = UIBackgroundTaskInvalid;
	_syncWithPocketLintBackgroundTask = UIBackgroundTaskInvalid;
    
    [TestFlight takeOff:@"6efade3967c3a27558172dfaaaa3d1b2_NjA2MzIwMTEtMDgtMTkgMjA6MTM6MDMuMzkyNTM3"];
	[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] identifierForVendor].UUIDString];
	[TestFlight setOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"logToConsole"]];
	[TestFlight setOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"logToSTDERR"]];
	#ifdef RELEASE
	[TestFlight setOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"sendLogOnlyOnCrash"]];
	#endif
	
    // if launched with options (meaning, a user tapped the "Snooze" button on a local notification.
    if (launchOptions) {
        // get the notification that was fired
        UILocalNotification *firedNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];    
        if (firedNotification) {
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				[self handleSnoozeActionBecauseOfNotification:firedNotification];
			});
            
        }
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
{
    // check whether the notification was received while active or while in background
    if (application.applicationState == UIApplicationStateActive) {
        [self handleSnoozeActionBecauseOfNotificationWhileOpen:notification];
    }
    else {
        [self handleSnoozeActionBecauseOfNotification:notification];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
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
	CVRootViewController *rvc = (CVRootViewController *)_window.rootViewController;
    
    // check whether it's a new day, if so update the month buttons to reflect today
    if (![rvc.todaysDate isWithinSameDay:[NSDate date]]) {
		rvc.todaysDate		= [NSDate date];
        rvc.selectedDate	= [NSDate date];
    }
    
    // check whether the table view needs to scroll
    if ([rvc.selectedDate isWithinSameDay:[NSDate date]]) {
        [rvc.rootTableViewController scrollToCurrentHour];
    }
    [rvc.rootTableViewController scrollToDate:rvc.selectedDate];

	// trigger a pull request for remote sources
	dispatch_async([CVOperationQueue backgroundQueue], ^{
		[[CVEventStore sharedStore].eventStore refreshSourcesIfNecessary];
	});
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
}




#pragma mark - Handle Local Notif Received

- (void)handleSnoozeActionBecauseOfNotificationWhileOpen:(UILocalNotification *)notif 
{
    // gather the info from the notification
    NSDictionary *userInfo		= notif.userInfo;
    NSDate *eventStartDate		= [userInfo objectForKey:NOTIFICATION_EVENT_START_DATE_KEY];
    NSString *identifier		= [userInfo objectForKey:NOTIFICATION_EVENT_IDENTIFIER_KEY];
    // set up a start and end date that will grab a minimum amount of events, but that will include the event.
    // NOTE: using identifier WILL NOT WORK because it could be a repeating event and pulling the event by the ei will give
    // you the first occurrence.
    NSDate *rightBeforeEvent	= [eventStartDate dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
    NSDate *rightAfterEvent		= [eventStartDate dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:1];
    NSArray *events				= [CVEventStore eventsFromDate:rightBeforeEvent toDate:rightAfterEvent forActiveCalendars:NO];

    for (EKEvent *event in events) {
        if ([event hasIdentifier:identifier]) {
            
            // get infor for the alert
            NSString *title			= @"Calvetica";
            NSString *message		= [NSString stringWithFormat:@"%@\n%@", [event readTitle], [event.startingDate stringWithWeekdayMonthDayYearHourMinute]];
            NSString *sound			= notif.soundName;
            NSString *cancelTitle	= @"Cancel";
            NSString *otherTitle	= @"Snooze";
            
            // present a standard style alert view to see if the user wants to snooze
            [CVNativeAlertView showWithTitle:title message:message soundName:sound cancelButtonTitle:cancelTitle cancelButtonBlock:nil otherButtonTitle:otherTitle otherButtonBlock:^(void) {
                
                // show the snooze dialogue for this event
                CVRootViewController *rvc = (CVRootViewController *)self.window.rootViewController;
                [rvc showSnoozeDialogForEvent:event];
                
            }];
            
            break;
        }
    }
}

- (void)handleSnoozeActionBecauseOfNotification:(UILocalNotification *)notif 
{
    // gather the info from the notification
    NSDictionary *userInfo	= notif.userInfo;
    NSDate *eventStartDate	= [userInfo objectForKey:NOTIFICATION_EVENT_START_DATE_KEY];
    NSString *identifier	= [userInfo objectForKey:NOTIFICATION_EVENT_IDENTIFIER_KEY];
    
    // set up a start and end date that will grab a minimum amount of events, but that will include the event.
    // NOTE: using calendarItemIdentifier WILL NOT WORK because it could be a repeating event and pulling the event by the ei will give
    // you the first occurrence.
    NSDate *rightBeforeEvent	= [eventStartDate dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
    NSDate *rightAfterEvent		= [eventStartDate dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:1];

	dispatch_async([CVOperationQueue backgroundQueue], ^{
		NSArray *events = [CVEventStore eventsFromDate:rightBeforeEvent toDate:rightAfterEvent forActiveCalendars:NO];
		dispatch_async(dispatch_get_main_queue(), ^{
			for (EKEvent *event in events) {
				if ([event hasIdentifier:identifier]) {

					// show the snooze dialogue for this event
					CVRootViewController *rvc = (CVRootViewController *)self.window.rootViewController;
					[rvc showSnoozeDialogForEvent:event];

					break;
				}
			}
		});
	});
}




#pragma mark - Local Notifs

- (void)setLocalNotifs
{
	UIApplication *app = [UIApplication sharedApplication];
    NSInteger badgeOrAlerts = [CVSettings badgeOrAlerts];
    
    // immediately set the icon badge, notifs are set below
    if (badgeOrAlerts == 1 || badgeOrAlerts == 3) {
        app.applicationIconBadgeNumber = [[[NSDate date] startOfCurrentDay] dayOfMonth];
    }
    if (badgeOrAlerts == 0 || badgeOrAlerts == 2) {
        app.applicationIconBadgeNumber = 0;
        
        // remove badge notifs immediately so that if the app is killed the 
        // badge won't keep updating
        NSArray *alerts = app.scheduledLocalNotifications;
        for (UILocalNotification *notif in alerts) {
            if (notif.applicationIconBadgeNumber) {
                [app cancelLocalNotification:notif];
            }
        }

		if (badgeOrAlerts == 0) return;
    }
	
	// if the device cant do background tasks, don't try
	if (![[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) return;
	
	// if a background task is already going, ignore a request to create a new one
	if (_setLocalNotifsBackgroundTask != UIBackgroundTaskInvalid) return;
	
	// create the background task
	_setLocalNotifsBackgroundTask = [app beginBackgroundTaskWithExpirationHandler:^{
		if (_setLocalNotifsBackgroundTask != UIBackgroundTaskInvalid) {
			[app endBackgroundTask:_setLocalNotifsBackgroundTask];
			_setLocalNotifsBackgroundTask = UIBackgroundTaskInvalid;
		}
	}];
	
	// if for some reason the task reminder can't run, forget it
	if (_setLocalNotifsBackgroundTask == UIBackgroundTaskInvalid) return;
	

    dispatch_async([CVOperationQueue localNotifQueue], ^(void) {
		
		// wait for a bit before doing this to make sure the app has been in the background for a long enough time
		//[NSThread sleepForTimeInterval:30];
		
		// if the application becomes active, just forget setting alarms until the next time it goes inactive
		if (app.applicationState == UIApplicationStateActive) return;

        /**** START TIMING ****/
		NSDate *methodStart = [NSDate date];
        CVLog(@"STARTED LOCAL NOTIFS");
        /**********************/


        //NSInteger showiconbadge = [CVSettings badgeOrAlerts];
        NSInteger availableNotifsCount = 64;
		
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // Day of Month Badge Only
        if (badgeOrAlerts == 1) {
            [self scheduleBadgeNotifications:availableNotifsCount];
        }

        // Custom Alerts Only
        else if (badgeOrAlerts == 2) {
            //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [self setCalveticaAlarms:availableNotifsCount];
        }
        
        // Badge and Alerts
        else if (badgeOrAlerts == 3) {
            NSInteger alertsCount	= 50;
            NSInteger badgeCount	= availableNotifsCount - alertsCount;
            [self scheduleBadgeNotifications:badgeCount];
            [self setCalveticaAlarms:alertsCount];
        }
        
        /**** END TIMING ****/
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        CVLog(@"STOPPED LOCAL NOTIFS - TIME: %f", executionTime);
        /**********************/
		
		// signify the end of the reminder to the OS
		[app endBackgroundTask:_setLocalNotifsBackgroundTask];
		_setLocalNotifsBackgroundTask = UIBackgroundTaskInvalid;

    });
}

- (void)scheduleBadgeNotifications:(NSInteger)count 
{
	UIApplication *app = [UIApplication sharedApplication];
	NSTimeZone *tz = [CVSettings timezone];
    
    NSDate *today = [[NSDate date] startOfCurrentDay];
    
    // schedule the next count badges
    for (int i = 1; i < count; i++) {
        
        NSDate *fireDate = [today dateByAddingYears:0 months:0 weeks:0 days:i hours:0 minutes:0 seconds:0];
        
        // schedule the notif
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = fireDate;
        localNotif.timeZone = tz;
        localNotif.applicationIconBadgeNumber = [localNotif.fireDate dayOfMonth];
        
		[app scheduleLocalNotification:localNotif];
    }
}

- (void)setCalveticaAlarms:(NSInteger)count 
{
    NSDate *rightNow		= [NSDate date];
	NSDate *startDate		= [rightNow dateDaysBefore:3];
	NSDate *endDate			= [startDate dateWeeksAfter:5];
	UIApplication *app		= [UIApplication sharedApplication];
	NSTimeZone *tz			= [CVSettings timezone];
	NSString *soundToPlay	= [CVSettings customAlertSoundFile] ? [CVSettings customAlertSoundFile] : UILocalNotificationDefaultSoundName;
    
    // fetch month events
    NSMutableArray *monthEvents = [NSMutableArray arrayWithArray:[CVEventStore eventsFromDate:startDate
                                                                                       toDate:endDate
                                                                           forActiveCalendars:NO]];
    
    NSMutableArray *notifArray = [NSMutableArray array];
        
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
            if ([fireDate isBefore:rightNow]) continue;
            
            // create the notification
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            localNotif.fireDate		= [fireDate dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:10];
            localNotif.timeZone		= tz;
            
            // compose the alert
            localNotif.alertBody	= [NSString stringWithFormat:@"%@\n%@", [event readTitle], [event.startingDate stringWithWeekdayMonthDayYearHourMinuteAlarmNotif:fireDate]];
            localNotif.alertAction	= @"Snooze";
            
            // we need the start date because repeating events could have the same ei, 
            // so its insufficient to grab the specific event
            localNotif.userInfo		= @{
											NOTIFICATION_EVENT_START_DATE_KEY: event.startingDate,
											NOTIFICATION_EVENT_IDENTIFIER_KEY: event.identifier
										};
            
			localNotif.soundName	= soundToPlay;

            [notifArray addObject:localNotif];
        }
    }
    
    NSSortDescriptor *notifSort = [NSSortDescriptor sortDescriptorWithKey:@"fireDate" ascending:YES];
    NSArray *sortDesciptors		= @[notifSort];
    NSArray *sortedArray		= [notifArray sortedArrayUsingDescriptors:sortDesciptors];
    
    for (NSInteger i = 0; i < sortedArray.count && i < count; i++) {
        UILocalNotification *notif = [sortedArray objectAtIndex:i];
        [app scheduleLocalNotification:notif];
    }
}


@end

