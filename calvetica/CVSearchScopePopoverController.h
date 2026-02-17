//
//  CVSearchSettingsViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVRoundedToggleButton.h"
#import "CVModalProtocol.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, CVSearchScopePopoverOption) {
    CVSearchScopePopoverOption3Months,
	CVSearchScopePopoverOption6Months,
	CVSearchScopePopoverOption1Year,
	CVSearchScopePopoverOption5Years,
	CVSearchScopePopoverOptionEverything
};


@protocol CVSearchScopePopoverControllerDelegate;


@interface CVSearchScopePopoverController : CVViewController <CVModalProtocol>

@property (nonatomic, nullable, weak  )          id<CVSearchScopePopoverControllerDelegate> delegate;
@property (nonatomic, assign)          CVSearchScopePopoverOption                 currentScope;
@property (nonatomic, strong)          UIView                                     *targetView;
@property (nonatomic, nullable, weak  ) IBOutlet CVRoundedToggleButton                      *threeMonthsButton;
@property (nonatomic, nullable, weak  ) IBOutlet CVRoundedToggleButton                      *sixMonthsButton;
@property (nonatomic, nullable, weak  ) IBOutlet CVRoundedToggleButton                      *oneYearButton;
@property (nonatomic, nullable, weak  ) IBOutlet CVRoundedToggleButton                      *fiveYearButton;
@property (nonatomic, nullable, weak  ) IBOutlet CVRoundedToggleButton                      *everythingButton;

- (IBAction)threeMonthButtonWasTapped:(id)sender;
- (IBAction)sixMonthButtonWasTapped:(id)sender;
- (IBAction)oneYearButtonWasTapped:(id)sender;
- (IBAction)fiveYearButtonWasTapped:(id)sender;
- (IBAction)everythingButtonWasTapped:(id)sender;

@end




@protocol CVSearchScopePopoverControllerDelegate <NSObject>
@required
- (void)searchScopeController:(CVSearchScopePopoverController *)controller didSelectOption:(CVSearchScopePopoverOption)option;
- (void)searchScopeControllerDidRequestToClose:(CVSearchScopePopoverController *)controller;
@end

NS_ASSUME_NONNULL_END
