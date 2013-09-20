//
//  CVJumpToDateViewController.m
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVJumpToDateViewController_iPhone.h"


@implementation CVJumpToDateViewController_iPhone


- (id)initWithContentViewController:(CVViewController<CVEventDayViewControllerProtocol> *)viewController
{
    self = [super init];
    if (self) {
        self.contentViewController = viewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [self.contentControllerContainer addSubview:_contentViewController.view];
    [super viewDidLoad];
}



#pragma mark - Actions

- (IBAction)closeButtonTapped:(id)sender 
{
    NSDate *newDate = self.contentViewController.date;
    //[self.contentViewController setDate:newDate];
    self.chosenDate = newDate;
    [self.delegate jumpToDateViewController:self didFinishWithResult:CVJumpToDateResultCancelled];
}

- (IBAction)todayButtonTapped:(id)sender 
{
    NSDate *newDate = [[NSDate date] mt_startOfCurrentDay];
    self.chosenDate = newDate;
    [self.delegate jumpToDateViewController:self didFinishWithResult:CVJumpToDateResultDateChosen];
}

- (IBAction)doneButtonTapped:(id)sender 
{
    NSDate *newDate = self.contentViewController.date;
    //[self.contentViewController setDate:newDate];
    self.chosenDate = newDate;
    [self.delegate jumpToDateViewController:self didFinishWithResult:CVJumpToDateResultDateChosen];
}




#pragma mark - Modal Backdrop

- (void)modalBackdropWasTouched
{
    [self.delegate jumpToDateViewController:self didFinishWithResult:CVJumpToDateResultCancelled];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
