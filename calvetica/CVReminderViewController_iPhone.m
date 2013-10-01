//
//  CVReminderViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderViewController_iPhone.h"
#import "EKCalendar+Utilities.h"
#import "EKReminder+Calvetica.h"
#import "CVModalProtocol.h"
#import "CVReminderViewController_iPhone.h"
#import "CVTextToggleButton.h"
#import "CVEventDayViewController_iPhone.h"
#import "CVReminderDetailsViewController_iPhone.h"



@interface CVReminderViewController_iPhone ()
@property (weak, nonatomic)	IBOutlet UILabel			*subDetailHeaderTitle;
@property (weak, nonatomic)	IBOutlet CVTextToggleButton *hourBarButton;
@property (weak, nonatomic)	IBOutlet CVTextToggleButton *dayBarButton;
@property (weak, nonatomic)	IBOutlet CVTextToggleButton *detailsBarButton;
@property (weak, nonatomic)	IBOutlet UIControl			*closeButton;
@property (weak, nonatomic)	IBOutlet UIControl			*cancelButton;
@property (weak, nonatomic)	IBOutlet UIControl			*saveButton;
@property (weak, nonatomic)	IBOutlet UIControl			*applyButton;
@end




@implementation CVReminderViewController_iPhone


- (id)initWithReminder:(EKReminder *)initReminder andMode:(CVReminderViewControllerMode)initMode
{
    self = [super init];
    if (self) {
        _reminder = initReminder;
        _mode = initMode;
    }
    return self;
}

- (void)setMode:(CVReminderViewControllerMode)m 
{
    _mode = m;
    
    // set top bar buttons
    _dayBarButton.selected			= NO;
	_hourBarButton.selected			= NO;
    _detailsBarButton.selected		= NO;

    _dayBarButton.hidden			= NO;
	_hourBarButton.hidden			= NO;
    _detailsBarButton.hidden		= NO;
    _closeButton.hidden				= NO;
    _saveButton.hidden				= NO;
    _cancelButton.hidden			= NO;

    _applyButton.hidden				= YES;
    _subDetailHeaderTitle.hidden	= YES;
    
    if (self.mode == CVReminderViewControllerModeDay)
        _dayBarButton.selected		= YES;

	else if (self.mode == CVReminderViewControllerModeHour)
		_hourBarButton.selected		= YES;

    else if (self.mode == CVReminderViewControllerModeDetails)
        _detailsBarButton.selected	= YES;

    else if (self.mode == CVReminderViewControllerModeMore) {
        _detailsBarButton.selected	= YES;
        
        _dayBarButton.hidden		= YES;
		_hourBarButton.hidden		= YES;
        _detailsBarButton.hidden	= YES;
        _closeButton.hidden			= YES;
        _saveButton.hidden			= YES;
        _cancelButton.hidden		= NO;
        _applyButton.hidden			= NO;
        _subDetailHeaderTitle.hidden = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    if (self.mode == CVReminderViewControllerModeDay)
        [self dayBarButtonWasTapped:nil];
    
    else if (self.mode == CVReminderViewControllerModeDetails)
        [self detailsBarButtonWasTapped:nil];
}




#pragma mark - Actions

- (IBAction)dayBarButtonWasTapped:(id)sender 
{
	CVEventDayViewController_iPhone *dayViewController = [[CVEventDayViewController_iPhone alloc] init];
    dayViewController.delegate = self;
    dayViewController.initialDate = self.reminder.startDate ?: self.reminder.dueDate;
    self.viewControllers = @[dayViewController];
    
    self.mode = CVReminderViewControllerModeDay;
}

- (IBAction)hourBarButtonWasTapped:(id)sender
{
	CVEventHourViewController_iPhone *hourViewController = [[CVEventHourViewController_iPhone alloc] initWithStartDate:_reminder.startDate
																											   endDate:_reminder.dueDate
																												allDay:NO
																									   useMilitaryTime:[CVSettings isTwentyFourHourFormat]];
	hourViewController.editable		= _reminder.calendar.allowsContentModifications;
	hourViewController.reminderUI	= YES;

    __block CVEventHourViewController_iPhone *hrv = hourViewController;

	[hourViewController setStartDateUpdatedBlock:^(NSDate *date) {
		NSDate *endDateBefore = [_reminder.dueDate copy];
		_reminder.startDate = date;
		if (![endDateBefore isEqualToDate:_reminder.dueDate]) hrv.endDate = _reminder.dueDate;
	}];

	[hourViewController setEndDateUpdatedBlock:^(NSDate *date) {
		NSDate *startDateBefore = [_reminder.startDate copy];
		_reminder.dueDate = date;
		if (![startDateBefore isEqualToDate:_reminder.startDate]) hrv.startDate = _reminder.startDate;
	}];

	self.viewControllers = @[hourViewController];

	self.mode = CVReminderViewControllerModeHour;
}

- (IBAction)detailsBarButtonWasTapped:(id)sender
{
    CVReminderDetailsViewController_iPhone *detailViewController = [[CVReminderDetailsViewController_iPhone alloc] initWithReminder:self.reminder];
    detailViewController.delegate = self;
    self.viewControllers = @[detailViewController];
        
    [detailViewController adjustLayoutOfBlocks];
    
    self.mode = CVReminderViewControllerModeDetails;
}

- (IBAction)closeButtonWasTapped:(id)sender 
{
    [self cancelButtonWasTapped:sender];
}

- (IBAction)cancelButtonWasTapped:(id)sender 
{
    if (self.mode == CVReminderViewControllerModeMore) {
        [self popViewControllerAnimated:YES];
        
        if (self.visibleViewController == self.topViewController) {
            self.mode = CVReminderViewControllerModeDetails;
        }
    }
    else {
        dispatch_async([CVOperationQueue backgroundQueue], ^{
           [_reminder rollback];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate reminderViewController:self didFinishWithResult:CVReminderViewControllerResultCancelled];
            });
        });
    }
}

