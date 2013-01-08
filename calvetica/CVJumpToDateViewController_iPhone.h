//
//  CVJumpToDateViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDayViewController_iPhone.h"
#import "CVViewController.h"
#import "CVModalProtocol.h"


typedef enum {
    CVJumpToDateResultCancelled,
    CVJumpToDateResultDateChosen
} CVJumpToDateResult;


@protocol CVJumpToDateViewControllerDelegate;


@interface CVJumpToDateViewController_iPhone : CVViewController <CVModalProtocol>

@property (nonatomic, assign) id<CVJumpToDateViewControllerDelegate> delegate;
@property (nonatomic, strong) CVViewController<CVEventDayViewControllerProtocol> *contentViewController;
@property (nonatomic, strong) IBOutlet UIView *contentControllerContainer;
@property (nonatomic, copy) NSDate *chosenDate;

- (id)initWithContentViewController:(CVViewController *)contentViewController;

@end



@protocol CVJumpToDateViewControllerDelegate <NSObject>
@required
- (void)jumpToDateViewController:(CVJumpToDateViewController_iPhone *)controller didFinishWithResult:(CVJumpToDateResult)result;
@end