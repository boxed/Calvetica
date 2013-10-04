//
//  CVAlarmPickerPopout_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAlarmPickerViewController.h"
#import "CVExtraAlarmButton.h"




@interface CVAlarmPickerViewController ()
@property (nonatomic, strong) UINib *extraAlarmButtonNib;

@end


@implementation CVAlarmPickerViewController

- (UINib *)extraAlarmButtonNib 
{
	if (!_extraAlarmButtonNib) {
		_extraAlarmButtonNib = [CVExtraAlarmButton nib];
	}
	return _extraAlarmButtonNib;
}

- (id)init 
{
    self = [super init];
    if (self) {
        _buttons = [NSMutableArray array];
		[_buttons addObject:@-0];								// 0min
		[_buttons addObject:@(-(45 * SECONDS_IN_MINUTE))];			// 45min
		[_buttons addObject:@(-(12 * SECONDS_IN_HOUR))];			// 12hr
		[_buttons addObject:@(-(5 * SECONDS_IN_DAY))];				// 5d
		[_buttons addObject:@(-(5 * SECONDS_IN_MINUTE))];			// 5min
		[_buttons addObject:@(-(1 * SECONDS_IN_HOUR))];			// 1hr
		[_buttons addObject:@(-(1 * SECONDS_IN_DAY))];				// 1d
		[_buttons addObject:@(-(1 * SECONDS_IN_WEEK))];			// 1wk
		[_buttons addObject:@(-(15 * SECONDS_IN_MINUTE))];			// 15min
		[_buttons addObject:@(-(2 * SECONDS_IN_HOUR))];			// 2hr
		[_buttons addObject:@(-(2 * SECONDS_IN_DAY))];				// 2d
		[_buttons addObject:@(-(2 * SECONDS_IN_WEEK))];			// 2wk
		[_buttons addObject:@(-(30 * SECONDS_IN_MINUTE))];			// 30min
		[_buttons addObject:@(-(6 * SECONDS_IN_HOUR))];			// 6hr
		[_buttons addObject:@(-(3 * SECONDS_IN_DAY))];				// 3d
		[_buttons addObject:@(-(1 * SECONDS_IN_MONTH))];			// 1mo
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidLoad 
{
    
    // set buttons selected appearance
    for (int i = 0; i < _buttons.count; i++) {
        CVToggleButton *button = (CVToggleButton *)[self.view viewWithTag:(i+1)];
        button.enabled = _calendarItem.calendar.allowsContentModifications;
        button.backgroundColorSelected = patentedDarkRed;
        button.textColorSelected = patentedWhite;
    }

    [super viewDidLoad];
}

- (NSArray *)alarms 
{
    NSMutableArray *alarmsTemp = [NSMutableArray new];
    for (NSInteger i = 0; i < _buttons.count; i++) {
        CVToggleButton *button = (CVToggleButton *)[self.view viewWithTag:(i+1)];
        if (button.selected) {
			id obj = [_buttons objectAtIndex:i];
			if ([obj isKindOfClass:[NSNumber class]]) {
				[alarmsTemp addObject:[EKAlarm alarmWithRelativeOffset:[obj intValue]]];
			}
			else if ([obj isKindOfClass:[NSDate class]]) {
				[alarmsTemp addObject:[EKAlarm alarmWithAbsoluteDate:obj]];
			}
        }
    }
    return alarmsTemp;
}

- (void)setAlarms:(NSArray *)newAlarms 
{
    for (int i = 0; i < _buttons.count; i++) {
        CVToggleButton *button = (CVToggleButton *)[self.view viewWithTag:(i+1)];
        button.selected = NO;
    }
    
    for (EKAlarm *alarm in newAlarms) {
        NSInteger offset = alarm.relativeOffset;
		BOOL found = NO;
        for (int i = 0; i < _buttons.count; i++) {
            NSNumber *offsetNumber = _buttons[i];
            if ([offsetNumber isKindOfClass:[NSNumber class]]) {
                NSInteger buttonOffset = [offsetNumber intValue];
                if (buttonOffset == offset) {
                    CVToggleButton *button = (CVToggleButton *)[self.view viewWithTag:(i+1)];
                    button.selected = YES;
                    found = YES;
                    break;
                }
            }
        }
		
		// if the alarm doesn't match up with one of the standard buttons, we need to add an extra one
		if (!found) {
			
			// create the new button
			CVExtraAlarmButton *extraButton = [CVExtraAlarmButton viewFromNib:self.extraAlarmButtonNib];
			
			extraButton.selected = YES;
			
			// set the title
			if (alarm.absoluteDate) {
				extraButton.titleLabel.text = [alarm.absoluteDate stringWithRelativeShortStyle];
				[_buttons addObject:alarm.absoluteDate];
			}
			else {
				extraButton.titleLabel.text = [[NSDate date] stringWithGreatestComponentsForInterval:alarm.relativeOffset];
				[_buttons addObject:[NSNumber numberWithInt:alarm.relativeOffset]];
			}
			
			// add it to the buttons array
			extraButton.tag = _buttons.count;
			
			// grow the height of the picker to make room for the button
			CGRect f = self.view.frame;
			f.size.height += extraButton.frame.size.height + 5;
			[self.view setFrame:f];
			
			// set the frame of the button
			f = extraButton.frame;
			f.origin.y = self.view.frame.size.height - f.size.height;
			[extraButton setFrame:f];
			
			// add it to the picker
			[self.view addSubview:extraButton];
		}
    }
}

- (void)setCalendarItem:(EKCalendarItem *)calendarItem
{
	_calendarItem = calendarItem;
	[self setAlarms:_calendarItem.alarms];
}




#pragma mark - Actions
- (IBAction)alarmButtonWasPressed:(id)sender 
{
    CVToggleButton *button = (CVToggleButton *)sender;
    // only allow one at a time
    if (_calendarItem.calendar.source.sourceType == EKSourceTypeExchange && ![CVSettings multipleExchangeAlarms]) {
        for (int i = 0; i < _buttons.count; i++) {
            CVToggleButton *alarmButton = (CVToggleButton *)[self.view viewWithTag:(i+1)];
            if ([alarmButton isEqual:button]) {
                if (alarmButton.selected == YES) {
                    alarmButton.selected = NO;
                }
                else {
                    alarmButton.selected = YES;
                }
            }
            else {
                alarmButton.selected = NO;
            }
        }
    }
    else {
        button.selected = !button.selected;
    }
}

- (void)modalBackdropWasTouched 
{
	// see any alarms were modified
	if (_calendarItem.alarms.count == self.alarms.count) {
		BOOL difference = NO;
		
		// if there are the same number of alarms, look for a difference between them
		for (EKAlarm *a1 in _calendarItem.alarms) {
			BOOL matchFound = NO;
			for (EKAlarm *a2 in self.alarms) {
				if (a1.absoluteDate && a2.absoluteDate && [a1.absoluteDate isEqualToDate:a2.absoluteDate]) {
					matchFound = YES;
				}
				else if (a1.relativeOffset == a2.relativeOffset) {
					matchFound = YES;
				}
			}
			if (!matchFound) difference = YES;
		}
		
		if (!difference) {
			[_delegate alarmPicker:self didFinishWithResult:CVAlarmPickerResultCancelled];
			return;
		}
	}

    _calendarItem.alarms = self.alarms;

	if ([_calendarItem isKindOfClass:[EKEvent class]]) {
		[(EKEvent *)_calendarItem saveThenDoActionBlock:^(void) {
			[_delegate alarmPicker:self didFinishWithResult:CVAlarmPickerResultChanged];
		} cancelBlock:^(void) {
			[(EKEvent *)_calendarItem reset];
			[_delegate alarmPicker:self didFinishWithResult:CVAlarmPickerResultCancelled];
		}];
	}
}


@end
