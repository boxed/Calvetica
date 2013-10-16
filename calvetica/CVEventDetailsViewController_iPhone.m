//
//  CVEventDetailsViewController_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 5/5/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsViewController_iPhone.h"
#import "CVEventEditViewController.h"
#import "UIApplication+Utilities.h"
#import "NSArray+Utilities.h"
#import "EKEventStore+Shared.h"
#import "CVActionBlockButton.h"
#import "CVTimeZoneViewController.h"




@interface CVEventDetailsViewController_iPhone () <CVTimeZoneViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView                *eventTitleBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventCalendarBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventNotesBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventRepeatBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventPeopleBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventAvailabilityBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventLocationBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventShareBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventDeleteBlock;
@property (nonatomic, weak) IBOutlet UIView                *eventAlarmsBlock;

@property (nonatomic, weak) IBOutlet CVButton              *availabilityBusyButton;
@property (nonatomic, weak) IBOutlet CVButton              *availabilityFreeButton;
@property (nonatomic, weak) IBOutlet CVButton              *availabilityTentativeButton;
@property (nonatomic, weak) IBOutlet CVButton              *availabilityOutOfficeButton;

@property (nonatomic, weak) IBOutlet UIScrollView          *contentScrollView;
@property (nonatomic, weak) IBOutlet UITextView            *eventTitleTextView;
@property (nonatomic, weak) IBOutlet UITableView           *eventCalendarTableView;
@property (nonatomic, weak) IBOutlet CVTextView            *eventNotesTextView;
@property (nonatomic, weak) IBOutlet CVTextView            *eventRepeatTextView;
@property (nonatomic, weak) IBOutlet UITableView           *eventPeopleTableView;
@property (nonatomic, weak) IBOutlet CVTextView            *eventLocationTextView;

@property (nonatomic, weak) IBOutlet CVRoundedToggleButton *repeatNoneButton;
@property (nonatomic, weak) IBOutlet CVRoundedToggleButton *repeatDailyButton;
@property (nonatomic, weak) IBOutlet CVRoundedToggleButton *repeatWeeklyButton;
@property (nonatomic, weak) IBOutlet CVRoundedToggleButton *repeatMonthlyButton;
@property (nonatomic, weak) IBOutlet CVRoundedToggleButton *repeatYearlyButton;

@property (nonatomic, weak) IBOutlet CVRoundedButton       *addAttendeesButton;

@property (nonatomic, weak) IBOutlet CVRoundedButton       *shareButtonEmail;
@property (nonatomic, weak) IBOutlet CVRoundedButton       *shareButtonSMS;

@property (nonatomic, weak) IBOutlet CVRoundedButton       *timeZoneButton;
@end




@implementation CVEventDetailsViewController_iPhone {
    CGFloat _savedScrollOffset;
}


- (id)initWithEvent:(EKEvent *)initEvent
{
    self = [super init];
    if (self) {
        _event = initEvent;
    }
    return self;
}

