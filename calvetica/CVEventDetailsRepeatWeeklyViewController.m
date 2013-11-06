//
//  CVEventDetailsRepeatWeeklyViewController_iPhone.m
//  calvetica
//
//  Created by Quenton Jones on 5/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsRepeatWeeklyViewController.h"
#import "colors.h"
#import "CVToggleButton.h"



@interface CVEventDetailsRepeatWeeklyViewController ()
@property (nonatomic, weak) IBOutlet UIView         *dayOfTheWeekButtons;
@property (nonatomic, strong)          NSMutableArray *daysOfTheWeek;
@end




@implementation CVEventDetailsRepeatWeeklyViewController




#pragma mark - Constructor

- (id)initWithStartDate:(NSDate *)date recurrenceRule:(EKRecurrenceRule *)rule 
{
    self = [super initWithStartDate:date recurrenceRule:rule];
    if (self) {
        self.daysOfTheWeek = [NSMutableArray arrayWithArray:rule.daysOfTheWeek];
    }
    return self;
}

- (NSMutableArray *)daysOfTheWeek 
{
    if (!_daysOfTheWeek) {
        self.daysOfTheWeek = [NSMutableArray arrayWithCapacity:7];
    }
    
    return _daysOfTheWeek;
}




#pragma mark - Methods


- (NSInteger)dayNumberForButtonTag:(NSInteger)tag 
{
    NSInteger startDay = PREFS.weekStartsOnWeekday;
    
    NSInteger dayNumber = tag + startDay -1;
    if (dayNumber > 7) {
        dayNumber -= 7;
    }
    return dayNumber;
}

- (EKRecurrenceRule *)recurrenceRule 
{
    EKRecurrenceEnd *end = nil;
    if (!self.endAfterView.hidden) {
        end = [EKRecurrenceEnd recurrenceEndWithOccurrenceCount:[self.endAfterLabel.text intValue]];
    } else if (!self.dateView.hidden) {
        NSDate *date = [NSDate mt_dateFromYear:self.selectedYear month:self.selectedMonth day:self.selectedDay + 1];
        end = [EKRecurrenceEnd recurrenceEndWithEndDate:date];
    }
    
    EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:[self.repeatTimesLabel.text intValue] daysOfTheWeek:self.daysOfTheWeek daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:end];
    return rule;
}




#pragma mark IBActions

- (void)weekButtonTapped:(CVToggleButton *)button 
{
    NSInteger dayOfWeek = [self dayNumberForButtonTag:button.tag];
    for (int i = 0; i < [self.daysOfTheWeek count]; i++) {
        EKRecurrenceDayOfWeek *d = [self.daysOfTheWeek objectAtIndex:i];
        if ([d dayOfTheWeek] == dayOfWeek) {
            [self.daysOfTheWeek removeObjectAtIndex:i];
            button.selected = NO;
            
            [self.delegate recurrenceDialog:self updatedRecurrence:[self recurrenceRule]];
            return;
        }
    }
    
    // The button was pressed.
    [self.daysOfTheWeek addObject:[EKRecurrenceDayOfWeek dayOfWeek:dayOfWeek]];
    button.selected = YES;
    
    [self.delegate recurrenceDialog:self updatedRecurrence:[self recurrenceRule]];
}




#pragma mark UIView

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    NSArray *shortWeekdaySymbols = [NSDate mt_veryShortWeekdaySymbols];
    
    for (CVViewButton *button in [self.dayOfTheWeekButtons subviews]) {
        // Default colors don't mesh with this view.
        button.textColorNormal = patentedBlack;
        button.textColorSelected = patentedWhite;
        
        button.titleLabel.text = [shortWeekdaySymbols objectAtIndex:[self dayNumberForButtonTag:button.tag] - 1];
        
        for (EKRecurrenceDayOfWeek *d in self.daysOfTheWeek) {
            if (d.dayOfTheWeek == [self dayNumberForButtonTag:button.tag]) {
                button.selected = YES;
                break;
            }
        }
    }
}

- (void)viewDidUnload 
{
	[self setDayOfTheWeekButtons:nil];
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
