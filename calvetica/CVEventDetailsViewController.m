//
//  CVEventDetailsViewController_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 5/5/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsViewController.h"
#import "CVEventEditViewController.h"
#import "UIApplication+Utilities.h"
#import "CVActionBlockButton.h"
#import "CVTimeZoneViewController.h"




@interface CVEventDetailsViewController () <CVTimeZoneViewControllerDelegate, CNContactViewControllerDelegate>

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

@property (nonatomic, strong) UITableView                  *eventPeopleTableView;

@property (nonatomic, strong) UIView                       *eventVideoLinkBlock;
@property (nonatomic, strong) CVRoundedButton              *videoLinkButton;
@end




@implementation CVEventDetailsViewController {
    CGFloat _savedScrollOffset;
}


- (instancetype)initWithEvent:(EKEvent *)initEvent
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
    self.eventLocationTextView.delegate     = nil;
    self.eventPeopleTableView.delegate      = nil;
    self.eventPeopleTableView.dataSource    = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _eventTitleTextView.text = [self.event mys_title];
    _eventNotesTextView.text = self.event.notes;
    _eventLocationTextView.text = self.event.location;

    _eventTitleTextView.inputAccessoryView = self.keyboardAccessoryView;

    if (!self.event.calendar.allowsContentModifications) {
        _addAttendeesButton.enabled = NO;
        [_addAttendeesButton setTitle:@"Does not support attendees" forState:UIControlStateDisabled];
    }


    // people block
    self.peopleTableViewController = [[CVEventDetailsPeopleTableViewController alloc] initWithEvent:self.event];
    self.peopleTableViewController.delegate = self;
    self.eventPeopleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.eventPeopleTableView.scrollEnabled = NO;
    self.eventPeopleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.eventPeopleTableView.rowHeight = 42;
    self.eventPeopleTableView.backgroundColor = [UIColor clearColor];
    self.peopleTableViewController.tableView = self.eventPeopleTableView;
    self.eventPeopleTableView.delegate = self.peopleTableViewController;
    self.eventPeopleTableView.dataSource = self.peopleTableViewController;
    [self.eventPeopleBlock addSubview:self.eventPeopleTableView];

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
    CGFloat sliderWidth = self.eventDeleteBlock.bounds.size.width - 30; // 15pt padding on each side
    self.deleteSlideLock.frame = CGRectMake(15, 35, sliderWidth, self.deleteSlideLock.bounds.size.height);
    self.deleteSlideLock.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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

    // video link block
    {
        CGFloat blockWidth = self.contentScrollView.bounds.size.width;
        self.eventVideoLinkBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, blockWidth, 73)];
        self.eventVideoLinkBlock.hidden = YES;

        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, blockWidth - 30, 20)];
        headerLabel.text = @"VIDEO LINK";
        headerLabel.font = [UIFont boldSystemFontOfSize:12];
        headerLabel.textColor = calSecondaryText();
        [self.eventVideoLinkBlock addSubview:headerLabel];

        self.videoLinkButton = [[CVRoundedButton alloc] initWithFrame:CGRectMake(15, 35, blockWidth - 30, 30)];
        NSString *urlString = [self.event.URL absoluteString];
        if (urlString.length > 0) {
            [self.videoLinkButton setTitle:urlString forState:UIControlStateNormal];
            self.videoLinkButton.enabled = YES;
        } else {
            [self.videoLinkButton setTitle:@"No video link" forState:UIControlStateNormal];
            self.videoLinkButton.enabled = NO;
        }
        [self.videoLinkButton addTarget:self action:@selector(videoLinkButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.eventVideoLinkBlock addSubview:self.videoLinkButton];

        [self.contentScrollView addSubview:self.eventVideoLinkBlock];
    }

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
        b.textColorSelected = calBackgroundColor();
    }
}

