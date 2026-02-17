//
//  CVSubHourPickerViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVSubHourPickerViewController.h"
#import "geometry.h"
#import "viewtagoffsets.h"



@implementation CVSubHourPickerViewController

- (instancetype)initWithDate:(NSDate *)date 
{
    self = [super init];
    if (self) {
        self.evenHourDate = date;
    }
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)modalBackdropWasTouched 
{
    [self.delegate subHourPicker:self didFinishWithResult:CVSubHourPickerViewControllerResultCancelled];
}

- (IBAction)subHourButtonWasTapped:(id)sender 
{
    UIView *button = (UIView *)sender;
    NSInteger minutes = button.tag - SUB_HOUR_PICKER_OFFSET;
    [self.delegate subHourPicker:self didPickDate:[self.evenHourDate mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:minutes seconds:0]];
}





@end
