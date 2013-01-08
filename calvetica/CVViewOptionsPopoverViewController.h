//
//  CVViewOptionsPopoverViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVRoundedToggleButton.h"
#import "CVModalProtocol.h"


typedef enum {
    CVViewOptionsPopoverOptionFullDayView,
    CVViewOptionsPopoverOptionAgendaView,
    CVViewOptionsPopoverOptionWeekView,
    CVViewOptionsPopoverOptionSearch,
    CVViewOptionsPopoverOptionCalendars,
    CVViewOptionsPopoverOptionSettings,
} CVViewOptionsPopoverOption;

typedef enum {
    CVViewOptionsModeEvents,
    CVViewOptionsModeReminders
} CVViewOptionsMode;

@protocol CVViewOptionsPopoverViewControllerDelegate;


@interface CVViewOptionsPopoverViewController : CVViewController <CVModalProtocol>


#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVViewOptionsPopoverViewControllerDelegate> delegate;
@property (nonatomic, assign) CVViewOptionsPopoverOption currentViewMode;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) IBOutlet CVRoundedToggleButton *fullDayButton;
@property (nonatomic, strong) IBOutlet CVRoundedToggleButton *agendaDayButton;
@property (nonatomic, strong) IBOutlet CVRoundedToggleButton *weekButton;
@property (nonatomic, strong) IBOutlet CVRoundedButton *calendarsButton;
@property (nonatomic, strong) IBOutlet CVRoundedButton *searchButton;
@property (nonatomic) CVViewOptionsMode mode;


#pragma mark - Methods


#pragma mark - IBActions
- (IBAction)fullDayButtonWasTapped:(id)sender;
- (IBAction)agendaButtonWasTapped:(id)sender;
- (IBAction)weekButtonWasTapped:(id)sender;
- (IBAction)searchButtonWasTapped:(id)sender;
- (IBAction)calendarsButtonWasTapped:(id)sender;
- (IBAction)settingsButtonWasTapped:(id)sender;

- (IBAction)handleLongPressOnWeekButtonGesture:(UILongPressGestureRecognizer *)sender;


@end




@protocol CVViewOptionsPopoverViewControllerDelegate <NSObject>
@required
- (void)viewOptionsViewController:(CVViewOptionsPopoverViewController *)viewOptionsViewController didSelectOption:(CVViewOptionsPopoverOption)option byPressingButton:(CVRoundedToggleButton *)button;
- (void)viewOptionsViewControllerDidRequestToClose:(CVViewOptionsPopoverViewController *)viewOptionsViewController;

//@james
- (void)viewOptionsViewController:(CVViewOptionsPopoverViewController *)viewOptionsViewController weekButtonWasLongPressed:(CVRoundedToggleButton *)button;
@end