- (void)dealloc
{
    self.contentScrollView.delegate         = nil;
    self.eventTitleTextView.delegate        = nil;
    self.eventCalendarTableView.delegate    = nil;
    self.eventCalendarTableView.dataSource  = nil;
    self.eventNotesTextView.delegate        = nil;
    self.eventRepeatTextView.delegate       = nil;
    self.eventPeopleTableView.delegate      = nil;
    self.eventPeopleTableView.dataSource    = nil;
    self.eventLocationTextView.delegate     = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _eventTitleTextView.text = [self.event readTitle];
    _eventNotesTextView.text = self.event.notes;
    _eventLocationTextView.text = self.event.location;

    _eventTitleTextView.inputAccessoryView = self.keyboardAccessoryView;

    if (![self.event.calendar canAddAttendees]) {
        _addAttendeesButton.enabled = NO;
        [_addAttendeesButton setTitle:@"Does not support attendees" forState:UIControlStateDisabled];
    }


    // set up table view delegate objects

    // alarms block
    if (self.event.isAllDay) {
        self.allDayAlarmPicker = [[SCEventDetailsAllDayAlarmPicker alloc] init];
        self.allDayAlarmPicker.event = self.event;
        self.allDayAlarmPicker.view.frame = CGRectMake(15, 35, self.allDayAlarmPicker.view.bounds.size.width, self.allDayAlarmPicker.view.bounds.size.height);
        [self.eventAlarmsBlock addSubview:self.allDayAlarmPicker.view];
    }
    else {
        self.alarmPicker = [[SCEventDetailsAlarmPicker alloc] init];
        self.alarmPicker.event = self.event;
        self.alarmPicker.view.frame = CGRectMake(15, 35, self.alarmPicker.view.bounds.size.width, self.alarmPicker.view.bounds.size.height);
        [self.eventAlarmsBlock addSubview:self.alarmPicker.view];
    }

    // delete lock slider
    self.deleteSlideLock = [CVSlideLockControl fromNibOfSameName];
    self.deleteSlideLock.frame = CGRectMake(15, 35, self.deleteSlideLock.bounds.size.width, self.deleteSlideLock.bounds.size.height);
    self.deleteSlideLock.titleLabel.text = @"Slide to delete";
    self.deleteSlideLock.thumbImage = [UIImage imageNamed:@"slider"];
    [self.deleteSlideLock addTarget:self action:@selector(deleteSliderWasToggled:) forControlEvents:UIControlEventTouchUpInside];
    [self.eventDeleteBlock addSubview:self.deleteSlideLock];

    // if the event doesn't allow editing disable the slider
    if (![self.event.calendar allowsContentModifications]) {
        self.deleteSlideLock.alpha = 0.5;
        self.deleteSlideLock.enabled = NO;
    }

    // calendar table
    self.calendarTableViewController = [[CVCalendarPickerTableViewController alloc] init];
    _calendarTableViewController.delegate = self;
	_calendarTableViewController.tableView = _eventCalendarTableView;
    _eventCalendarTableView.delegate = _calendarTableViewController;
    _eventCalendarTableView.dataSource = _calendarTableViewController;
	_calendarTableViewController.showUneditableCalendars = !self.event.calendar.allowsContentModifications;

    // people table
    self.peopleTableViewController = [[CVEventDetailsPeopleTableViewController_iPhone alloc] initWithEvent:self.event];
    self.peopleTableViewController.delegate = self;
    self.peopleTableViewController.tableView = self.eventPeopleTableView;
    self.eventPeopleTableView.delegate = self.peopleTableViewController;
    self.eventPeopleTableView.dataSource = self.peopleTableViewController;

    // repeat block
    [self configureRepeatButtons];

    // time zone button
    if (self.event.timeZone) {
        [self.timeZoneButton setTitle:self.event.timeZone.name forState:UIControlStateNormal];
    }

    // Availability Block
    [self configureAvailabilityButtons];
    [self setAvailability:self.event.availability];

	self.shareButtonSMS.hidden = ![MFMessageComposeViewController canSendText];

	[self adjustLayoutOfBlocks];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_calendarTableViewController setSelectedCalendar:self.event.calendar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



- (void)configureAvailabilityButtons 
{
    EKCalendarEventAvailabilityMask mask = self.event.calendar.supportedEventAvailabilities;

    self.availabilityBusyButton.enabled = (mask & EKCalendarEventAvailabilityBusy) == EKCalendarEventAvailabilityBusy;
    self.availabilityFreeButton.enabled = (mask & EKCalendarEventAvailabilityFree) == EKCalendarEventAvailabilityFree;
    self.availabilityOutOfficeButton.enabled = (mask & EKCalendarEventAvailabilityUnavailable) == EKCalendarEventAvailabilityUnavailable;
    self.availabilityTentativeButton.enabled = (mask & EKCalendarEventAvailabilityTentative) == EKCalendarEventAvailabilityTentative;
    
    [self setAvailability:self.event.availability];
}

- (void)configureRepeatButtons 
{
    _repeatNoneButton.selectable = YES;
    _repeatDailyButton.selectable = YES;
    _repeatWeeklyButton.selectable = YES;
    _repeatMonthlyButton.selectable = YES;
    _repeatYearlyButton.selectable = YES;
    
    _repeatNoneButton.selected = NO;
    _repeatDailyButton.selected = NO;
    _repeatWeeklyButton.selected = NO;
    _repeatMonthlyButton.selected = NO;
    _repeatYearlyButton.selected = NO;
    
    _eventRepeatTextView.text = [self recurrenceString];
    if (!self.event.hasRecurrenceRules) {
        _repeatNoneButton.selected = YES;
    }
    else if ([(EKRecurrenceRule *)[self.event.recurrenceRules lastObject] frequency] == EKRecurrenceFrequencyDaily) {
        _repeatDailyButton.selected = YES;
    }
    else if ([(EKRecurrenceRule *)[self.event.recurrenceRules lastObject] frequency] == EKRecurrenceFrequencyWeekly) {
        _repeatWeeklyButton.selected = YES;
    }
    else if ([(EKRecurrenceRule *)[self.event.recurrenceRules lastObject] frequency] == EKRecurrenceFrequencyMonthly) {
        _repeatMonthlyButton.selected = YES;
    }
    else if ([(EKRecurrenceRule *)[self.event.recurrenceRules lastObject] frequency] == EKRecurrenceFrequencyYearly) {
        _repeatYearlyButton.selected = YES;
    }
    
    // set toggle buttons selected appearance
    NSArray *toggleButtons = @[_repeatNoneButton,
                              _repeatDailyButton, 
                              _repeatWeeklyButton, 
                              _repeatMonthlyButton, 
                              _repeatYearlyButton];
    
    for (CVButton *b in toggleButtons) {
        b.backgroundColorSelected = patentedRed;
        b.textColorSelected = patentedWhite;
    }
}

- (void)editRecurrenceRule:(EKRecurrenceFrequency)newFrequency 
{
    CVEventDetailsRepeatViewController_iPhone *recurrenceViewController = nil;
    EKRecurrenceRule *recurrenceRule = nil;
    
    if (self.event.hasRecurrenceRules) {
        recurrenceRule = [[self.event.recurrenceRules lastObject] isValidCalveticaRule] ? [self.event.recurrenceRules lastObject] : [[self.event.recurrenceRules lastObject] validCalveticaRule];
    } else {
        recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:newFrequency interval:1 end:nil];
    }
    
    if (newFrequency == EKRecurrenceFrequencyDaily) {
        recurrenceViewController = [[CVEventDetailsRepeatDailyViewController_iPhone alloc] initWithStartDate:self.event.startingDate recurrenceRule:recurrenceRule];
    } else if (newFrequency == EKRecurrenceFrequencyWeekly) {
        recurrenceViewController = [[CVEventDetailsRepeatWeeklyViewController_iPhone alloc] initWithStartDate:self.event.startingDate recurrenceRule:recurrenceRule];
    } else if (newFrequency == EKRecurrenceFrequencyMonthly) {
        recurrenceViewController = [[CVEventDetailsRepeatMonthlyViewController_iPhone alloc] initWithStartDate:self.event.startingDate recurrenceRule:recurrenceRule];
    } else if (newFrequency == EKRecurrenceFrequencyYearly) {
        recurrenceViewController = [[CVEventDetailsRepeatYearlyViewController_iPhone alloc] initWithStartDate:self.event.startingDate recurrenceRule:recurrenceRule];
    } else {
        return;
    }
    
    recurrenceViewController.delegate = self;
    [self.modalNavigationController pushViewController:recurrenceViewController animated:YES];
    [self.delegate eventDetailsViewController:self didPushViewController:recurrenceViewController animated:YES];
}

