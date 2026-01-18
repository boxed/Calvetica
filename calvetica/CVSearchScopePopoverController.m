//
//  CVSearchSettingsViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVSearchScopePopoverController.h"
#import "colors.h"




@implementation CVSearchScopePopoverController

- (void)setCurrentScope:(CVSearchScopePopoverOption)newCurrentScope 
{
	_currentScope = newCurrentScope;
	
	self.threeMonthsButton.selected = NO;
	self.sixMonthsButton.selected = NO;
	self.oneYearButton.selected = NO;
	self.fiveYearButton.selected = NO;
	self.everythingButton.selected = NO;
	
	if (_currentScope == CVSearchScopePopoverOption3Months) {
		self.threeMonthsButton.selected = YES;
	}
	
	else if (_currentScope == CVSearchScopePopoverOption6Months) {
		self.sixMonthsButton.selected = YES;
	}
	
	else if (_currentScope == CVSearchScopePopoverOption1Year) {
		self.oneYearButton.selected = YES;
	}
	
	else if (_currentScope == CVSearchScopePopoverOption5Years) {
		self.fiveYearButton.selected = YES;
	}
	
	else if (_currentScope == CVSearchScopePopoverOptionEverything) {
		self.everythingButton.selected = YES;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Configure buttons for dark mode support
    NSArray *buttons = @[self.threeMonthsButton, self.sixMonthsButton, self.oneYearButton,
                         self.fiveYearButton, self.everythingButton];

    for (CVRoundedToggleButton *button in buttons) {
        // Normal state - use system colors
        button.backgroundColorNormal = UIColor.secondarySystemBackgroundColor;
        button.textColorNormal = UIColor.labelColor;

        // Highlighted/selected state
        button.backgroundColorHighlighted = UIColor.systemGrayColor;
        button.textColorHighlighted = UIColor.labelColor;
        button.backgroundColorSelected = UIColor.systemGrayColor;
        button.textColorSelected = UIColor.labelColor;

        // Also set UIButton's title colors for all states
        [button setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        [button setTitleColor:UIColor.labelColor forState:UIControlStateHighlighted];
        [button setTitleColor:UIColor.labelColor forState:UIControlStateSelected];
    }

    self.currentScope = _currentScope;
}



- (IBAction)threeMonthButtonWasTapped:(id)sender 
{
	[self.delegate searchScopeController:self didSelectOption:CVSearchScopePopoverOption3Months];
}

- (IBAction)sixMonthButtonWasTapped:(id)sender 
{
	[self.delegate searchScopeController:self didSelectOption:CVSearchScopePopoverOption6Months];
}

- (IBAction)oneYearButtonWasTapped:(id)sender 
{
	[self.delegate searchScopeController:self didSelectOption:CVSearchScopePopoverOption1Year];
}

- (IBAction)fiveYearButtonWasTapped:(id)sender 
{
	[self.delegate searchScopeController:self didSelectOption:CVSearchScopePopoverOption5Years];
}

- (IBAction)everythingButtonWasTapped:(id)sender 
{
	[self.delegate searchScopeController:self didSelectOption:CVSearchScopePopoverOptionEverything];
}




#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched 
{
    [self.delegate searchScopeControllerDidRequestToClose:self];
}





@end
