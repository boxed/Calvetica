//
//  CVPeopleTableViewCell_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"


@protocol CVPeopleTableViewCellDelegate;


@interface CVPeopleTableViewCell : UITableViewCell
@property (nonatomic, weak)          id <CVPeopleTableViewCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel                            *personTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel                            *personStatusLabel;
@property (nonatomic, weak) IBOutlet UIView                             *gestureHitArea;
@property (nonatomic, weak) IBOutlet UIButton                           *chatButton;
@property (nonatomic, weak) IBOutlet UIButton                           *emailButton;
@end


@protocol CVPeopleTableViewCellDelegate <NSObject>
- (void)cellWasSwiped:(CVPeopleTableViewCell *)cell;
- (void)cellChatButtonWasPressed:(id)button;
- (void)cellEmailButtonWasPressed:(id)button;
@end