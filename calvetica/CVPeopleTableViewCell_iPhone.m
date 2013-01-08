//
//  CVPeopleTableViewCell_iPhone.m
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVPeopleTableViewCell_iPhone.h"


@implementation CVPeopleTableViewCell_iPhone

- (void)awakeFromNib 
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(cellWasSwiped:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [_gestureHitArea addGestureRecognizer:swipeGesture];

    [super awakeFromNib];
}

- (IBAction)cellWasSwiped:(id)sender 
{
    [_delegate cellWasSwiped:self];
}

- (IBAction)chatButtonWasPressed:(id)sender 
{
    [_delegate cellChatButtonWasPressed:sender];
}

- (IBAction)emailButtonWasPressed:(id)sender 
{
    [_delegate cellEmailButtonWasPressed:sender];
}

@end