- (void)editRecurrenceRule:(EKRecurrenceFrequency)newFrequency 
{
    CVEventDetailsRepeatViewController *recurrenceViewController = nil;
    EKRecurrenceRule *recurrenceRule = nil;
    
    if (self.event.hasRecurrenceRules) {
        recurrenceRule = [[self.event.recurrenceRules lastObject] isValidCalveticaRule] ? [self.event.recurrenceRules lastObject] : [[self.event.recurrenceRules lastObject] validCalveticaRule];
    } else {
        recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:newFrequency interval:1 end:nil];
    }
    
    if (newFrequency == EKRecurrenceFrequencyDaily) {
        recurrenceViewController = [[CVEventDetailsRepeatDailyViewController alloc] initWithStartDate:self.event.startingDate recurrenceRule:recurrenceRule];
    } else if (newFrequency == EKRecurrenceFrequencyWeekly) {
        recurrenceViewController = [[CVEventDetailsRepeatWeeklyViewController alloc] initWithStartDate:self.event.startingDate recurrenceRule:recurrenceRule];
    } else if (newFrequency == EKRecurrenceFrequencyMonthly) {
        recurrenceViewController = [[CVEventDetailsRepeatMonthlyViewController alloc] initWithStartDate:self.event.startingDate recurrenceRule:recurrenceRule];
    } else if (newFrequency == EKRecurrenceFrequencyYearly) {
        recurrenceViewController = [[CVEventDetailsRepeatYearlyViewController alloc] initWithStartDate:self.event.startingDate recurrenceRule:recurrenceRule];
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
    NSArray *detailsOrderingArray = PREFS.eventDetailsOrdering;

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

                // Size the people table based on attendee count
                NSInteger attendeeCount = self.peopleTableViewController.participantDataHolderArray.count;
                CGFloat tableHeight = attendeeCount * cellHeight;
                CGFloat buttonHeight = 38; // button (30) + padding (8)

                if (self.peopleTableViewController.hasAttendees) {
                    self.eventPeopleTableView.frame = CGRectMake(15, 0, self.eventPeopleBlock.bounds.size.width - 30, tableHeight);
                    self.eventPeopleTableView.hidden = NO;
                    // Move button below the table
                    CGRect buttonFrame = _addAttendeesButton.frame;
                    buttonFrame.origin.y = tableHeight + 8;
                    _addAttendeesButton.frame = buttonFrame;
                    f.size.height = tableHeight + buttonHeight + 8;
                }
                else {
                    self.eventPeopleTableView.hidden = YES;
                    CGRect buttonFrame = _addAttendeesButton.frame;
                    buttonFrame.origin.y = 8;
                    _addAttendeesButton.frame = buttonFrame;
                    f.size.height = buttonHeight + 8;
                }

                currentY += f.size.height;
                [_eventPeopleBlock setFrame:f];
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

        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Video Link"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue] || self.event.URL == nil;
            if (hide) {
                _eventVideoLinkBlock.hidden = YES;
            }
            else {
                _eventVideoLinkBlock.hidden = NO;
                CGRect f = _eventVideoLinkBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_eventVideoLinkBlock setFrame:f];
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

- (void)recurrenceDialog:(CVEventDetailsRepeatDailyViewController *)dialog updatedRecurrence:(EKRecurrenceRule *)recurrenceRule 
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
        CVEventDetailsNotesViewController *notesViewController = [[CVEventDetailsNotesViewController alloc] init];
        notesViewController.delegate = self;
        notesViewController.event = self.event;
        notesViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        UIViewController *presenter = self.closestSystemPresentedViewController ?: self;
        [presenter presentViewController:notesViewController animated:YES completion:nil];
    } else if (textView == _eventLocationTextView) {
        CVEventDetailsLocationViewController *locationViewController = [[CVEventDetailsLocationViewController alloc] init];
        locationViewController.delegate = self;
        locationViewController.event = self.event;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:locationViewController];
        navController.modalPresentationStyle = UIModalPresentationFullScreen;
        UIViewController *presenter = self.closestSystemPresentedViewController ?: self;
        [presenter presentViewController:navController animated:YES completion:nil];
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

- (void)eventDetailsNotesViewController:(CVEventDetailsNotesViewController *)controller didFinish:(CVEventDetailsNotesResult)result
{
    if (result == CVEventDetailsNotesResultSaved) {
        _eventNotesTextView.text = self.event.notes;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Location View Controller Delegate

- (void)eventDetailsLocationViewController:(CVEventDetailsLocationViewController *)controller didFinish:(CVEventDetailsLocationResult)result
{
    if (result == CVEventDetailsLocationResultSaved) {
        _eventLocationTextView.text = self.event.location;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Repeat View Controller Delegate

- (void)eventDetailsRepeatViewController:(CVEventDetailsRepeatViewController *)controller didFinish:(CVEventDetailsRepeatResult)result 
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
        [self.peopleTableViewController loadAttendees];
        [self.peopleTableViewController.tableView reloadData];
        [self adjustLayoutOfBlocks];
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



#pragma mark - CVEventDetailsPeopleTableViewControllerDelegate

- (void)personWasSwiped:(NSString *)contactIdentifier
{
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSArray *keysToFetch = @[CNContactViewController.descriptorForRequiredKeys];
    CNContact *contact = [contactStore unifiedContactWithIdentifier:contactIdentifier keysToFetch:keysToFetch error:nil];
    if (contact) {
        CNContactViewController *contactVC = [CNContactViewController viewControllerForContact:contact];
        contactVC.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contactVC];
        navController.modalPresentationStyle = UIModalPresentationPageSheet;
        [self.closestSystemPresentedViewController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)chatButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers
{
    if (![MFMessageComposeViewController canSendText] || telephoneNumbers.count == 0) return;

    NSDictionary *firstNumber = [telephoneNumbers firstObject];
    NSString *telephone = [firstNumber objectForKey:@"telephone"];

    MFMessageComposeViewController *smsComposer = [[MFMessageComposeViewController alloc] init];
    smsComposer.messageComposeDelegate = self;
    smsComposer.recipients = @[telephone];
    smsComposer.modalPresentationStyle = UIModalPresentationPageSheet;
    self.rootController = self.closestSystemPresentedViewController;
    [self.rootController presentViewController:smsComposer animated:YES completion:nil];
}

- (void)emailButtonWasPressedForParticipants:(NSArray *)participantEmails
{
    if (![MFMailComposeViewController canSendMail] || participantEmails.count == 0) return;

    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    mailComposer.modalPresentationStyle = UIModalPresentationPageSheet;
    [mailComposer setToRecipients:participantEmails];
    self.rootController = self.closestSystemPresentedViewController;
    [self.rootController presentViewController:mailComposer animated:YES completion:nil];
}


#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
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
        [mailComposer setSubject:[self.event mys_title]];
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

- (void)videoLinkButtonWasTapped:(id)sender
{
    NSURL *url = self.event.URL;
    if (url) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (IBAction)timeZoneButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UINavigationController *navigationController        = [storyboard instantiateViewControllerWithIdentifier:@"TimeZoneNavigationController"];
    CVTimeZoneViewController *timeZoneViewController    = (CVTimeZoneViewController *)[navigationController.viewControllers lastObject];
    timeZoneViewController.delegate                     = self;
    timeZoneViewController.selectedTimeZone             = self.event.timeZone;
    timeZoneViewController.title                        = @"Select Time Zone";
    timeZoneViewController.showsDoneButton              = YES;
    [self.closestSystemPresentedViewController presentViewController:navigationController animated:YES completion:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
