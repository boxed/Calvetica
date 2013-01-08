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


#define DEFAULT_MAX_WIDTH 100.0f
#define ITEM_ROW_HEIGHT 29.0f;


typedef enum {
    CVComboBoxResultFinished
} CVComboBoxResult;


@protocol CVComboBoxDelegate;


@interface CVComboBoxViewController : CVViewController <UITableViewDataSource, UITableViewDelegate>

#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVComboBoxDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) NSObject *selectedItem;
@property (nonatomic, readonly) NSInteger selectedItemIndex;
@property (nonatomic, strong) UIView *targetView;

#pragma mark - IBOutlets
@property (nonatomic, strong) IBOutlet UITableView *itemsTableView;
@property (nonatomic, strong) IBOutlet UIView *itemsView;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UILabel *selectedItemLabel;

#pragma mark - Methods
- (id)initWithTargetView:(UIView *)view itemsToSelect:(NSArray *)itemsToSelect selectedItemIndex:(NSInteger)selItem;

#pragma mark - IBActions
- (IBAction)backgroundTapped:(id)sender;

#pragma mark - Notifications

@end




@protocol CVComboBoxDelegate <NSObject>
@required
- (void)comboBox:(CVComboBoxViewController *)comboBox didFinishWithResult:(CVComboBoxResult)result;
@end