- (void)hideKeyboard
{
    [_eventTitleTextView resignFirstResponder];
}

- (void)adjustLayoutOfBlocks 
{    
    
    // rearrange detail blocks to match user preferences
    NSArray *detailsOrderingArray = [CVSettings eventDetailsOrderingArray];
    
    // if there are no preferences set, just return
    if (!detailsOrderingArray) {
        return;
    }
    
    CGFloat currentY = 0;
    NSInteger cellHeight = 42;
    
    for (NSDictionary *dict in detailsOrderingArray) {
        if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Title"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventTitleBlock.hidden = YES;
            }
            else {
                CGRect f = _eventTitleBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventTitleBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Calendar"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventCalendarBlock.hidden = YES;
            }
            else {
                CGRect f = _eventCalendarBlock.frame;
                f.origin.y = currentY;
                
                CGFloat calendarTableContentSize = [self.calendarTableViewController calendars].count * cellHeight;
                CGSize calendarTableFrameSize = self.eventCalendarTableView.frame.size;
                
                CGFloat heightDifference = (calendarTableContentSize - calendarTableFrameSize.height);
                f.size.height +=heightDifference;
                
                currentY += f.size.height;
                [_eventCalendarBlock setFrame:f];
                
                self.eventCalendarTableView.frame = CGRectMake(self.eventCalendarTableView.frame.origin.x, self.eventCalendarTableView.frame.origin.y, self.eventCalendarTableView.bounds.size.width,  calendarTableContentSize);

            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Notes"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventNotesBlock.hidden = YES;
            }
            else {
                CGRect f = _eventNotesBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventNotesBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Repeat"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventRepeatBlock.hidden = YES;
            }
            else {
                CGRect f = _eventRepeatBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventRepeatBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"People"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventPeopleBlock.hidden = YES;
            }
            else {
                CGRect f = _eventPeopleBlock.frame;
                f.origin.y = currentY;
                
                CGFloat peopleTableContentSize = self.peopleTableViewController.participantDataHolderArray.count * cellHeight;
                CGSize peopleTableFrameSize = self.eventPeopleTableView.frame.size;
                
                CGFloat heightDifference = (peopleTableContentSize - peopleTableFrameSize.height);
                
                f.size.height += heightDifference;
                                
                currentY += f.size.height;
                [_eventPeopleBlock setFrame:f];
                
                f = _addAttendeesButton.frame;
                f.origin.y += heightDifference;
                [_addAttendeesButton setFrame:f];
                
                self.eventPeopleTableView.frame = CGRectMake(self.eventPeopleTableView.frame.origin.x, self.eventPeopleTableView.frame.origin.y, self.eventPeopleTableView.bounds.size.width, peopleTableContentSize);
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Availability"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventAvailabilityBlock.hidden = YES;
            }
            else {
                CGRect f = _eventAvailabilityBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventAvailabilityBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Location"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventLocationBlock.hidden = YES;
            }
            else {
                CGRect f = _eventLocationBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventLocationBlock setFrame:f];
            }
        }

        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Share"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventShareBlock.hidden = YES;
            }
            else {
                CGRect f = _eventShareBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventShareBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Delete"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventDeleteBlock.hidden = YES;
            }
            else {
                CGRect f = _eventDeleteBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventDeleteBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Alarms"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _eventAlarmsBlock.hidden = YES;
            }
            else {
                CGRect f = _eventAlarmsBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventAlarmsBlock setFrame:f];
            }
        }

    }
    
    // resize the scroll view
    CGSize s = _contentScrollView.contentSize;
    s.height = currentY;
    _contentScrollView.contentSize = s;
}

