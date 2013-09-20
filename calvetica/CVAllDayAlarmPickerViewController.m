//
//  CVAllDayAlarmPickerViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAllDayAlarmPickerViewController.h"


@implementation CVAllDayAlarmPickerViewController


- (id)init 
{
    self = [super init];
    if (self) {
        self.buttons = [NSMutableArray array];
		[self.buttons addObject:@(-(6 * SECONDS_IN_HOUR))];			// 6pm the day before
		[self.buttons addObject:@(-(2 * SECONDS_IN_HOUR))];			// 10pm the day before
		[self.buttons addObject:@(6 * SECONDS_IN_HOUR)];				// 6am the day of
		[self.buttons addObject:@(7 * SECONDS_IN_HOUR)];				// 7am the day of
		[self.buttons addObject:@(8 * SECONDS_IN_HOUR)];				// 8am the day of
		[self.buttons addObject:@(9 * SECONDS_IN_HOUR)];				// 9am the day of
    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    // set buttons selected appearance
    for (int i = 0; i < self.buttons.count; i++) {
        CVToggleButton *button = (CVToggleButton *)[self.view viewWithTag:(i+1)];
        button.enabled = self.calendarItem.calendar.allowsContentModifications;
        button.backgroundColorSelected = patentedDarkRed;
        button.textColorSelected = patentedWhite;
		
		NSInteger offset = [[self.buttons objectAtIndex:i] intValue];
		NSDate *scratchDate = [[[NSDate date] mt_startOfCurrentDay] dateByAddingTimeInterval:offset];
		
		NSMutableString *buttonTitle = [NSMutableString string];
		[buttonTitle appendString:[scratchDate stringWithHourAndLowercaseAMPM]];
		if (offset < 0) {
			[buttonTitle appendString:NSLocalizedString(@" the day before", @"A time relative to an all day event.  e.g. 6pm the day before")];
		}
		else {
			[buttonTitle appendString:NSLocalizedString(@" the day of", @"A time relative to an all day event.  e.g. 6pm the day of the event")];
		}
		button.titleLabel.text = buttonTitle;
    }
	
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
