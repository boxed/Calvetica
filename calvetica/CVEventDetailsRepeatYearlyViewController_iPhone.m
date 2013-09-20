//
//  CVEventDetailsRepeatYearlyViewController_iPhone.m
//  calvetica
//
//  Created by Quenton Jones on 5/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsRepeatYearlyViewController_iPhone.h"


#define END_VIEW_BOTTOM_POS CGRectMake(9.0f, 113.0f, 266.0f, 244.0f)
#define END_VIEW_TOP_POS CGRectMake(9.0f, 75.0f, 266.0f, 244.0f)

#define END_VIEW_BOTTOM_POS_LANDSCAPE CGRectMake(9.0f, 75.0f, 266.0f, 164.0f)
#define END_VIEW_TOP_POS_LANDSCAPE CGRectMake(9.0f, 50.0f, 266.0f, 164.0f)



@interface CVEventDetailsRepeatYearlyViewController_iPhone ()
// @todo(Quenton): I'm using this index to know what to update when a combo box closes. There's a better way I'm sure. I just don't have time to think of it right now.
@property NSInteger comboBoxIndex;
@property NSInteger dayOfWeekIndex;
@property NSInteger monthIndex;
@property NSInteger weekNumber;

@property (nonatomic, strong) NSArray *weekNumbersArray;
@property (nonatomic, strong) IBOutlet CVViewButton *dayOfWeekButton;
@property (weak, nonatomic, readonly) UILabel *dayOfWeekButtonLabel;
@property (nonatomic, strong) IBOutlet UIView *endView;
@property (nonatomic, strong) IBOutlet CVMultiToggleButton *weekNumberButton;
@property (nonatomic, strong) IBOutlet CVViewButton *monthButton;
@property (weak, nonatomic, readonly) IBOutlet UILabel *monthButtonLabel;
@property (nonatomic, strong) IBOutlet UIView *monthView;
@end




@implementation CVEventDetailsRepeatYearlyViewController_iPhone

- (UILabel *)dayOfWeekButtonLabel 
{
    return (UILabel *)[[self.dayOfWeekButton subviews] objectAtIndex:0];
}

- (UILabel *)monthButtonLabel 
{
    return (UILabel *)[[self.monthButton subviews] objectAtIndex:0];
}

- (UILabel *)weekNumberButtonLabel 
{
    return (UILabel *)[[self.weekNumberButton subviews] objectAtIndex:0];
}




#pragma mark - Methods


- (EKRecurrenceRule *)recurrenceRule 
{
    EKRecurrenceEnd *end = nil;
    if (!self.endAfterView.hidden) {
        end = [EKRecurrenceEnd recurrenceEndWithOccurrenceCount:[self.endAfterLabel.text intValue]];
    } else if (!self.dateView.hidden) {
        NSDate *date = [NSDate mt_dateFromYear:self.selectedYear month:self.selectedMonth day:self.selectedDay + 1];
        end = [EKRecurrenceEnd recurrenceEndWithEndDate:date];
    }
    
    if (_weekNumber == 0) {
        return [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:[self.repeatTimesLabel.text intValue] end:end];
    } else {
        // 5 is the last week. The iCal equivalent for this is -1.
        _weekNumber = _weekNumber == 5 ? -1 : _weekNumber;
        EKRecurrenceDayOfWeek *dayOfWeekRec = [EKRecurrenceDayOfWeek dayOfWeek:_dayOfWeekIndex + 1 weekNumber:_weekNumber];
        return [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:[self.repeatTimesLabel.text intValue] daysOfTheWeek:@[dayOfWeekRec] daysOfTheMonth:nil monthsOfTheYear:@[@(_monthIndex + 1)] weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:end];
    }
}




#pragma mark CVComboBoxDelegate