- (void)recurrenceDialog:(CVEventDetailsRepeatDailyViewController_iPhone *)dialog updatedRecurrence:(EKRecurrenceRule *)recurrenceRule 
{
}

- (EKRecurrenceFrequency)recurrenceFrequencyFromRepeatButtons 
{
    if (_repeatDailyButton.selected == YES) {
        return EKRecurrenceFrequencyDaily;
    } else if (_repeatWeeklyButton.selected == YES) {
        return EKRecurrenceFrequencyWeekly;
    } else if (_repeatMonthlyButton.selected == YES) {
        return EKRecurrenceFrequencyMonthly;
    } else if (_repeatYearlyButton.selected == YES) {
        return EKRecurrenceFrequencyYearly;
    } else {
        return -1;
    }
}

- (NSString *)recurrenceString 
{
    if (self.event.hasRecurrenceRules) {
        return [[self.event.recurrenceRules lastObject] naturalDescription];
    }
    
    return EVENT_NO_REPEAT;
}

- (void)setAvailability:(EKEventAvailability)availability 
{
    if (availability == EKEventAvailabilityNotSupported) {
        return;
    }
    
    self.availabilityBusyButton.selected = NO;
    self.availabilityFreeButton.selected = NO;
    self.availabilityOutOfficeButton.selected = NO;
    self.availabilityTentativeButton.selected = NO;
    
    self.event.availability = availability;
    
    if (availability == EKEventAvailabilityBusy) {
        self.availabilityBusyButton.selected = YES;
    } else if (availability == EKEventAvailabilityFree) {
        self.availabilityFreeButton.selected = YES;
    } else if (availability == EKEventAvailabilityUnavailable) {
        self.availabilityOutOfficeButton.selected = YES;
    } else if (availability == EKEventAvailabilityTentative) {
        self.availabilityTentativeButton.selected = YES;
    }
}

