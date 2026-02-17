//
//  CVGenericReminderViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVGenericReminderViewController.h"
#import "viewtagoffsets.h"



@interface CVGenericReminderViewController ()
@property (nonatomic, weak) IBOutlet UITextField *eventTitleTextField;
@end



@implementation CVGenericReminderViewController

- (instancetype)init
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

    [MTq def:^{
		[self->_event saveForThisOccurrence];
        [MTq main:^{
			[self.delegate genericReminderViewController:self didFinishWithResult:CVGenericReminderViewControllerResultAdded];
        }];
	}];    
}


#pragma mark - Modal Backdrop

- (void)modalBackdropWasTouched
{
    [_delegate genericReminderViewController:self didFinishWithResult:CVGenericReminderViewControllerResultCancelled];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
