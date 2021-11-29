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
	
	self.threeMonthsButton.backgroundColorHighlighted = patentedVeryDarkGray();
    self.threeMonthsButton.textColorHighlighted = patentedWhite();
    self.threeMonthsButton.backgroundColorSelected = patentedVeryDarkGray();
    self.threeMonthsButton.textColorSelected = patentedWhite();
    self.sixMonthsButton.backgroundColorHighlighted = patentedVeryDarkGray();
    self.sixMonthsButton.textColorHighlighted = patentedWhite();
    self.sixMonthsButton.backgroundColorSelected = patentedVeryDarkGray();
    self.sixMonthsButton.textColorSelected = patentedWhite();
    self.oneYearButton.backgroundColorHighlighted = patentedVeryDarkGray();
    self.oneYearButton.textColorHighlighted = patentedWhite();
    self.oneYearButton.backgroundColorSelected = patentedVeryDarkGray();
    self.oneYearButton.textColorSelected = patentedWhite();
    self.fiveYearButton.backgroundColorHighlighted = patentedVeryDarkGray();
    self.fiveYearButton.textColorHighlighted = patentedWhite();
    self.fiveYearButton.backgroundColorSelected = patentedVeryDarkGray();
    self.fiveYearButton.textColorSelected = patentedWhite();
    self.everythingButton.backgroundColorHighlighted = patentedVeryDarkGray();
    self.everythingButton.textColorHighlighted = patentedWhite();
    self.everythingButton.backgroundColorSelected = patentedVeryDarkGray();
    self.everythingButton.textColorSelected = patentedWhite();	
    
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
