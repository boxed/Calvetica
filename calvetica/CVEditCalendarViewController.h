//
//  CVCalendarDetailsViewController.h
//  calvetica
//
//  Created by James Schultz on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef enum {
    CVCalendarDetailsControllerResultSaved,
    CVCalendarDetailsControllerResultCancelled
} CVCalendarDetailsControllerResult;


@protocol CVCalendarDetailsViewControllerDelegate;


@interface CVEditCalendarViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic, weak  ) id <CVCalendarDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) EKCalendar                                   *calendar;
@end


@protocol CVCalendarDetailsViewControllerDelegate <NSObject>
- (void)calendarDetailsController:(CVEditCalendarViewController *)controller
              didFinishWithResult:(CVCalendarDetailsControllerResult)result;
@end