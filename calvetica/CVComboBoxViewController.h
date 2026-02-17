//
//  CVComboBox.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "colors.h"
#import "CVAutoResizableLabel.h"
#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN



#define DEFAULT_MAX_WIDTH 100.0f
#define ITEM_ROW_HEIGHT 29.0f;


typedef NS_ENUM(NSUInteger, CVComboBoxResult) {
    CVComboBoxResultFinished
};


@protocol CVComboBoxDelegate;


@interface CVComboBoxViewController : CVViewController <UITableViewDataSource, UITableViewDelegate>

#pragma mark - Properties
@property (nonatomic, nullable, weak            ) id<CVComboBoxDelegate> delegate;
@property (nonatomic, copy            ) NSArray                *items;
@property (nonatomic, assign          ) CGFloat                maxWidth;
@property (nonatomic, strong          ) NSObject               *selectedItem;
@property (nonatomic,         readonly) NSInteger              selectedItemIndex;
@property (nonatomic, strong          ) UIView                 *targetView;

#pragma mark - IBOutlets
@property (nonatomic, nullable, weak) IBOutlet UITableView *itemsTableView;
@property (nonatomic, nullable, weak) IBOutlet UIView      *itemsView;
@property (nonatomic, nullable, weak) IBOutlet UIView      *mainView;
@property (nonatomic, nullable, weak) IBOutlet UILabel     *selectedItemLabel;

#pragma mark - Methods
- (instancetype)initWithTargetView:(UIView *)view itemsToSelect:(NSArray *)itemsToSelect selectedItemIndex:(NSInteger)selItem;

#pragma mark - IBActions
- (IBAction)backgroundTapped:(id)sender;

#pragma mark - Notifications

@end




@protocol CVComboBoxDelegate <NSObject>
@required
- (void)comboBox:(CVComboBoxViewController *)comboBox didFinishWithResult:(CVComboBoxResult)result;
@end

NS_ASSUME_NONNULL_END
