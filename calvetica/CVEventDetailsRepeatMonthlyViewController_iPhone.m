//
//  CVEventDetailsRepeatMonthlyViewController_iPhone.m
//  calvetica
//
//  Created by Quenton Jones on 5/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsRepeatMonthlyViewController_iPhone.h"
#import "strings.h"
#import "CVMultiToggleButton.h"
#import "CVAutoResizableLabel.h"


@interface CVEventDetailsRepeatMonthlyViewController_iPhone ()

@property (nonatomic, copy            )          NSArray              *weekNumbersArray;
@property (nonatomic, copy            )          NSArray              *daysOfTheMonth;
@property (nonatomic, strong, readonly)          CVAutoResizableLabel *eachDayButtonLabel;

@property (nonatomic, assign          )          NSInteger            comboBoxIndex;
@property (nonatomic, assign          )          NSInteger            dayOfWeek;
@property (nonatomic, assign          )          NSInteger            repeatOnState;
@property (nonatomic, assign          )          NSInteger            weekNumber;

@property (nonatomic, weak            ) IBOutlet CVViewButton         *dayOfWeekButton;
@property (nonatomic, weak            ) IBOutlet CVViewButton         *eachDayButton;
@property (nonatomic, weak            ) IBOutlet CVMultiToggleButton  *repeatOnButton;
@property (nonatomic, weak            ) IBOutlet CVMultiToggleButton  *weekNumberButton;
@end



@implementation CVEventDetailsRepeatMonthlyViewController_iPhone




#pragma mark - Constructor

- (id)initWithStartDate:(NSDate *)date recurrenceRule:(EKRecurrenceRule *)rule 
{
    self = [super initWithStartDate:date recurrenceRule:rule];
    if (self) {
        NSArray *daysOfWeek = rule.daysOfTheWeek;
        if ([daysOfWeek count] > 0) {
          EKRecurrenceDayOfWeek *dw = [daysOfWeek objectAtIndex:0];
            // dayOfWeek and weekNumber are also set in viewDidLoad.
            _dayOfWeek = dw.dayOfTheWeek + 1;
            _weekNumber = dw.weekNumber;
        } else {
            _dayOfWeek = 0;
            // 1 will be subtracted in viewDidLoad
            _weekNumber = 1;
        }
        
        self.daysOfTheMonth = rule.daysOfTheMonth;
        if (!self.daysOfTheMonth || self.daysOfTheMonth.count == 0) {
            self.daysOfTheMonth = @[@1];
        }
        
        // The default is day of the week (state 0).
        _repeatOnState = rule.daysOfTheMonth ? 1 : 0;
        
        self.eachDayButtonLabel.text = [CVMonthlyRecurrenceSelectionViewController_iPhone daysOfTheMonthString:self.daysOfTheMonth];
        [self resizeEachDayButton];
    }
    return self;
}

- (CVAutoResizableLabel *)eachDayButtonLabel 
{
    return ((CVAutoResizableLabel *)[[self.eachDayButton subviews] objectAtIndex:0]);
}

- (UILabel *)dayOfWeekButtonLabel 
{
    return (UILabel *)[[self.dayOfWeekButton subviews] objectAtIndex:0];
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
    
    NSArray *recDaysOfTheWeek = nil;
    NSArray *recDaysOfTheMonth = nil;
    if (self.repeatOnButton.currentState == 0) {
        // 4 is the last week. The iCal equivalent for this is -1. weekNumbersArray (set in comboBox) indexes start at 0
        // add 1 to get correct week.
        _weekNumber =(_weekNumber == 4 ? -1 : _weekNumber + 1);
        recDaysOfTheWeek = @[[EKRecurrenceDayOfWeek dayOfWeek:_dayOfWeek + 1 weekNumber:_weekNumber]];
    } else if (self.repeatOnButton.currentState == 1) {
        recDaysOfTheMonth = self.daysOfTheMonth;
    }

    EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:[self.repeatTimesLabel.text intValue] daysOfTheWeek:recDaysOfTheWeek daysOfTheMonth:recDaysOfTheMonth monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:end];
    return rule;
}

- (void)resizeEachDayButton 
{
    // Resize the button to match the size of its label.
    self.eachDayButton.frame = CGRectMake(self.eachDayButton.frame.origin.x, self.eachDayButton.frame.origin.y, self.eachDayButtonLabel.frame.size.width, self.eachDayButtonLabel.frame.size.height);
}

#pragma mark CVComboBoxDelegate

- (void)comboBox:(CVComboBoxViewController *)comboBox didFinishWithResult:(CVComboBoxResult)result 
{
    if (_comboBoxIndex == 0) {
        _dayOfWeek = comboBox.selectedItemIndex;
        self.dayOfWeekButtonLabel.text = [comboBox.selectedItem description];
    }
    else if (_comboBoxIndex == 1) {
        _weekNumber =comboBox.selectedItemIndex;
        self.weekNumberButtonLabel.text = [comboBox.selectedItem description];
    }
    
    [self dismissFullScreenModalViewControllerAnimated:YES];
}



#pragma mark IBActions

