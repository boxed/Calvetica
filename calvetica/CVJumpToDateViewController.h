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

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, CVJumpToDateResult) {
    CVJumpToDateResultCancelled,
    CVJumpToDateResultDateChosen
};


@protocol CVJumpToDateViewControllerDelegate;


@interface CVJumpToDateViewController : CVViewController <CVModalProtocol>

@property (nonatomic, nullable, weak  )          id<CVJumpToDateViewControllerDelegate>             delegate;
@property (nonatomic, strong)          CVViewController<CVEventDayViewControllerProtocol> *contentViewController;
@property (nonatomic, nullable, weak  ) IBOutlet UIView                                             *contentControllerContainer;
@property (nonatomic, strong)          NSDate                                             *chosenDate;

- (instancetype)initWithContentViewController:(CVViewController *)contentViewController;

@end



@protocol CVJumpToDateViewControllerDelegate <NSObject>
- (void)jumpToDateViewController:(CVJumpToDateViewController *)controller didFinishWithResult:(CVJumpToDateResult)result;
@end

NS_ASSUME_NONNULL_END