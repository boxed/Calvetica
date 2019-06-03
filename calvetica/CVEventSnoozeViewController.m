//
//  CVEventSnoozeViewController_iPhone.m
//  calvetica
//
//  Created by James Schultz on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventSnoozeViewController.h"
#import <QuartzCore/QuartzCore.h>




@interface CVEventSnoozeViewController ()
@property (nonatomic, weak) IBOutlet UILabel  *eventNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *tenMinutesButton;
@property (nonatomic, weak) IBOutlet UIButton *eventStartButton;
@end




@implementation CVEventSnoozeViewController

- (void)viewDidLoad 
{
	// hide the "at start time" button if the event has already passed
	if ([self.event.startingDate mt_isAfter:[NSDate date]]) {
		self.eventStartButton.hidden = YES;
		self.tenMinutesButton.frame = CGRectMake(12, 80, 261, 48);
	}

	// also hide it if the event already has an alarm that is really close or after the start time
	else {
		for (EKAlarm *alarm in self.event.alarms) {

			NSTimeInterval relativeOffset = alarm.relativeOffset;
			
			if (alarm.absoluteDate) {
				relativeOffset = [alarm.absoluteDate timeIntervalSinceDate:self.event.startingDate];
			}
			
			if (relativeOffset <= MTDateConstantSecondsInMinute) {
                self.eventStartButton.hidden = YES;
                self.tenMinutesButton.frame = CGRectMake(12, 80, 261, 48);
				break;				
			}
		}
	}
	
	
    
    self.eventNameLabel.text = [self.event mys_title];
    [super viewDidLoad];
}

- (IBAction)eventDetailsButtonWasHit:(id)sender 
{
    [self.delegate eventSnoozeViewController:self didFinishWithResult:CVEventSnoozeResultShowDetails]; 
}

- (IBAction)snoozeButtonWasHit:(id)sender 
{
    UIButton *button = (UIButton *)sender;
    NSTimeInterval interval = button.tag * MTDateConstantSecondsInMinute;

//	EKEvent *event = [EKEventStore eventWithIdentifier:_event.identifier];

	dispatch_async([CVOperationQueue backgroundQueue], ^{
		// figure out what alarms have already gone off
		NSMutableArray *alarmsToRemove = [NSMutableArray array];
		for (EKAlarm *alarm in self->_event.alarms) {

			// get the date of the alarm
			NSDate *timeOfAlarm = alarm.absoluteDate;
			if (!timeOfAlarm) {
				timeOfAlarm = [self->_event.startingDate dateByAddingTimeInterval:alarm.relativeOffset];
			}

			// see if the alarm time has already passed
			NSDate *rightNow = [NSDate date];
			NSTimeInterval interval = [rightNow timeIntervalSinceDate:timeOfAlarm];

			// if the alarm already went off, remove it from the event
			if (interval > 0) {
				[alarmsToRemove addObject:alarm];
			}
		}

		// remove the past alarms
		for (EKAlarm *alarm in alarmsToRemove) {
			[self->_event removeAlarm:alarm];
		}

		// add the snoozed alarm
		[self->_event addSnoozeAlarmWithTimeInterval:interval];

		// save this occurrence of the event
		[self->_event saveForThisOccurrence];

		// tell the delegate
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate eventSnoozeViewController:self didFinishWithResult:CVEventSnoozeResultSnoozed];
		});
	});
}

- (void)cancelButtonWasTapped:(id)sender 
{
    [self.delegate eventSnoozeViewController:self didFinishWithResult:CVEventSnoozeResultCancelled];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