- (void)showEditRuleConfirmationThenDoAction:(void (^)(void))action cancel:(void (^)(void))cancel 
{
    CVActionBlockButton *editButton = [CVActionBlockButton buttonWithTitle:EDIT andActionBlock:^(void) {
        action();
    }];
    
    CVActionBlockButton *cancelButton = [CVActionBlockButton buttonWithTitle:CANCEL andActionBlock:^(void) {
        cancel();
    }];
    
    [UIApplication showAlertWithTitle:[NSLocalizedString(@"Unknown Recurrence", @"Message title when the user tries to edit a recurrence rule event") uppercaseString]
                              message:NSLocalizedString(@"This recurrence rule cannot be edited in Calvetica. Press edit to override the current rule.", @"Message when the user tries to edit a recurrence rule.")
                              buttons:@[editButton, cancelButton]
                                completion:cancel];
}




#pragma mark - Text View Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text 
{
    if (textView == _eventTitleTextView) {
        self.event.title = [textView.text stringByReplacingCharactersInRange:range withString:text];
    }
	return YES;
}

- (void)textViewWasTappedWhenUneditable:(CVTextView *)textView 
{
    if (textView == _eventNotesTextView) {
        CVEventDetailsNotesViewController_iPhone *notesViewController = [[CVEventDetailsNotesViewController_iPhone alloc] init];
        notesViewController.delegate = self;
        notesViewController.event = self.event;
        [self.modalNavigationController pushViewController:notesViewController animated:YES];
        [self.delegate eventDetailsViewController:self didPushViewController:notesViewController animated:YES];
    } else if (textView == _eventLocationTextView) {
        CVEventDetailsLocationViewController_iPhone *locationViewController = [[CVEventDetailsLocationViewController_iPhone alloc] init];
        locationViewController.delegate = self;
        locationViewController.event = self.event;
        [self.modalNavigationController pushViewController:locationViewController animated:YES];
        [self.delegate eventDetailsViewController:self didPushViewController:locationViewController animated:YES];
    } else if (textView == _eventRepeatTextView) {
        if (![[self.event.recurrenceRules lastObject] isValidCalveticaRule]) {
            [self showEditRuleConfirmationThenDoAction:^(void) {
                [self editRecurrenceRule:[self recurrenceFrequencyFromRepeatButtons]];
            } cancel:^(void) {
                return;
            }];
        } else {
            [self editRecurrenceRule:[self recurrenceFrequencyFromRepeatButtons]];
        }
    }
}




