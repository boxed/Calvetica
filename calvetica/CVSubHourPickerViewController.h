//
//  CVSubHourPickerViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVModalProtocol.h"


typedef NS_ENUM(NSUInteger, CVSubHourPickerViewControllerResult) {
    CVSubHourPickerViewControllerResultCancelled
};


@protocol CVSubHourPickerViewControllerDelegate;


@interface CVSubHourPickerViewController : CVViewController <CVModalProtocol>
@property (nonatomic, weak  ) id<CVSubHourPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate                                    *evenHourDate;
- (id)initWithDate:(NSDate *)date;
- (IBAction)subHourButtonWasTapped:(id)sender;
@end


@protocol CVSubHourPickerViewControllerDelegate <NSObject>
- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didFinishWithResult:(CVSubHourPickerViewControllerResult)result;
- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didPickDate:(NSDate *)date;
@end
