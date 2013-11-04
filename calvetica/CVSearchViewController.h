//
//  CVSearchViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "CVTextField.h"
#import "CVSearchEventCell.h"
#import "CVSearchScopePopoverController.h"
#import "CVViewController.h"
#import "CVModalProtocol.h"


typedef NS_ENUM(NSUInteger, CVSearchViewControllerResult) {
    CVSearchViewControllerResultFinished
};


@protocol CVSearchViewControllerDelegate;


@interface CVSearchViewController : CVViewController <CVModalProtocol,
                                                                UITableViewDelegate,
                                                                UITableViewDataSource,
                                                                UITextFieldDelegate,
                                                                CVSearchEventCellDelegate,
                                                                CVSearchScopePopoverControllerDelegate>
@property (nonatomic, weak) id<CVSearchViewControllerDelegate> delegate;
- (void)searchForText:(NSString *)text;
@end




@protocol CVSearchViewControllerDelegate <NSObject>
- (void)searchViewController:(CVSearchViewController *)controller didFinishWithResult:(CVSearchViewControllerResult)result;
- (void)searchViewController:(CVSearchViewController *)controller tappedCell:(CVSearchEventCell *)cell;
@end