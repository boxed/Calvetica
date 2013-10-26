//
//  CVJumpToDateViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDayViewController.h"
#import "CVViewController.h"
#import "CVModalProtocol.h"


typedef NS_ENUM(NSUInteger, CVJumpToDateResult) {
    CVJumpToDateResultCancelled,
    CVJumpToDateResultDateChosen
};


@protocol CVJumpToDateViewControllerDelegate;


@interface CVJumpToDateViewController : CVViewController <CVModalProtocol>

@property (nonatomic, weak  )          id<CVJumpToDateViewControllerDelegate>             delegate;
@property (nonatomic, strong)          CVViewController<CVEventDayViewControllerProtocol> *contentViewController;
@property (nonatomic, weak  ) IBOutlet UIView                                             *contentControllerContainer;
@property (nonatomic, strong)          NSDate                                             *chosenDate;

- (id)initWithContentViewController:(CVViewController *)contentViewController;

@end



@protocol CVJumpToDateViewControllerDelegate <NSObject>
- (void)jumpToDateViewController:(CVJumpToDateViewController *)controller didFinishWithResult:(CVJumpToDateResult)result;
@end