//
//  CVSceneDelegate.m
//  calvetica
//

#import "CVSceneDelegate.h"
#import "CVAppDelegate.h"
#import "CVRootViewController.h"

@implementation CVSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    // The storyboard is configured in the scene manifest, so the window and root VC are set up automatically.
    if (self.window) {
        self.window.tintColor = RGB(215, 0, 0);
    }
}

- (void)sceneDidBecomeActive:(UIScene *)scene
{
    CVAppDelegate *appDelegate = (CVAppDelegate *)[UIApplication sharedApplication].delegate;

    CVRootViewController *rvc = (CVRootViewController *)self.window.rootViewController;
    if (rvc) {
        // check whether it's a new day, if so update the month buttons to reflect today
        if (![rvc.todaysDate mt_isWithinSameDay:[NSDate date]]) {
            rvc.todaysDate  = [NSDate date];
            rvc.selectedDate = [NSDate date];
        }
        [rvc refreshUIAnimated:YES];
    }

    [appDelegate refreshSources];
    [appDelegate scheduleRefreshTimer];
}

- (void)sceneWillResignActive:(UIScene *)scene
{
    CVAppDelegate *appDelegate = (CVAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.refreshTimer invalidate];
}

- (void)sceneDidEnterBackground:(UIScene *)scene
{
    CVAppDelegate *appDelegate = (CVAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setLocalNotifs];
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    UIOpenURLContext *context = URLContexts.anyObject;
    if (!context) return;

    NSURL *url = context.URL;
    NSString *action = [url host];

    NSString *queryString = [url query];
    NSMutableDictionary *options = [NSMutableDictionary new];
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
    }

    if ([action isEqualToString:@"add"]) {
        NSString *title = options[@"title"];
        NSString *dateString = options[@"date"];
        NSDate *date = [NSDate date];
        if ([dateString length] > 0) {
            date = [NSDate mt_dateFromISOString:dateString];
        }

        CVRootViewController *rootViewController = (CVRootViewController *)self.window.rootViewController;
        [rootViewController showQuickAddWithTitle:title date:date];
    }
}

@end
