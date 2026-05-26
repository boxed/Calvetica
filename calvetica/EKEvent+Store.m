//
//  EKEvent+Store.m
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//

#import "EKEvent+Store.h"
#import "CVActionBlockButton.h"
#import "UIApplication+Utilities.h"
#import "CVEventStoreNotificationCenter.h"


@implementation EKEvent (Store)


#pragma mark - Public

- (void)saveThenDoActionBlock:(void (^)(void))saveActionBlock cancelBlock:(void (^)(void))cancelBlock
{
	if (self.hasRecurrenceRules && [self hadRecurrenceRuleOnPreviousSave]) {
		CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"Change only this one", @"Button text for a repeating event, it will only edit the selected event")  andActionBlock:^(void) {
			NSError *error = nil;
            BOOL success = [self saveWithSpan2:EKSpanThisEvent error:&error];

			if (!success) {

				CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"OK", @"Button text on the alert message") andActionBlock:^(void) {
				}];

				[UIApplication showAlertWithTitle:[NSLocalizedString(@"Error Saving Event", @"The title for an alert message") uppercaseString]
										  message:[error localizedDescription]
										  buttons:@[b1]
                                       completion:nil];

				[self reset];
			}

			saveActionBlock();
		}];

		CVActionBlockButton *b2 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"Change all future events", @"Button text that will edit the repeating event's future details") andActionBlock:^(void) {
			NSError *error = nil;
            BOOL success = [self saveWithSpan2:EKSpanFutureEvents error:&error];

			if (!success) {

				CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"OK", @"Button text on the alert message") andActionBlock:^(void) {
				}];

				[UIApplication showAlertWithTitle:[NSLocalizedString(@"Error Saving Event", @"The title for an alert message") uppercaseString]
										  message:[error localizedDescription]
										  buttons:@[b1]
                                       completion:nil];

				[self reset];
			}

			saveActionBlock();
		}];

		CVActionBlockButton *b3 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"Cancel", @"Button text that lets the user cancel an edit to an event") andActionBlock:^(void) {
			cancelBlock();
		}];

		NSArray *buttons = @[b1, b2, b3];

		[UIApplication showAlertWithTitle:[NSLocalizedString(@"Repeating Event", @"The title for a message displayed to user") uppercaseString]
								  message:NSLocalizedString(@"This event repeats.  What would you like to do?", @"Message text. The user is presented with choices")
								  buttons:buttons
                               completion:nil];
	}
	else {
        NSError *error = nil;
        BOOL success = [self saveWithSpan2:EKSpanFutureEvents error:&error];

		if (!success) {

			CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"OK", @"Button text on the alert message") andActionBlock:^(void) {
				cancelBlock();
			}];

			[UIApplication showAlertWithTitle:[NSLocalizedString(@"Error Saving Event", @"The title for an alert message") uppercaseString]
									  message:[error localizedDescription]
									  buttons:@[b1]
                                   completion:nil];

			[self reset];
		}
		else {
			saveActionBlock();
		}
	}
}

- (void)saveForThisOccurrence
{
    NSError *error = nil;
    BOOL success = [self saveWithSpan2:EKSpanThisEvent error:&error];

	if (!success) {

		CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"OK", @"Button text on the alert message") andActionBlock:^(void) {
		}];

		[UIApplication showAlertWithTitle:[NSLocalizedString(@"Error Saving Event", @"The title for an alert message") uppercaseString]
								  message:[error localizedDescription]
								  buttons:@[b1]
                               completion:nil];

		[self reset];
	}
}

