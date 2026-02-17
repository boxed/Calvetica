//
//  CVPeopleTableViewCell_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"

NS_ASSUME_NONNULL_BEGIN



@protocol CVPeopleTableViewCellDelegate;


@interface CVPeopleTableViewCell : UITableViewCell
@property (nonatomic, nullable, weak)          id <CVPeopleTableViewCellDelegate> delegate;
@property (nonatomic, nullable, weak) IBOutlet UILabel                            *personTitleLabel;
@property (nonatomic, nullable, weak) IBOutlet UILabel                            *personStatusLabel;
@property (nonatomic, nullable, weak) IBOutlet UIView                             *gestureHitArea;
@property (nonatomic, nullable, weak) IBOutlet UIButton                           *chatButton;
@property (nonatomic, nullable, weak) IBOutlet UIButton                           *emailButton;
@end


@protocol CVPeopleTableViewCellDelegate <NSObject>
- (void)cellWasSwiped:(CVPeopleTableViewCell *)cell;
- (void)cellChatButtonWasPressed:(id)button;
- (void)cellEmailButtonWasPressed:(id)button;
@end

NS_ASSUME_NONNULL_END