- (void)dayOfWeekButtonTapped:(CVViewButton *)button 
{
    _comboBoxIndex = 0;
    CVComboBoxViewController *comboBox = [[CVComboBoxViewController alloc] initWithTargetView:self.dayOfWeekButton itemsToSelect:[NSDate mt_weekdaySymbols] selectedItemIndex:_dayOfWeek];
    comboBox.delegate = self;
    [self presentFullScreenModalViewController:comboBox animated:YES];
}

- (void)eachDayButtonTapped:(CVViewButton *)button 
{
    CVMonthlyRecurrenceSelectionViewController_iPhone *monthlyRecurrenceSelectionViewController = [[CVMonthlyRecurrenceSelectionViewController_iPhone alloc] initWithTargetView:self.eachDayButton selectedDays:self.daysOfTheMonth];
    monthlyRecurrenceSelectionViewController.delegate = self;
    [self presentFullScreenModalViewController:monthlyRecurrenceSelectionViewController animated:YES];
    
    // Hide the eachDayButton. We'll show it again when the view controller is dismissed.
    self.eachDayButton.hidden = YES;
}

- (void)repeatOnButtonTapped:(CVMultiToggleButton *)button 
{
    _repeatOnState = [button nextState];
    if (button.currentState == 0) {
        [UIView animateWithDuration:0.1f animations:^(void) {
            self.eachDayButton.alpha = 0.0f;
            self.weekNumberButton.alpha = 1.0f;
            self.dayOfWeekButton.alpha = 1.0f;
        } completion:nil];
    } else if (button.currentState == 1) {
        [UIView animateWithDuration:0.1f animations:^(void) {
            self.weekNumberButton.alpha = 0.0f;
            self.dayOfWeekButton.alpha = 0.0f;
            self.eachDayButton.alpha = 1.0f;
        } completion:nil];
    }
    
}

- (void)weekButtonTapped:(CVMultiToggleButton *)button 
{
    _comboBoxIndex = 1;
    CVComboBoxViewController *comboBox = [[CVComboBoxViewController alloc] initWithTargetView:self.weekNumberButton itemsToSelect:self.weekNumbersArray selectedItemIndex:_weekNumber];
    comboBox.delegate = self;
    [self presentFullScreenModalViewController:comboBox animated:YES];
    
}




#pragma mark CVMonthlyRecurrenceSelectionDelegate

- (void)monthlyRecurrenceSelection:(CVMonthlyRecurrenceSelectionViewController_iPhone *)selection didUpdateSelectedDays:(NSArray *)selectedDays 
{
    self.daysOfTheMonth = selectedDays;
}

- (void)monthlyRecurrenceSelectionWillClose:(CVMonthlyRecurrenceSelectionViewController_iPhone *)selection 
{
    self.eachDayButtonLabel.text = [CVMonthlyRecurrenceSelectionViewController_iPhone daysOfTheMonthString:self.daysOfTheMonth];
    [self resizeEachDayButton];
    self.eachDayButton.hidden = NO;
    
    [self dismissFullScreenModalViewControllerAnimated:YES];
}




#pragma mark UIView

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.weekNumbersArray = @[FIRST_WEEK, SECOND_WEEK, THIRD_WEEK, FOURTH_WEEK, LAST_WEEK];
    if (self.initialRecurrenceRule.daysOfTheWeek && [self.initialRecurrenceRule.daysOfTheWeek count] > 0) {
        EKRecurrenceDayOfWeek *d = [self.initialRecurrenceRule.daysOfTheWeek objectAtIndex:0];
        _dayOfWeek = d.dayOfTheWeek - 1;
        self.dayOfWeekButtonLabel.text = [[NSDate mt_weekdaySymbols] objectAtIndex:_dayOfWeek];
        _weekNumber = d.weekNumber;
    } 
    
    // 4 is the LAST_WEEK. The iCal equivalent for this is -1. Changes to 4 for the weekNumberButtonLabel to be set below.
    // 1 is subtracted for the correct object in the array to be selected.
    if (_weekNumber == 0) {
        _weekNumber = 1; // insure that no there will be no out of range index
    }
    _weekNumber = (_weekNumber == -1 ? 4 : _weekNumber - 1);

    self.weekNumberButtonLabel.text = [self.weekNumbersArray objectAtIndex:_weekNumber];
    
    self.repeatOnButton.states = @[REPEATS_ON_THE, REPEATS_EACH_DAY];
    self.repeatOnButton.currentState = _repeatOnState;
    
    self.eachDayButtonLabel.maximumWidth = 267.0f;
    if (_repeatOnState == 0) {
        _eachDayButton.alpha = 0.0f;
        _weekNumberButton.alpha = 1.0f;
        _dayOfWeekButton.alpha = 1.0f;
    } else if (_repeatOnState == 1) {
        self.eachDayButtonLabel.text = [CVMonthlyRecurrenceSelectionViewController_iPhone daysOfTheMonthString:self.daysOfTheMonth];
        [self resizeEachDayButton];
        _weekNumberButton.alpha = 0.0f;
        self.dayOfWeekButton.alpha = 0.0f;
        self.eachDayButton.alpha = 1.0f;
    }
}

- (void)viewDidUnload 
{
    self.dayOfWeekButton = nil;
    self.eachDayButton = nil;
    self.repeatOnButton = nil;
    self.weekNumberButton = nil;
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
