//
//  CVCalendarDetailsViewController.h
//  calvetica
//
//  Created by James Schultz on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CVCalendarDetailsControllerResult) {
    CVCalendarDetailsControllerResultSaved,
    CVCalendarDetailsControllerResultCancelled
};



NS_ASSUME_NONNULL_BEGIN

@protocol CVCalendarDetailsViewControllerDelegate;


@interface CVEditCalendarViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic, nullable, weak  ) id <CVCalendarDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) EKCalendar                                   *calendar;
@end


@protocol CVCalendarDetailsViewControllerDelegate <NSObject>
- (void)calendarDetailsController:(CVEditCalendarViewController *)controller
              didFinishWithResult:(CVCalendarDetailsControllerResult)result;
@end

NS_ASSUME_NONNULL_END