#pragma mark - Calendar Picker Delegate 

- (void)calendarPicker:(CVCalendarPickerTableViewController *)calendarPicker didPickCalendar:(EKCalendar *)calendar 
{
    if (calendar.source.sourceType == EKSourceTypeExchange && self.event.calendar.source.sourceType != EKSourceTypeExchange) {
        if (self.event.alarms) {
            self.event.alarms = @[[self.event.alarms firstObject]];
        }
        if (self.event.isAllDay) {
            [self.allDayAlarmPicker configureAlarmButtons];
        }
        else {
            [self.alarmPicker configureAlarmButtons];
        }
    }
    self.event.calendar = calendar;
    [self configureAvailabilityButtons];
}




#pragma mark - Notes View Controller Delegate

- (void)eventDetailsNotesViewController:(CVEventDetailsNotesViewController_iPhone *)controller didFinish:(CVEventDetailsNotesResult)result
{
    if (result == CVEventDetailsNotesResultSaved) {
        _eventNotesTextView.text = self.event.notes;
    }
}




#pragma mark - Location View Controller Delegate

- (void)eventDetailsLocationViewController:(CVEventDetailsLocationViewController_iPhone *)controller didFinish:(CVEventDetailsLocationResult)result
{
    if (result == CVEventDetailsLocationResultSaved) {
        _eventLocationTextView.text = self.event.location;
    }
}




#pragma mark - Repeat View Controller Delegate

- (void)eventDetailsRepeatViewController:(CVEventDetailsRepeatViewController_iPhone *)controller didFinish:(CVEventDetailsRepeatResult)result 
{
    if (result == CVEventDetailsRepeatResultSaved) {
        [self configureRepeatButtons];
    }
}




