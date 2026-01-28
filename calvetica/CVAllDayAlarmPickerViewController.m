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
		[self.buttons addObject:@(-(6 * MTDateConstantSecondsInHour))];			// 6pm the day before
		[self.buttons addObject:@(-(2 * MTDateConstantSecondsInHour))];			// 10pm the day before
		[self.buttons addObject:@(6 * MTDateConstantSecondsInHour)];				// 6am the day of
		[self.buttons addObject:@(7 * MTDateConstantSecondsInHour)];				// 7am the day of
		[self.buttons addObject:@(8 * MTDateConstantSecondsInHour)];				// 8am the day of
		[self.buttons addObject:@(9 * MTDateConstantSecondsInHour)];				// 9am the day of
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
        button.textColorSelected = calBackgroundColor();
		
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
