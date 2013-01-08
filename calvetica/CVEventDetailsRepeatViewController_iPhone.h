//
//  CVEventDetailsRepeatViewController_iPhone.h
//  calvetica
//
//  Created by Quenton Jones on 5/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVNumericKeyPadViewController_iPhone.h"
#import "CVMultiToggleButton.h"
#import "CVSelectionTableViewCell_iPhone.h"
#import "CVViewController.h"
#import "strings.h"






typedef enum {
    CVEventDetailsRepeatResultDone,
    CVEventDetailsRepeatResultSaved,
    CVEventDetailsRepeatResultCancelled
} CVEventDetailsRepeatResult;




@protocol CVEventDetailsRecurrenceDelegate;




@interface CVEventDetailsRepeatViewController_iPhone : CVViewController <CVNumericKeyPadDelegate>

@property (nonatomic) NSInteger endType;
@property (nonatomic) NSInteger selectedDay;
@property (nonatomic) NSInteger selectedMonth;
@property (nonatomic) NSInteger selectedYear;


#pragma mark - Constructor

// Initializes the view controller with the given start date and recurrence rule.
- (id)initWithStartDate:(NSDate *)date recurrenceRule:(EKRecurrenceRule *)rule;


#pragma mark - Properties
@property (nonatomic, unsafe_unretained) NSObject<CVEventDetailsRecurrenceDelegate> *delegate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) EKRecurrenceRule *initialRecurrenceRule;
@property (nonatomic, strong) NSArray *daySymbols;
@property (nonatomic, strong) NSArray *monthSymbols;
@property (nonatomic, readonly) NSInteger yearCount;


#pragma mark IBOutlets
@property (nonatomic, strong) IBOutlet UITableView *dateDay;
@property (nonatomic, strong) IBOutlet UITableView *dateMonth;
@property (nonatomic, strong) IBOutlet UITableView *dateYear;
@property (nonatomic, strong) IBOutlet UIView *dateView;
@property (nonatomic, strong) IBOutlet UILabel *endAfterLabel;
@property (nonatomic, strong) IBOutlet UIView *endAfterView;
@property (nonatomic, strong) IBOutlet CVMultiToggleButton *endTypeButton;
@property (nonatomic, strong) IBOutlet UILabel *repeatTimesLabel;
@property (nonatomic, strong) IBOutlet CVViewButton *frequencyButton;
@property (nonatomic, strong) IBOutlet CVViewButton *endCountButton;


#pragma mark - Methods

// Returns the number of days in the day table view.
- (int)dayCount;

// Returns the day of the month for the given index path.
- (int)dayForIndexPath:(NSIndexPath *)indexPath;

// Returns the end type button's title for the given index.
+ (NSString *)endTypeButtonTitleForIndex:(int)index;

// Determines the index path for the given day.
- (NSIndexPath *)indexPathForDay:(int)day;

// Determines the index path for the given month.
- (NSIndexPath *)indexPathForMonth:(int)month;

// Determines the index path for the given year.
- (NSIndexPath *)indexPathForYear:(int)year;

// Returns the number of months in the month table view.
- (int)monthCount;

// Returns the month of the year for the given index path.
- (int)monthForIndexPath:(NSIndexPath *)indexPath;

// Gets the new recurrence rule.
- (EKRecurrenceRule *)recurrenceRule;

// Updates the currently selected row in the days table view.
- (void)updateSelectedDayWithAnimation:(BOOL)animate;

// Updates the currently selected row in the months table view.
- (void)updateSelectedMonthWithAnimation:(BOOL)animate;

// Updates the currently selected row in the years table view.
- (void)updateSelectedYearWithAnimation:(BOOL)animate;

// Determines the year to display for the given index path.
- (int)yearForIndexPath:(NSIndexPath *)indexPath;


#pragma mark IBActions

// Called when the end after value button is pressed. Should open a numeric keypad.
- (IBAction)endAfterValueButtonPressed;

// Called when end type button is pressed. Should toggle between the three types.
- (IBAction)endTypeButtonPressed:(CVMultiToggleButton *)button;

// Called when the repeat value button is pressed. Should open a numeric keypad.
- (IBAction)repeatValueButtonPressed;


@end




@protocol CVEventDetailsRecurrenceDelegate <NSObject>

// Called when the recurrence rule is modified.
- (void)recurrenceDialog:(CVEventDetailsRepeatViewController_iPhone *)dialog updatedRecurrence:(EKRecurrenceRule *)recurrenceRule;
- (void)eventDetailsRepeatViewController:(CVEventDetailsRepeatViewController_iPhone *)controller didFinish:(CVEventDetailsRepeatResult)result;

@end
