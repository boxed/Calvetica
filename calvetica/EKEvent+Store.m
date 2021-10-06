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




#pragma mark - Private

- (BOOL)saveWithSpan2:(EKSpan)span error:(NSError **)error
{
    CVNotificationChangeType type = self.isNew ? CVNotificationChangeTypeCreate : CVNotificationChangeTypeUpdate;
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
