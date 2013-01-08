//
//  CVPeopleTableViewCell_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"

@protocol CVPeopleTableViewCell_iPhoneDelegate;

@interface CVPeopleTableViewCell_iPhone : UITableViewCell {
    
}

#pragma mark - IBOutlets
@property (nonatomic, unsafe_unretained) NSObject <CVPeopleTableViewCell_iPhoneDelegate> *delegate;
@property (nonatomic, strong) IBOutlet UILabel *personTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *personStatusLabel;
@property (nonatomic, strong) IBOutlet UIView *gestureHitArea;
@property (nonatomic, strong) IBOutlet UIButton *chatButton;
@property (nonatomic, strong) IBOutlet UIButton *emailButton;

#pragma mark - IBAction
- (IBAction)cellWasSwiped:(id)sender;
- (IBAction)chatButtonWasPressed:(id)sender;
- (IBAction)emailButtonWasPressed:(id)sender;

@end

@protocol CVPeopleTableViewCell_iPhoneDelegate <NSObject>
- (void)cellWasSwiped:(CVPeopleTableViewCell_iPhone *)cell;
- (void)cellChatButtonWasPressed:(id)button;
- (void)cellEmailButtonWasPressed:(id)button;
@end