#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result 
{
    [self.rootController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    [self.rootController dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action 
{
	[self.closestSystemPresentedViewController dismissViewControllerAnimated:YES completion:nil];
    if (action == EKEventEditViewActionSaved) {
        // These methods are not needed. initWithEvent in VEventDetailsPeopleTableViewController_iPhone.m 
        // calls loadAttendees and also reloads the tableView data.
        //[self.peopleTableViewController loadAttendees];           
        //[self.peopleTableViewController.tableView reloadData];    
    }
    else if (action == EKEventEditViewActionDeleted) {
        [self.delegate eventDetailsViewController:self didFinishWithResult:CVEventDetailsResultDeleted];
    }
    //[self adjustLayoutOfBlocks];
}




#pragma mark - DELEGATE time zone view controller

- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didToggleSupportOn:(BOOL)isOn
{
    if (!isOn) {
        self.event.timeZone = nil;
        [self.timeZoneButton setTitle:@"Time Zone" forState:UIControlStateNormal];
    }
    else {
        self.event.timeZone = [NSTimeZone systemTimeZone];
        [self.timeZoneButton setTitle:self.event.timeZone.name forState:UIControlStateNormal];
    }
}

- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didSelectTimeZone:(NSTimeZone *)timeZone
{
    self.event.timeZone = timeZone;
    [self.timeZoneButton setTitle:timeZone.name forState:UIControlStateNormal];
}



#pragma mark - Actions

- (IBAction)availabilityButtonWasTapped:(id)sender 
{
    if (sender == self.availabilityBusyButton) {
        [self setAvailability:EKEventAvailabilityBusy];
    } else if (sender == self.availabilityFreeButton) {
        [self setAvailability:EKEventAvailabilityFree];
    } else if (sender == self.availabilityOutOfficeButton) {
        [self setAvailability:EKEventAvailabilityUnavailable];
    } else if (sender == self.availabilityTentativeButton) {
        [self setAvailability:EKEventAvailabilityTentative];
    }
}

- (IBAction)repeatButtonWasTapped:(CVRoundedToggleButton *)sender
{
    EKRecurrenceFrequency newFreq = -1;
    if (sender == _repeatNoneButton) {
        self.event.recurrenceRules = nil;
        [self configureRepeatButtons];
    } else if (sender == _repeatDailyButton) {
        newFreq = EKRecurrenceFrequencyDaily;
    } else if (sender == _repeatWeeklyButton) {
        newFreq = EKRecurrenceFrequencyWeekly;
    } else if (sender == _repeatMonthlyButton) {
        newFreq = EKRecurrenceFrequencyMonthly;
    } else if (sender == _repeatYearlyButton) {
        newFreq = EKRecurrenceFrequencyYearly;
    }

    if (self.event.hasRecurrenceRules && ![[self.event.recurrenceRules lastObject] isValidCalveticaRule]) {
        [self showEditRuleConfirmationThenDoAction:^(void) {
            [self editRecurrenceRule:newFreq];
        } cancel:^(void) {
            return;
        }];
    } else {
        [self editRecurrenceRule:newFreq];
    }
}

- (IBAction)shareButtonWasTapped:(id)sender 
{
    if (self.shareButtonEmail == sender && [MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        mailComposer.modalPresentationStyle = UIModalPresentationPageSheet;
        [mailComposer setMessageBody:[self.event naturalDescription] isHTML:NO];
        [mailComposer setSubject:[self.event readTitle]];
        NSString *icsString = [self.event iCalString];
        NSData *data = [icsString dataUsingEncoding:NSUTF8StringEncoding];
        [mailComposer addAttachmentData:data mimeType:@"text/calendar" fileName:[NSString stringWithFormat:@"%@.ics", self.event.title]];
        self.rootController = self.closestSystemPresentedViewController;
        [self.rootController presentViewController:mailComposer animated:YES completion:nil];


    } else if (self.shareButtonSMS == sender && [MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *smsComposer = [[MFMessageComposeViewController alloc] init];

        smsComposer.messageComposeDelegate = self;
        smsComposer.body = [self.event naturalDescriptionSMS];
        smsComposer.modalPresentationStyle = UIModalPresentationPageSheet;
        [UIApplication sharedApplication].statusBarHidden = NO;
        self.rootController = self.closestSystemPresentedViewController;
        [self.rootController presentViewController:smsComposer animated:YES completion:nil];
        
    }
}

- (void)deleteSliderWasToggled:(id)sender 
{
    [self.delegate eventDetailsViewController:self didFinishWithResult:CVEventDetailsResultDeleted];
}

- (IBAction)addAttendeesButtonWasTapped:(id)sender 
{
    // had to subclass the built in EK VC cause the dumb thing wouldn't rotate upside down.
    CVEventEditViewController *eventEditViewController = [[CVEventEditViewController alloc] init];
    eventEditViewController.event = self.event;
    eventEditViewController.eventStore = [EKEventStore sharedStore];
    eventEditViewController.editViewDelegate = self;
    eventEditViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self.closestSystemPresentedViewController presentViewController:eventEditViewController animated:YES completion:nil];
}

- (IBAction)timeZoneButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UINavigationController *navigationController        = [storyboard instantiateViewControllerWithIdentifier:@"TimeZoneNavigationController"];
    CVTimeZoneViewController *timeZoneViewController    = (CVTimeZoneViewController *)[navigationController.viewControllers lastObject];
    timeZoneViewController.delegate                     = self;
    timeZoneViewController.selectedTimeZone             = self.event.timeZone;
    timeZoneViewController.title                        = @"Select Time Zone";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        [self.closestSystemPresentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    timeZoneViewController.navigationItem.rightBarButtonItem = barButtonItem;
    [self.closestSystemPresentedViewController presentViewController:navigationController animated:YES completion:nil];
}




#pragma mark - CVEventDetailsPeopleTableViewController_iPhoneDelegate Methods

- (void)doneViewingPerson 
{
    [self.closestSystemPresentedViewController dismissPageModalViewControllerAnimated:YES completion:nil];
}

- (void)personWasSwiped:(NSNumber *)personID 
{
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
	if (addressBook) {
		ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
			if (granted) {
				ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, [personID intValue]);
				if (person) {
					ABPersonViewController *personController = [[ABPersonViewController alloc] init];
					personController.displayedPerson = person;
					personController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneViewingPerson)];

					UINavigationController *personNavController = [[UINavigationController alloc] initWithRootViewController:personController];

					[self.closestSystemPresentedViewController presentViewController:personNavController animated:YES completion:nil];
				}
				CFRelease(addressBook);
			}
		});
    }
}

