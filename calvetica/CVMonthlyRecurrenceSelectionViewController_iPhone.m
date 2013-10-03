//
//  CVMonthlyRecurrenceSelectionViewController_iPad.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVMonthlyRecurrenceSelectionViewController_iPhone.h"


@implementation CVMonthlyRecurrenceSelectionViewController_iPhone

- (id)initWithTargetView:(UIView *)view selectedDays:(NSArray *)days 
{
    self = [self init];
    if (self) {
        _selectedDays = [NSMutableArray arrayWithArray:days];
        _targetView = view;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated 
{
    CGRect frame = _mainView.frame;
    
    frame.origin.x = _targetView.frame.origin.x;
    frame.origin.y = _targetView.frame.origin.y;

    _mainView.frame = frame;
    
    // Toggle the days that are already selected.
    NSPredicate *dayOfTheMonthPredicate = [NSPredicate predicateWithFormat:@"tag = $TAG"];
    for (NSNumber *num in _selectedDays) {
        NSPredicate *predicate = [dayOfTheMonthPredicate predicateWithSubstitutionVariables:
                                  @{@"TAG": num}];
        NSArray *foundDays = [[_keys subviews] filteredArrayUsingPredicate:predicate];
        if (foundDays.count == 1) {
            ((CVToggleButton *)[foundDays objectAtIndex:0]).selected = YES;
        }
    }
    
    _selectedDaysLabel.text = [CVMonthlyRecurrenceSelectionViewController_iPhone daysOfTheMonthString:_selectedDays];
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Methods

+ (NSString *)daysOfTheMonthString:(NSArray *)daysOfTheMonth {
    NSArray *sortedArray = [daysOfTheMonth sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *selectedDaysString = [NSMutableString string];
    for (int i = 0; i < sortedArray.count; i++) {
        NSInteger dayNum = [[sortedArray objectAtIndex:i] intValue];
        if (i == sortedArray.count - 1) {
            [selectedDaysString appendFormat:@"%i", dayNum];
        } else {
            [selectedDaysString appendFormat:@"%i, ", dayNum];
        }
    }
    return selectedDaysString;
}




#pragma mark - IBActions

- (IBAction)backgroundTapped
{
    [self.delegate monthlyRecurrenceSelectionWillClose:self];
}

- (IBAction)buttonTapped:(CVToggleButton *)button
{
    if (button.selected) {
        button.selected = NO;
        [_selectedDays removeObject:@(button.tag)];
    } else {
        button.selected = YES;
        [_selectedDays addObject:@(button.tag)];
    }

    _selectedDaysLabel.text = [CVMonthlyRecurrenceSelectionViewController_iPhone daysOfTheMonthString:_selectedDays];
    
    [_delegate monthlyRecurrenceSelection:self didUpdateSelectedDays:_selectedDays];
}




@end
