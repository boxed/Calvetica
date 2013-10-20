//
//  CVCell.h
//  calvetica
//
//  Created by Adam Kirk on 5/31/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCellAccessoryButton.h"
#import "CVColoredDotView.h"
#import "animations.h"
#import "UITableViewCell+Nibs.h"


@interface CVCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *redSubtitleLabel;
@property (nonatomic, weak) IBOutlet CVCellAccessoryButton *cellAccessoryButton;
@property (nonatomic, weak) IBOutlet CVColoredDotView *coloredDotView;
@property (nonatomic, weak) IBOutlet UIView *gestureHitArea;
@property (nonatomic, assign) BOOL isEmpty;

- (void)resetAccessoryButton;
- (void)toggleAccessoryButton;

#pragma mark - Actions
- (IBAction)cellWasTapped:(id)sender;
- (IBAction)cellWasLongPressed:(id)sender;
- (IBAction)cellWasSwiped:(id)sender;
- (IBAction)accessoryButtonWasTapped:(id)sender;

@end
