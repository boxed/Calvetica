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

NS_ASSUME_NONNULL_BEGIN



@interface CVCell : UITableViewCell

@property (nonatomic, nullable, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, nullable, strong) IBOutlet UILabel *redSubtitleLabel;
@property (nonatomic, nullable, strong) IBOutlet CVCellAccessoryButton *cellAccessoryButton;
@property (nonatomic, nullable, strong) IBOutlet CVColoredDotView *coloredDotView;
@property (nonatomic, nullable, strong) IBOutlet UIView *gestureHitArea;
@property (nonatomic, assign) BOOL isEmpty;

- (void)setupGestures;
- (void)resetAccessoryButton;
- (void)toggleAccessoryButton;

#pragma mark - Actions
- (IBAction)cellWasTapped:(id)sender;
- (IBAction)cellWasLongPressed:(id)sender;
- (IBAction)cellWasSwiped:(id)sender;
- (IBAction)accessoryButtonWasTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
