//
//  CVViewOptionsPopoverViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVRoundedToggleButton.h"
#import "CVModalProtocol.h"


typedef NS_ENUM(NSUInteger, CVViewOptionsPopoverOption) {
    CVViewOptionsPopoverOptionFullDayView,
    CVViewOptionsPopoverOptionAgendaView,
    CVViewOptionsPopoverOptionWeekView,
    CVViewOptionsPopoverOptionDetailedWeekView,
    CVViewOptionsPopoverOptionCompactWeekView,
    CVViewOptionsPopoverOptionSearch,
    CVViewOptionsPopoverOptionInbox,
    CVViewOptionsPopoverOptionSettings,
};


@protocol CVViewOptionsPopoverViewControllerDelegate;


@interface CVViewOptionsPopoverViewController : CVViewController <CVModalProtocol>
@property (nonatomic, weak  )          id<CVViewOptionsPopoverViewControllerDelegate> delegate;
@property (nonatomic, assign)          CVViewOptionsPopoverOption                     currentViewMode;
@property (nonatomic, strong)          UIView                                         *targetView;
@property (nonatomic, weak  ) IBOutlet CVRoundedToggleButton                          *fullDayButton;
@property (nonatomic, weak  ) IBOutlet CVRoundedToggleButton                          *agendaDayButton;
@property (nonatomic, weak  ) IBOutlet CVRoundedToggleButton                          *weekButton;
@property (nonatomic, weak  ) IBOutlet CVRoundedToggleButton                          *detailedWeekButton;
@property (nonatomic, weak  ) IBOutlet CVRoundedToggleButton                          *compactWeekButton;
@property (nonatomic, weak  ) IBOutlet CVRoundedButton                                *searchButton;
@property (nonatomic, weak  ) IBOutlet CVRoundedButton                                *inboxButton;
@property (nonatomic, assign)          NSInteger                                       pendingInboxCount;
@end


@protocol CVViewOptionsPopoverViewControllerDelegate <NSObject>
- (void)viewOptionsViewController:(CVViewOptionsPopoverViewController *)viewOptionsViewController
                  didSelectOption:(CVViewOptionsPopoverOption)option
                 byPressingButton:(CVRoundedToggleButton *)button;
- (void)viewOptionsViewControllerDidRequestToClose:(CVViewOptionsPopoverViewController *)viewOptionsViewController;
@end