- (void)comboBox:(CVComboBoxViewController *)comboBox didFinishWithResult:(CVComboBoxResult)result 
{
    if (_comboBoxIndex == 0) {
        _dayOfWeekIndex = comboBox.selectedItemIndex;
        self.dayOfWeekButtonLabel.text = [comboBox.selectedItem description];
    } else if (_comboBoxIndex == 1) {
        _monthIndex = comboBox.selectedItemIndex;
        self.monthButtonLabel.text = [comboBox.selectedItem description];
    } else if (_comboBoxIndex == 2) {
        _weekNumber = comboBox.selectedItemIndex;
        self.weekNumberButtonLabel.text = [comboBox.selectedItem description];
        
        BOOL landscape;
        // look at height of viewcontroller to determine if it is in landscape orientation
        if (self.view.frame.size.height < 360) {
            landscape = YES;
        }
        else {
            landscape = NO;
        }
        //displays monthview as soon as a weekNumber is selected in the comboBox.
        if (_weekNumber == 0) {
            [UIView animateWithDuration:0.0f animations:^(void) {
                self.monthView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f animations:^(void) {
                    if (landscape) {
                        self.endView.frame = END_VIEW_TOP_POS_LANDSCAPE;
                    }
                    else {
                        self.endView.frame = END_VIEW_TOP_POS;
                    }
                }];
            }];
        } else {
            [UIView animateWithDuration:0.2f animations:^(void) {
                if (landscape) {
                    self.endView.frame = END_VIEW_BOTTOM_POS_LANDSCAPE;
                }
                else {
                    self.endView.frame = END_VIEW_BOTTOM_POS;
                }
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.0f animations:^(void) {
                    self.monthView.alpha = 1.0f;
                }];
            }];
        
        }
    }
    [self dismissFullScreenModalViewControllerAnimated:YES];
}



#pragma mark IBActions

- (void)dayOfWeekButtonTapped 
{
    _comboBoxIndex = 0;
    // @todo(Quenton): The weekdays should be ordered based on the user's preferences.
    CVComboBoxViewController *comboBox = [[CVComboBoxViewController alloc] initWithTargetView:self.dayOfWeekButton itemsToSelect:[NSDate mt_weekdaySymbols] selectedItemIndex:_dayOfWeekIndex];
    comboBox.delegate = self;
    [self presentFullScreenModalViewController:comboBox animated:YES];
}

- (void)monthButtonTapped 
{
    _comboBoxIndex = 1;
    CVComboBoxViewController *comboBox = [[CVComboBoxViewController alloc] initWithTargetView:self.monthButton itemsToSelect:[NSDate mt_monthlySymbols] selectedItemIndex:_monthIndex];
    comboBox.delegate = self;
    [self presentFullScreenModalViewController:comboBox animated:YES];
}

- (void)weekNumberButtonTapped 
{
    _comboBoxIndex = 2;
    CVComboBoxViewController *comboBox = [[CVComboBoxViewController alloc] initWithTargetView:self.weekNumberButton itemsToSelect:_weekNumbersArray selectedItemIndex:_weekNumber];
    comboBox.delegate = self;
    [self presentFullScreenModalViewController:comboBox animated:YES];
}




#pragma mark UIView

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.weekNumbersArray = @[REPEATS_ON_DATE, FIRST_WEEK, SECOND_WEEK, THIRD_WEEK, FOURTH_WEEK, LAST_WEEK];
    
    if (self.initialRecurrenceRule.daysOfTheWeek && [self.initialRecurrenceRule.daysOfTheWeek count] > 0) {
        EKRecurrenceDayOfWeek *d = [self.initialRecurrenceRule.daysOfTheWeek objectAtIndex:0];
        _dayOfWeekIndex = d.dayOfTheWeek - 1;
        self.dayOfWeekButtonLabel.text = [[NSDate mt_weekdaySymbols] objectAtIndex:_dayOfWeekIndex];
        //self.weekNumberButton.currentState = d.weekNumber;
        _weekNumber = d.weekNumber;
    }
    // 5 is the LAST_WEEK. The iCal equivalent for this is -1. Changes back to 5 so the numberButtonLabel can be set.
    _weekNumber = (_weekNumber == -1 ? 5 : _weekNumber);
    self.weekNumberButtonLabel.text = [_weekNumbersArray objectAtIndex:_weekNumber];

    if (self.initialRecurrenceRule.monthsOfTheYear && [self.initialRecurrenceRule.monthsOfTheYear count] > 0) {
        NSNumber *month = [self.initialRecurrenceRule.monthsOfTheYear objectAtIndex:0];
        _monthIndex = [month intValue] - 1;
        self.monthButtonLabel.text = [[NSDate mt_monthlySymbols] objectAtIndex:_monthIndex];
    }
    
    if (_weekNumber == 0) {
        self.monthView.alpha = 0.0f;
        self.endView.frame = END_VIEW_TOP_POS;
        
    } else {
        self.monthView.alpha = 1.0f;
        self.endView.frame = END_VIEW_BOTTOM_POS;
    }
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
