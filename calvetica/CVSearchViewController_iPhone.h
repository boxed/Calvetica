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


typedef enum {
    CVSearchViewControllerResultFinished
} CVSearchViewControllerResult;


@protocol CVSearchViewControllerDelegate;


@interface CVSearchViewController_iPhone : CVViewController <CVModalProtocol,
                                                                UITableViewDelegate,
                                                                UITableViewDataSource,
                                                                UITextFieldDelegate,
                                                                CVSearchEventCellDelegate,
                                                                CVSearchScopePopoverControllerDelegate>
@property (nonatomic, weak) id<CVSearchViewControllerDelegate> delegate;
- (void)searchForText:(NSString *)text;
@end




@protocol CVSearchViewControllerDelegate <NSObject>
- (void)searchViewController:(CVSearchViewController_iPhone *)controller didFinishWithResult:(CVSearchViewControllerResult)result;
- (void)searchViewController:(CVSearchViewController_iPhone *)controller tappedCell:(CVSearchEventCell *)cell;
@end