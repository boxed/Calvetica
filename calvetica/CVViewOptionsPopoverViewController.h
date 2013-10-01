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
    CVViewOptionsPopoverOptionDetailedWeekView,
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
@property (nonatomic, weak) id<CVViewOptionsPopoverViewControllerDelegate> delegate;
@property (nonatomic, assign) CVViewOptionsPopoverOption currentViewMode;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, weak) IBOutlet CVRoundedToggleButton *fullDayButton;
@property (nonatomic, weak) IBOutlet CVRoundedToggleButton *agendaDayButton;
@property (nonatomic, weak) IBOutlet CVRoundedToggleButton *weekButton;
@property (weak, nonatomic) IBOutlet CVRoundedToggleButton *detailedWeekButton;
@property (nonatomic, weak) IBOutlet CVRoundedButton *calendarsButton;
@property (nonatomic, weak) IBOutlet CVRoundedButton *searchButton;
@property (nonatomic) CVViewOptionsMode mode;
@end


@protocol CVViewOptionsPopoverViewControllerDelegate <NSObject>
- (void)viewOptionsViewController:(CVViewOptionsPopoverViewController *)viewOptionsViewController
                  didSelectOption:(CVViewOptionsPopoverOption)option
                 byPressingButton:(CVRoundedToggleButton *)button;
- (void)viewOptionsViewControllerDidRequestToClose:(CVViewOptionsPopoverViewController *)viewOptionsViewController;
@end
