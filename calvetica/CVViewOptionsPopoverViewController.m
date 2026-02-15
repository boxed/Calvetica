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
    
    self.fullDayButton.selected         = NO;
    self.agendaDayButton.selected       = NO;
    self.weekButton.selected            = NO;
    self.detailedWeekButton.selected    = NO;
    self.compactWeekButton.selected     = NO;

    if (_currentViewMode == CVViewOptionsPopoverOptionFullDayView) {
        self.fullDayButton.selected = YES;
    }

    else if (_currentViewMode == CVViewOptionsPopoverOptionAgendaView) {
        self.agendaDayButton.selected = YES;
    }

    else if (_currentViewMode == CVViewOptionsPopoverOptionWeekView) {
        self.weekButton.selected = YES;
    }

    else if (_currentViewMode == CVViewOptionsPopoverOptionDetailedWeekView) {
        self.detailedWeekButton.selected = YES;
    }

    else if (_currentViewMode == CVViewOptionsPopoverOptionCompactWeekView) {
        self.compactWeekButton.selected = YES;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchButton.alpha = 1.0;
    self.searchButton.userInteractionEnabled = YES;

    self.fullDayButton.alpha = 1.0;
    self.fullDayButton.userInteractionEnabled = YES;

    if (self.pendingInboxCount > 0) {
        CGFloat badgeSize = 8;
        CGRect btnFrame = self.inboxButton.frame;
        CGRect badgeFrame = CGRectMake(CGRectGetMaxX(btnFrame) - badgeSize - 6,
                                       btnFrame.origin.y + (btnFrame.size.height - badgeSize) / 2,
                                       badgeSize, badgeSize);
        UIView *badge = [[UIView alloc] initWithFrame:badgeFrame];
        badge.backgroundColor = [UIColor systemRedColor];
        badge.layer.cornerRadius = badgeSize / 2;
        badge.userInteractionEnabled = NO;
        [self.inboxButton.superview addSubview:badge];
    }
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    self.fullDayButton.backgroundColorHighlighted   = calDimmedText();
    self.fullDayButton.textColorHighlighted         = calBackgroundColor();
    self.fullDayButton.backgroundColorSelected      = calDimmedText();
    self.fullDayButton.textColorSelected            = calBackgroundColor();
    self.agendaDayButton.backgroundColorHighlighted = calDimmedText();
    self.agendaDayButton.textColorHighlighted       = calBackgroundColor();
    self.agendaDayButton.backgroundColorSelected    = calDimmedText();
    self.agendaDayButton.textColorSelected          = calBackgroundColor();
    self.weekButton.backgroundColorHighlighted      = calDimmedText();
    self.weekButton.textColorHighlighted            = calBackgroundColor();
    self.weekButton.backgroundColorSelected         = calDimmedText();
    self.weekButton.textColorSelected               = calBackgroundColor();
    self.detailedWeekButton.backgroundColorHighlighted      = calDimmedText();
    self.detailedWeekButton.textColorHighlighted            = calBackgroundColor();
    self.detailedWeekButton.backgroundColorSelected         = calDimmedText();
    self.detailedWeekButton.textColorSelected               = calBackgroundColor();
    self.compactWeekButton.backgroundColorHighlighted       = calDimmedText();
    self.compactWeekButton.textColorHighlighted             = calBackgroundColor();
    self.compactWeekButton.backgroundColorSelected          = calDimmedText();
    self.compactWeekButton.textColorSelected                = calBackgroundColor();

    self.currentViewMode = _currentViewMode;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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

- (IBAction)detailedWeekButtonWasTapped:(id)sender
{
    [self setCurrentViewMode:CVViewOptionsPopoverOptionDetailedWeekView];
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionDetailedWeekView byPressingButton:sender];
}

- (IBAction)compactWeekButtonWasTapped:(id)sender
{
    [self setCurrentViewMode:CVViewOptionsPopoverOptionCompactWeekView];
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionCompactWeekView byPressingButton:sender];
}

- (IBAction)searchButtonWasTapped:(id)sender 
{
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionSearch byPressingButton:sender];
}

- (IBAction)inboxButtonWasTapped:(id)sender
{
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionInbox byPressingButton:sender];
}

- (IBAction)settingsButtonWasTapped:(id)sender
{
    [self.delegate viewOptionsViewController:self didSelectOption:CVViewOptionsPopoverOptionSettings byPressingButton:sender];
}




#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched 
{
    [self.delegate viewOptionsViewControllerDidRequestToClose:self];
}




@end