- (void)chatButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers 
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        messageController.modalPresentationStyle = UIModalPresentationPageSheet;
        messageController.wantsFullScreenLayout = YES;
        
        if (telephoneNumbers.count > 1) {

            // present alert view and retrieve preferred number			
			NSMutableArray *alertButtons = [NSMutableArray array];
            for (NSDictionary *numberDict in telephoneNumbers) {
                NSString *label = [numberDict objectForKey:@"label"];
                NSString *telephone = [numberDict objectForKey:@"telephone"];
				
				CVActionBlockButton *button = [CVActionBlockButton buttonWithTitle:[NSString stringWithFormat:@"%@: %@", label, telephone]  andActionBlock:^(void) { 
                    [messageController setRecipients:@[telephone]];
                    [UIApplication sharedApplication].statusBarHidden = NO;
                    self.rootController = self.closestSystemPresentedViewController;
                    [self.rootController presentViewController:messageController animated:YES completion:nil];
				}];
				
				[alertButtons addObject:button];
            }
			
			[UIApplication showAlertWithTitle:[@"Person telephone numbers" uppercaseString] 
									  message:@"This person has more than one telephone number, please select from the list"
									  buttons:alertButtons
                                        completion:nil];
            
        }
        else {
            NSDictionary *numberDict = [telephoneNumbers lastObject];
            NSString *telephone = [numberDict objectForKey:@"telephone"];
            
            [messageController setRecipients:@[telephone]];
            [UIApplication sharedApplication].statusBarHidden = NO;
            self.rootController = self.closestSystemPresentedViewController;
            [self.rootController presentViewController:messageController animated:YES completion:nil];
        }
    }
}

- (void)emailButtonWasPressedForParticipants:(NSArray *)participantEmails 
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        mailComposer.modalPresentationStyle = UIModalPresentationPageSheet;
    
        [mailComposer setToRecipients:participantEmails];
        
        [self.presentedViewController presentViewController:mailComposer animated:YES completion:nil];
    }
}

- (void)callButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers 
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        if (telephoneNumbers.count > 1) {
			
			// present alert view and retrieve preferred number			
			NSMutableArray *alertButtons = [NSMutableArray array];
            for (NSDictionary *numberDict in telephoneNumbers) {
                NSString *label = [numberDict objectForKey:@"label"];
                NSString *telephone = [numberDict objectForKey:@"telephone"];
				
				CVActionBlockButton *button = [CVActionBlockButton buttonWithTitle:[NSString stringWithFormat:@"%@: %@", label, telephone]  andActionBlock:^(void) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telephone]]];
				}];
				
				[alertButtons addObject:button];
            }
			
			[UIApplication showAlertWithTitle:[@"Person telephone numbers" uppercaseString] 
									  message:@"This person has more than one telephone number, please select which one to call."
									  buttons:alertButtons
                                        completion:nil];
        }
        else {
            NSDictionary *numberDict = [telephoneNumbers lastObject];
            NSString *telephone = [numberDict objectForKey:@"telephone"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telephone]]];
        }
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
