//
//  CVSearchEventCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"

NS_ASSUME_NONNULL_BEGIN


@protocol CVSearchEventCellDelegate;

@interface CVSearchEventCell : CVCell


#pragma mark - Properties
@property (nonatomic, nullable, weak  )          id<CVSearchEventCellDelegate> delegate;
@property (nonatomic, strong)          EKEvent                       *event;
@property (nonatomic, nullable, weak  ) IBOutlet UIImageView                   *tinyIcon;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel                       *foundTextLabel;


#pragma mark - Methods
- (void)setEvent:(EKEvent *)newEvent searchText:(NSString *)searchText;


@end




@protocol CVSearchEventCellDelegate <NSObject>
@optional
- (void)searchCellWasTapped:(CVSearchEventCell *)cell;
@end

NS_ASSUME_NONNULL_END