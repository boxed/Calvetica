//
//  CVSubHourPickerViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVModalProtocol.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, CVSubHourPickerViewControllerResult) {
    CVSubHourPickerViewControllerResultCancelled
};


@protocol CVSubHourPickerViewControllerDelegate;


@interface CVSubHourPickerViewController : CVViewController <CVModalProtocol>
@property (nonatomic, nullable, weak  ) id<CVSubHourPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate                                    *evenHourDate;
- (instancetype)initWithDate:(NSDate *)date;
- (IBAction)subHourButtonWasTapped:(id)sender;
@end


@protocol CVSubHourPickerViewControllerDelegate <NSObject>
- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didFinishWithResult:(CVSubHourPickerViewControllerResult)result;
- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didPickDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
