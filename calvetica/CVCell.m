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
    
    [super awakeFromNib];
}

- (void)resetAccessoryButton 
{
	_cellAccessoryButton.mode = CVCellAccessoryButtonModeDefault;
}

- (void)toggleAccessoryButton 
{
    [UIView animateWithDuration:ACCESSORY_BUTTON_ANIMATE_DURATION animations:^{
        CGRect r = _cellAccessoryButton.frame;
        r.origin.x += ACCESSORY_BUTTON_ANIMATE_DISTANCE;
        [_cellAccessoryButton setFrame:r];
    }
                     completion:^(BOOL finished){
                         [_cellAccessoryButton toggleMode];
                         [UIView animateWithDuration:ACCESSORY_BUTTON_ANIMATE_DURATION animations:^{
                             CGRect r = _cellAccessoryButton.frame;
                             r.origin.x -= ACCESSORY_BUTTON_ANIMATE_DISTANCE;
                             [_cellAccessoryButton setFrame:r];                             
                         }];
                     }];
}


#pragma mark - Actions

- (IBAction)cellWasTapped:(id)sender 
{
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