- (IBAction)saveButtonWasTapped:(id)sender 
{
    dispatch_async([CVOperationQueue backgroundQueue], ^{
        // if the selected calendar is hidden show it
        EKCalendar *calendar = self.reminder.calendar;
        if (![calendar isASelectedCalendar]) {
            [CVSettings addSelectedReminderCalendar:calendar];
        }
        [_reminder save];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate reminderViewController:self didFinishWithResult:CVReminderViewControllerResultSaved];
        });
    });
}

- (IBAction)applyButtonWasTapped:(id)sender 
{
    if ([self.visibleViewController isKindOfClass:[CVEventDetailsNotesViewController_iPhone class]]) {
        CVEventDetailsNotesViewController_iPhone *controller = (CVEventDetailsNotesViewController_iPhone *)self.visibleViewController;
        _reminder.notes = controller.notesTextView.text;
        //[controller.reminder resetNotes];
        [controller.delegate eventDetailsNotesViewController:controller didFinish:CVEventDetailsNotesResultSaved];
    }
    [self popViewControllerAnimated:YES];
    
    if (self.visibleViewController == self.topViewController) {
        self.mode = CVReminderViewControllerModeDetails;
    }
}





#pragma mark - Day Picker VC Delegate

- (void)eventDayViewController:(CVEventDayViewController_iPhone *)controller didUpdateDate:(NSDate *)date
{
	_reminder.startDate = date;
}




#pragma mark - Details VC Delegate

- (void)reminderDetailsViewController:(CVReminderDetailsViewController_iPhone *)controller didPushViewController:(BOOL)animated
{
    self.mode = CVReminderViewControllerModeMore;
    if ([self.visibleViewController isKindOfClass:[CVEventDetailsNotesViewController_iPhone class]]) {
        self.subDetailHeaderTitle.text = @"REMINDER NOTES";
    }
}

- (void)reminderDetailsViewController:(CVReminderDetailsViewController_iPhone *)controller didFinishWithResult:(CVReminderDetailsResult)result
{
    if (result == CVReminderDetailsResultDeleted) {
        [controller.reminder remove];
        
        [self.delegate reminderViewController:self didFinishWithResult:CVReminderViewControllerResultDeleted];
    }
    if (result == CVReminderDetailsResultComplete) {
        if (self.reminder.isCompleted) {
            self.reminder.completed = NO;
			self.reminder.completionDate = nil;
        }
        else {
            self.reminder.completed = YES;
			self.reminder.completionDate = [NSDate date];
        }
		[self.reminder save];
        [self.delegate reminderViewController:self didFinishWithResult:CVReminderViewControllerResultSaved];
    }
}



#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched
{
    [self.delegate reminderViewController:self didFinishWithResult:CVReminderViewControllerResultCancelled];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