- (void)removeThenDoActionBlock:(void (^)(void))removeActionBlock cancelBlock:(void (^)(void))cancelBlock
{

	if (self.hasRecurrenceRules) {
		CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"Change only this one", @"Button text for a repeating event, it will only edit the selected event")  andActionBlock:^(void) {
            NSError *error = nil;
            BOOL success = [self deleteWithSpan2:EKSpanThisEvent error:&error];

			if (!success) {

				CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"OK", @"Button text on the alert message") andActionBlock:^(void) {
				}];

				[UIApplication showAlertWithTitle:[NSLocalizedString(@"Error Saving Event", @"The title for an alert message") uppercaseString]
										  message:[error localizedDescription]
										  buttons:@[b1]
                                       completion:nil];

				[self reset];
			}

			removeActionBlock();
		}];

		CVActionBlockButton *b2 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"Change all future events", @"Button text that will edit the repeating event's future details") andActionBlock:^(void) {
            NSError *error = nil;
            BOOL success = [self deleteWithSpan2:EKSpanFutureEvents error:&error];

			if (!success) {

				CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"OK", @"Button text on the alert message") andActionBlock:^(void) {
				}];

				[UIApplication showAlertWithTitle:[NSLocalizedString(@"Error Saving Event", @"The title for an alert message") uppercaseString]
										  message:[error localizedDescription]
										  buttons:@[b1]
                                       completion:nil];

				[self reset];
			}

			removeActionBlock();
		}];

		CVActionBlockButton *b3 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"Cancel", @"Button text that lets the user cancel an edit to an event") andActionBlock:^(void) {
			cancelBlock();
		}];

		NSArray *buttons = @[b1, b2, b3];

		[UIApplication showAlertWithTitle:[NSLocalizedString(@"Repeating Event", @"The title for a message displayed to user") uppercaseString]
								  message:NSLocalizedString(@"This event repeats.  What would you like to do?", @"Message text. The user is presented with choices")
								  buttons:buttons
                               completion:nil];
	}
	else {
        NSError *error = nil;
        BOOL success = [self deleteWithSpan2:EKSpanFutureEvents error:&error];

		if (!success) {

			CVActionBlockButton *b1 = [CVActionBlockButton buttonWithTitle:NSLocalizedString(@"OK", @"Button text on the alert message") andActionBlock:^(void) {
			}];

			[UIApplication showAlertWithTitle:[NSLocalizedString(@"Error Saving Event", @"The title for an alert message") uppercaseString]
									  message:[error localizedDescription]
									  buttons:@[b1]
                                   completion:nil];

			[self reset];
		}
        
		removeActionBlock();
	}
}




#pragma mark - Self-created tracking

// Custom url scheme used to tag events created in calvetica. The value after the
// scheme is the creating user's token, so a tag created by one person on a shared
// calendar is not mistaken for "mine" by another person who shares that calendar.
static NSString * const kCreatorTagScheme = @"x-calvetica-creator";
static NSString * const kCreatorTokenKey  = @"calveticaCreatorToken";

// A stable, per-user token. It lives in the iCloud key-value store so it is the
// same across the user's own devices but private from anyone they share calendars
// with. Mirrored to NSUserDefaults so we still have a value before iCloud syncs.
+ (NSString *)currentUserCreatorToken
{
    NSUbiquitousKeyValueStore *cloud = [NSUbiquitousKeyValueStore defaultStore];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *token = [cloud stringForKey:kCreatorTokenKey];
    if (token.length == 0) {
        token = [defaults stringForKey:kCreatorTokenKey];
    }
    if (token.length == 0) {
        token = [[NSUUID UUID] UUIDString];
        [cloud setString:token forKey:kCreatorTokenKey];
        [cloud synchronize];
    }
    // Keep the local mirror in step with whichever value won.
    if (![[defaults stringForKey:kCreatorTokenKey] isEqualToString:token]) {
        [defaults setObject:token forKey:kCreatorTokenKey];
    }
    return token;
}

+ (BOOL)isCreatorTagURL:(NSURL *)url
{
    return [[url.scheme lowercaseString] isEqualToString:kCreatorTagScheme];
}

+ (BOOL)isSelfCreatedEvent:(EKEvent *)event
{
    NSURL *url = event.URL;
    if (![self isCreatorTagURL:url]) return NO;
    NSString *token = url.resourceSpecifier;
    return token.length > 0 && [token isEqualToString:[self currentUserCreatorToken]];
}

// Tags a brand-new event so it is recognised as self-created later. Only applied
// when the user hasn't set their own url, so we never clobber real data.
- (void)tagAsSelfCreatedIfNeeded
{
    if (self.URL != nil) return;
    NSString *token = [EKEvent currentUserCreatorToken];
    self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%@", kCreatorTagScheme, token]];
}


#pragma mark - Private

- (BOOL)saveWithSpan2:(EKSpan)span error:(NSError **)error
{
    BOOL wasNew = self.isNew;
    if (wasNew) {
        [self tagAsSelfCreatedIfNeeded];
    }
    CVNotificationChangeType type = wasNew ? CVNotificationChangeTypeCreate : CVNotificationChangeTypeUpdate;
    [[CVEventStoreNotificationCenter sharedCenter] listenForNotificationAboutCalendarItem:self
                                                                               changeType:type];
    return [[EKEventStore sharedStore] saveEvent:self span:span commit:YES error:error];
}

- (BOOL)deleteWithSpan2:(EKSpan)span error:(NSError **)error
{
    CVNotificationChangeType type = self.isNew ? CVNotificationChangeTypeCreate : CVNotificationChangeTypeUpdate;
    [[CVEventStoreNotificationCenter sharedCenter] listenForNotificationAboutCalendarItem:self
                                                                               changeType:type];
    return [[EKEventStore sharedStore] removeEvent:self span:span commit:YES error:error];
}


@end
