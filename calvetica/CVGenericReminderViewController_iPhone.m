//
//  CVGenericReminderViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVGenericReminderViewController_iPhone.h"
#import "viewtagoffsets.h"
#import "EKEvent+Utilities.h"



@interface CVGenericReminderViewController_iPhone ()
@property (nonatomic, weak) IBOutlet UITextField *eventTitleTextField;
@end



@implementation CVGenericReminderViewController_iPhone

- (id)init
{
    self = [super init];
    if (self) {
		_event = nil;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_eventTitleTextField becomeFirstResponder];
}

- (IBAction)closeButtonWasTapped:(id)sender 
{
    [self.delegate genericReminderViewController:self didFinishWithResult:CVGenericReminderViewControllerResultCancelled];
}

- (IBAction)reminderButtonWasTapped:(id)sender 
{
    [_eventTitleTextField resignFirstResponder];
    
    // set the start and end date
    UIView *button = (UIView *)sender;
    NSInteger minutes = button.tag - GENERIC_REMINDER_BUTTONS;
    NSDate *startDate = [[NSDate date] mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:minutes seconds:0];
    _event = [EKEvent eventWithDefaultsAtDate:startDate allDay:NO];

    if ([[_eventTitleTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        _event.title = NSLocalizedString(@"Generic Reminder", @"Generic Reminder");
    }
    else {
        _event.title = _eventTitleTextField.text;
    }

	dispatch_async([CVOperationQueue backgroundQueue], ^{
		[_event saveForThisOccurrence];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate genericReminderViewController:self didFinishWithResult:CVGenericReminderViewControllerResultAdded];
		});
	});    
}


#pragma mark - Modal Backdrop

- (void)modalBackdropWasTouched
{
    [_delegate genericReminderViewController:self didFinishWithResult:CVGenericReminderViewControllerResultCancelled];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
