 //
//  CVViewOptionsPopoverViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewOptionsPopoverViewController.h"
#import "geometry.h"
#import "colors.h"



@implementation CVViewOptionsPopoverViewController


- (void)setCurrentViewMode:(CVViewOptionsPopoverOption)newCurrentViewMode 
{
    _currentViewMode = newCurrentViewMode;
    
    self.fullDayButton.selected = NO;
    self.agendaDayButton.selected = NO;
    self.weekButton.selected = NO;
    
    if (_currentViewMode == CVViewOptionsPopoverOptionFullDayView) {
        self.fullDayButton.selected = YES;
    }
    
    else if (_currentViewMode == CVViewOptionsPopoverOptionAgendaView) {
        self.agendaDayButton.selected = YES;
    }
    
    else if (_currentViewMode == CVViewOptionsPopoverOptionWeekView) {
        self.weekButton.selected = YES;
    }
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (_mode == CVViewOptionsModeReminders) {
        [self.calendarsButton setTitle:@"Calendars" forState:UIControlStateNormal];
        self.searchButton.alpha = 0.3;
        self.searchButton.userInteractionEnabled = NO;
        
        self.fullDayButton.alpha = 0.3;
        self.fullDayButton.userInteractionEnabled = NO;
    }
    else if (_mode == CVViewOptionsModeEvents) {
        [self.calendarsButton setTitle:@"Calendars" forState:UIControlStateNormal];
        self.searchButton.alpha = 1.0;
        self.searchButton.userInteractionEnabled = YES;
        
        self.fullDayButton.alpha = 1.0;
        self.fullDayButton.userInteractionEnabled = YES;
    }
    
    // set up long press button on the quick add
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressOnWeekButtonGesture:)];
    [self.weekButton addGestureRecognizer:longPressGesture];
}

- (void)viewDidUnload 
{
    self.fullDayButton = nil;
    self.agendaDayButton = nil;
    self.weekButton = nil;
    self.calendarsButton = nil;
    self.searchButton = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    self.fullDayButton.backgroundColorHighlighted = patentedVeryDarkGray;
    self.fullDayButton.textColorHighlighted = patentedWhite;
    self.fullDayButton.backgroundColorSelected = patentedVeryDarkGray;
    self.fullDayButton.textColorSelected = patentedWhite;
    self.agendaDayButton.backgroundColorHighlighted = patentedVeryDarkGray;
    self.agendaDayButton.textColorHighlighted = patentedWhite;
    self.agendaDayButton.backgroundColorSelected = patentedVeryDarkGray;
    self.agendaDayButton.textColorSelected = patentedWhite;
    self.weekButton.backgroundColorHighlighted = patentedVeryDarkGray;
    self.weekButton.textColorHighlighted = patentedWhite;
    self.weekButton.backgroundColorSelected = patentedVeryDarkGray;
    self.weekButton.textColorSelected = patentedWhite;
    
    self.currentViewMode = _currentViewMode;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Methods



#pragma mark - IBActions

- (IBAction)fullDayButtonWasTapped:(id)sender 
{
    [self setCurrentViewMode:CVViewOptionsPopoverOptionFullDayView];
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionFullDayView byPressingButton:sender];
}

- (IBAction)agendaButtonWasTapped:(id)sender 
{
    [self setCurrentViewMode:CVViewOptionsPopoverOptionAgendaView];
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionAgendaView byPressingButton:sender];
}

- (IBAction)weekButtonWasTapped:(id)sender 
{
    [self setCurrentViewMode:CVViewOptionsPopoverOptionWeekView];
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionWeekView byPressingButton:sender];
}

- (IBAction)searchButtonWasTapped:(id)sender 
{
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionSearch byPressingButton:sender];
}

- (IBAction)calendarsButtonWasTapped:(id)sender 
{
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionCalendars byPressingButton:sender];
}

- (IBAction)settingsButtonWasTapped:(id)sender 
{
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionSettings byPressingButton:sender];
}

- (IBAction)handleLongPressOnWeekButtonGesture:(UILongPressGestureRecognizer *)sender 
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.delegate viewOptionsViewController:self weekButtonWasLongPressed:self.weekButton];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.delegate viewOptionsViewControllerDidRequestToClose:self];
    }
}


#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched 
{
    [self.delegate viewOptionsViewControllerDidRequestToClose:self];
}




@end
