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


@interface CVCalendarDetailsViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <CVCalendarDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) EKCalendar *calendar;

@end




@protocol CVCalendarDetailsViewControllerDelegate <NSObject>
@required
- (void)calendarDetailsController:(CVCalendarDetailsViewController *)controller didFinishWithResult:(CVCalendarDetailsControllerResult)result;
@end