//
//  CVSearchEventCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"
#import "EKEvent+Utilities.h"
#import "MTLabel.h"

@protocol CVSearchEventCellDelegate;

@interface CVSearchEventCell : CVCell


#pragma mark - Properties
@property (nonatomic, weak  )          id<CVSearchEventCellDelegate> delegate;
@property (nonatomic, strong)          EKEvent                       *event;
@property (nonatomic, weak  ) IBOutlet UIImageView                   *tinyIcon;
@property (nonatomic, weak  ) IBOutlet MTLabel                       *foundTextLabel;


#pragma mark - Methods
- (void)setEvent:(EKEvent *)newEvent searchText:(NSString *)searchText;


@end




@protocol CVSearchEventCellDelegate <NSObject>
@optional
- (void)searchCellWasTapped:(CVSearchEventCell *)cell;
@end