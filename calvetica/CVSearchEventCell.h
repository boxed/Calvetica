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
@property (nonatomic, unsafe_unretained) id<CVSearchEventCellDelegate> delegate;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) IBOutlet UIImageView *tinyIcon;
@property (nonatomic, strong) IBOutlet MTLabel *foundTextLabel;


#pragma mark - Methods
- (void)setEvent:(EKEvent *)newEvent searchText:(NSString *)searchText;


@end




@protocol CVSearchEventCellDelegate <NSObject>
@optional
- (void)searchCellWasTapped:(CVSearchEventCell *)cell;
@end