//
//  CVMigrateToRemindersViewController.m
//  calvetica
//
//  Created by Adam Kirk on 9/13/12.
//
//

#define MR_SHORTHAND 1

#import "CVMigrateToRemindersViewController.h"
#import "EKReminder+Calvetica.h"
#import "CTTaskStore.h"
#import "CTTask.h"




@interface CVMigrateToRemindersViewController ()
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end




@implementation CVMigrateToRemindersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 @property (nonatomic, strong) NSString  *title;
 @property (nonatomic, strong) NSNumber  *priority;
 @property (nonatomic, strong) NSDate    *due;
 @property (nonatomic, strong) NSDate    *completed;
 @property (nonatomic, strong) NSString  *notes;
 @property (nonatomic, strong) NSDate    *created;
 @property (nonatomic, strong) NSDate    *lastSynced;
 @property (nonatomic, strong) NSNumber  *syncingOperationNeeded;
 @property (nonatomic, strong) NSDate    *modified;
 @property (nonatomic, strong) NSString  *location;
 @property (nonatomic, strong) NSString  *UUID;
 @property (nonatomic, strong) NSString  *group_UUID;
*/

- (IBAction)migrateButtonWasTapped:(id)sender {
	dispatch_async([CVOperationQueue backgroundQueue], ^{
		NSArray *tasks = [CTTaskStore tasksWithPredicate:nil];
		NSUInteger total = tasks.count;
		NSUInteger i = 0;
		EKEventStore *eventStore = [CVEventStore sharedStore].eventStore;
		for (CTTask *task in tasks) {
			EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
			reminder.title			= task.title;
			reminder.priority		= [task.priority integerValue] == 2 ? 1 : 0;
			reminder.dueDate		= task.due;
			reminder.completed		= task.completed != nil;
			reminder.completionDate = task.completed;
			reminder.notes			= task.notes;
			reminder.location		= task.location;
			[eventStore saveReminder:reminder commit:NO error:nil];
			i++;
			dispatch_async(dispatch_get_main_queue(), ^{
				_progressView.progress = i / total;
			});
		}
		[eventStore commit:nil];
		dispatch_async(dispatch_get_main_queue(), ^{
			_completeLabel.hidden = NO;
		});
	});
}

@end
