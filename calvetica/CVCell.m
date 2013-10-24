//
//  CVCell.m
//  calvetica
//
//  Created by Adam Kirk on 5/31/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"




@implementation CVCell

- (void)awakeFromNib 
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(cellWasTapped:)];
    [self.gestureHitArea addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *cellLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self  action:@selector(cellWasLongPressed:)];
    [self.gestureHitArea addGestureRecognizer:cellLongPressGesture];

    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(cellWasSwiped:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeftGesture];
	
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(cellWasSwiped:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRightGesture];
    
    _titleLabel.text = @"";
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    self.selectionStyle = UITableViewCellSelectionStyleGray;

    [super awakeFromNib];
}

- (void)resetAccessoryButton 
{
	_cellAccessoryButton.mode = CVCellAccessoryButtonModeDefault;
}

- (void)toggleAccessoryButton 
{
    [UIView mt_animateViews:@[_cellAccessoryButton]
                   duration:0.20
             timingFunction:kMTEaseInBack
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^
    {
        _cellAccessoryButton.x += _cellAccessoryButton.width;
    } completion:^{
        [_cellAccessoryButton toggleMode];
        [UIView mt_animateViews:@[_cellAccessoryButton]
                       duration:0.20
                 timingFunction:kMTEaseOutBack
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
        {
            _cellAccessoryButton.x -= _cellAccessoryButton.width;
        } completion:^{
        }];
    }];
}


#pragma mark - Actions

- (IBAction)cellWasTapped:(id)sender 
{
    [UIView mt_animateViews:@[self]
                   duration:0.15
             timingFunction:kMTEaseOutBack animations:^
    {
        self.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
    } completion:^{
        [UIView mt_animateViews:@[self]
                       duration:0.15
                 timingFunction:kMTEaseOutBack
                     animations:^
        {
            self.layer.transform = CATransform3DIdentity;
        } completion:^{
            self.layer.transform = CATransform3DIdentity;
        }];
    }];
}

- (IBAction)cellWasLongPressed:(id)sender 
{
    
}

- (IBAction)cellWasSwiped:(id)sender 
{
}

- (IBAction)accessoryButtonWasTapped:(id)sender 
{
}


@end
