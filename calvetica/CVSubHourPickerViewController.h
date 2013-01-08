//
//  CVSubHourPickerViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVModalProtocol.h"

typedef enum {
    CVSubHourPickerViewControllerResultCancelled
} CVSubHourPickerViewControllerResult;


@protocol CVSubHourPickerViewControllerDelegate;


@interface CVSubHourPickerViewController : CVViewController <CVModalProtocol> {
}

#pragma mark - Constructor
- (id)initWithDate:(NSDate *)date;

	
#pragma mark - Public Properties
@property (nonatomic, unsafe_unretained) id<CVSubHourPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *evenHourDate;


#pragma mark - IBActions
- (IBAction)subHourButtonWasTapped:(id)sender;


@end




@protocol CVSubHourPickerViewControllerDelegate <NSObject>
@required
- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didFinishWithResult:(CVSubHourPickerViewControllerResult)result;
- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didPickDate:(NSDate *)date;
@end
