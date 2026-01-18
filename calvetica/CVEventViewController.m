//
//  CVEventViewController.m
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventViewController.h"
#import "UIApplication+Utilities.h"


@implementation CVEventViewController


- (id)initWithEvent:(EKEvent *)initEvent andMode:(CVEventMode)initMode
{
    self = [super init];
    if (self) {
        self.event = initEvent;
        _mode = initMode;
    }
    return self;
}

- (void)setMode:(CVEventMode)m 
{
    _mode = m;
    
    // set top bar buttons
    _dayBarButton.selected = NO;
    _hourBarButton.selected = NO;
    _detailsBarButton.selected = NO;
    
    _dayBarButton.hidden = NO;
    _hourBarButton.hidden = NO;
    _detailsBarButton.hidden = NO;
    _cancelButton.hidden = NO;
    _saveButton.hidden = NO;
    _closeButton.hidden = NO;
    _applyButton.hidden = YES;
    _subDetailHeaderTitle.hidden = YES;
    
    if (_mode == CVEventModeDay) {
        _dayBarButton.selected = YES;
    } else if (_mode == CVEventModeHour) {
        _hourBarButton.selected = YES;
    } else if (_mode == CVEventModeDetails) {
        _detailsBarButton.selected = YES;
    } else if (_mode == CVEventModeDetailsMore) {
        _detailsBarButton.selected = YES;
        
        _dayBarButton.hidden = YES;
        _hourBarButton.hidden = YES;
        _detailsBarButton.hidden = YES;
        _cancelButton.hidden = NO;
        _saveButton.hidden = YES;
        _closeButton.hidden = YES;
        _applyButton.hidden = NO;
        _subDetailHeaderTitle.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Make popup 50% taller on iPad
    if (PAD) {
        CGRect frame = self.view.frame;
        frame.size.height *= 1.5;
        self.view.frame = frame;
    }

    if (_mode == CVEventModeDay) {
        [self dayBarButtonWasTapped:nil];
    }

    else if (_mode == CVEventModeHour) {
        [self hourBarButtonWasTapped:nil];
    }

    else if (_mode == CVEventModeDetails) {
        [self detailsBarButtonWasTapped:nil];
    }

	if (!self.event.calendar.allowsContentModifications) {
		_saveButton.userInteractionEnabled = NO;
		_saveButton.alpha = 0.5;
	}
}




#pragma mark - Actions

- (void)dayBarButtonWasTapped:(id)sender 
{
    CVEventDayViewController *dayViewController = [[CVEventDayViewController alloc] init];
    dayViewController.delegate = self;
    dayViewController.initialDate = self.event.startingDate;
    self.viewControllers = @[dayViewController];
    
    self.mode = CVEventModeDay;
}

- (void)hourBarButtonWasTapped:(id)sender 
{
	CVEventHourViewController *hourViewController =
    [[CVEventHourViewController alloc] initWithStartDate:self.event.startingDate
                                                 endDate:self.event.endingDate
                                                  allDay:self.event.allDay
                                         useMilitaryTime:PREFS.twentyFourHourFormat];
	hourViewController.editable = _event.calendar.allowsContentModifications;

    __block CVEventHourViewController *hrv = hourViewController;

	[hourViewController setStartDateUpdatedBlock:^(NSDate *date) {
		NSDate *endDateBefore = [self->_event.endingDate copy];
        self->_event.startingDate = date;
		if (![endDateBefore isEqualToDate:self->_event.endingDate]) hrv.endDate = self->_event.endingDate;
	}];

	[hourViewController setEndDateUpdatedBlock:^(NSDate *date) {
		NSDate *startDateBefore = [self->_event.startingDate copy];
		self->_event.endingDate = date;
		if (![startDateBefore isEqualToDate:self->_event.startingDate]) hrv.startDate = self->_event.startingDate;
	}];

	[hourViewController setAllDayUpdatedBlock:^(BOOL allDay) {
        self->_event.allDay = NO;
		[self->_event resetDurationToDefault];

		// if the event is saved right after it is no longer in all day mode (start time = 12:00am)
		// it will be saved incorrectly on the calendar...(i.e. start time will be 6:00pm the previous day)

		// @hack: adding one second then subtracting it fixes the problem stated above
		self.event.startingDate = [self.event.startingDate mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:1];;
		self.event.startingDate = [self.event.startingDate mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];;

		self->_event.allDay = allDay;
	}];

	self.viewControllers = @[hourViewController];
    
    self.mode = CVEventModeHour;
}

- (void)detailsBarButtonWasTapped:(id)sender 
{
    CVEventDetailsViewController *detailViewController = [[CVEventDetailsViewController alloc] initWithEvent:self.event];
    detailViewController.delegate = self;
    
    // add it to the navigation controller (which means it gets added to the screen)
    self.viewControllers = @[detailViewController];
    
    self.mode = CVEventModeDetails;
}

- (IBAction)applyButtonWasTapped:(id)sender 
{
    if ([self.visibleViewController isKindOfClass:[CVEventDetailsNotesViewController class]]) {
        CVEventDetailsNotesViewController *controller = (CVEventDetailsNotesViewController *)self.visibleViewController;
        self.event.notes = controller.notesTextView.text;
        [controller.delegate eventDetailsNotesViewController:controller didFinish:CVEventDetailsNotesResultSaved];
    }
    if ([self.visibleViewController isKindOfClass:[CVEventDetailsLocationViewController class]]) {
        CVEventDetailsLocationViewController *controller = (CVEventDetailsLocationViewController *)self.visibleViewController;
        self.event.location = controller.locationTextView.text;
        [controller.delegate eventDetailsLocationViewController:controller didFinish:CVEventDetailsLocationResultSaved];
    }
    if ([self.visibleViewController isKindOfClass:[CVEventDetailsRepeatViewController class]]) {
        CVEventDetailsRepeatViewController *controller = (CVEventDetailsRepeatViewController *)self.visibleViewController;
        self.event.recurrenceRules = @[[controller recurrenceRule]];
        [controller.delegate eventDetailsRepeatViewController:controller didFinish:CVEventDetailsRepeatResultSaved];
    }
    [self popViewControllerAnimated:YES];
    if (self.visibleViewController == self.topViewController) {
        self.mode = CVEventModeDetails;
    }
}

- (void)closeButtonWasTapped:(id)sender 
{
    [self cancelButtonWasTapped:sender];
}

- (void)cancelButtonWasTapped:(id)sender 
{
    if (self.mode == CVEventModeDetailsMore) {
        [self popViewControllerAnimated:YES];
        
        if (self.visibleViewController == self.topViewController) {
            self.mode = CVEventModeDetails;
        }
    }
    else {
		[self.event reset];
        [self.delegate eventViewController:self didFinishWithResult:CVEventResultCancelled];
    }
}

- (void)saveButtonWasTapped:(id)sender 
{
    // if the selected calendar is hidden show it
    if (self.event.calendar.isHidden) {
        self.event.calendar.hidden = NO;
    }
	[self.event saveThenDoActionBlock:^(void) {
		[self.delegate eventViewController:self didFinishWithResult:CVEventResultSaved];
	} cancelBlock:^(void) {}];
}




#pragma mark - Event Day View Controller Delegate

- (void)eventDayViewController:(CVEventDayViewController *)controller didUpdateDate:(NSDate *)date
{
    NSDate *newDate = [NSDate mt_dateFromYear:[date mt_year]
                                        month:[date mt_monthOfYear]
                                          day:[date mt_dayOfMonth]
                                         hour:[_event.startingDate mt_hourOfDay]
                                       minute:[_event.startingDate mt_minuteOfHour]];
    [_event shiftEndDateBySettingStartDate:newDate];
}




#pragma mark - Event Details View Controller Delegate

- (void)eventDetailsViewController:(CVEventDetailsViewController *)controller didPushViewController:(CVViewController *)pushedController animated:(BOOL)animated
{
    self.mode = CVEventModeDetailsMore;
    if ([pushedController isKindOfClass:[CVEventDetailsNotesViewController class]]) {
        self.subDetailHeaderTitle.text = @"EVENT NOTES";
    }
    else if ([pushedController isKindOfClass:[CVEventDetailsLocationViewController class]]) {
        self.subDetailHeaderTitle.text = @"EVENT LOCATION";
    }
    else if ([pushedController isKindOfClass:[CVEventDetailsRepeatViewController class]]) {
        self.subDetailHeaderTitle.text = @"EVENT REPEAT";
    }
}

- (void)eventDetailsViewController:(CVEventDetailsViewController *)controller didFinishWithResult:(CVEventDetailsResult)result
{
    if (result == CVEventDetailsResultDeleted) {
        [self.event removeThenDoActionBlock:^() { [self.delegate eventViewController:self didFinishWithResult:CVEventResultDeleted]; } cancelBlock:^(void) {
            CVEventDetailsViewController *controller = (CVEventDetailsViewController *)self.visibleViewController;
            [controller.deleteSlideLock resetSlider];
        }];
    }
}



#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched
{
    [_delegate eventViewController:self didFinishWithResult:CVEventResultCancelled];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
