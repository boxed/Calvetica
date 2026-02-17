//
//  CVPeopleTableViewCell_iPhone.m
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVPeopleTableViewCell.h"


@implementation CVPeopleTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(cellWasSwiped:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [_gestureHitArea addGestureRecognizer:swipeGesture];

    _personTitleLabel.textColor = calTextColor();
    _personStatusLabel.textColor = calSecondaryText();

    [_chatButton setImage:[[_chatButton imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_emailButton setImage:[[_emailButton imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _chatButton.tintColor = calSecondaryText();
    _emailButton.tintColor = calSecondaryText();
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
