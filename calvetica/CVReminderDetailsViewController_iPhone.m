//
//  CVReminderDetailsViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderDetailsViewController_iPhone.h"
#import "CVEventStore.h"
#import "CVSlideLockControl.h"



@interface CVReminderDetailsViewController_iPhone ()
@property (nonatomic, strong) CVReminderCalendarPickerViewController *calendarTableViewController;
@property (nonatomic, strong) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) IBOutlet UITextView *reminderTitleTextView;
@property (nonatomic, strong) IBOutlet UITableView *reminderCalendarTableView;
@property (nonatomic, strong) IBOutlet CVTextView *reminderNotesTextView;
@property (nonatomic, strong) IBOutlet UIView *reminderTitleBlock;
@property (nonatomic, strong) IBOutlet UIView *reminderCalendarBlock;
@property (nonatomic, strong) IBOutlet UIView *reminderPriorityBlock;
@property (nonatomic, strong) IBOutlet UIView *reminderNotesBlock;
@property (nonatomic, strong) IBOutlet UIView *reminderDoneBlock;
@property (nonatomic, strong) CVSlideLockControl *doneSlideLock;
@property (nonatomic, strong) IBOutlet UIView *reminderDeleteBlock;
@property (nonatomic, strong) CVSlideLockControl *deleteSlideLock;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) IBOutlet CVColoredDotView *priorityHighShape;
@property (nonatomic, strong) IBOutlet CVColoredDotView *priorityMediumShape;
@property (nonatomic, strong) IBOutlet CVColoredDotView *priorityLowShape;
@property (nonatomic, strong) IBOutlet UIImageView *priorityHighCheckImageView;
@property (nonatomic, strong) IBOutlet UIImageView *priorityMediumCheckImageView;
@property (nonatomic, strong) IBOutlet UIImageView *priorityLowCheckImageView;
@end




@implementation CVReminderDetailsViewController_iPhone


- (id)initWithReminder:(EKReminder *)initReminder;
{
    self = [super init];
    if (self) {
        self.reminder = initReminder;
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    _reminderTitleTextView.text = self.reminder.title;
    _reminderNotesTextView.text = self.reminder.notes;
    
    _reminderTitleTextView.inputAccessoryView = self.keyboardAccessoryView;
    
    // calendar table
    self.calendarTableViewController = [[CVReminderCalendarPickerViewController alloc] init];
    self.calendarTableViewController.delegate = self;
	self.calendarTableViewController.tableView = self.reminderCalendarTableView;
    self.reminderCalendarTableView.delegate = self.calendarTableViewController;
    self.reminderCalendarTableView.dataSource = self.calendarTableViewController;
    
    [self setPriority:self.reminder.priority];
    
    // set the shape of the priority buttons
    _priorityHighShape.shape		= CVColoredShapeTriangle;
    _priorityMediumShape.shape	= CVColoredShapeCircle;
    _priorityLowShape.shape		= CVColoredShapeRectangle;
    
    // set the color of the priority button shapes
    _priorityHighShape.color		= patentedDarkGray;
    _priorityMediumShape.color	= patentedDarkGray;
    _priorityLowShape.color		= patentedDarkGray;
    
    // done lock slider
    self.doneSlideLock = [CVSlideLockControl viewFromNib:[CVSlideLockControl nib]];
    self.doneSlideLock.frame = CGRectMake(15, 35, self.doneSlideLock.bounds.size.width, self.doneSlideLock.bounds.size.height);
    if (self.reminder.isCompleted) {
        self.doneSlideLock.titleLabel.text = @"Slide to uncomplete";
    }
    else {
        self.doneSlideLock.titleLabel.text = @"Slide to complete";
    }
    self.doneSlideLock.thumbImage = [UIImage imageNamed:@"slider"];
    [self.doneSlideLock addTarget:self action:@selector(doneSliderWasToggled:) forControlEvents:UIControlEventTouchUpInside];
    [self.reminderDoneBlock addSubview:self.doneSlideLock];
    
    // delete lock slider
    self.deleteSlideLock = [CVSlideLockControl viewFromNib:[CVSlideLockControl nib]];
    self.deleteSlideLock.frame = CGRectMake(15, 35, self.deleteSlideLock.bounds.size.width, self.deleteSlideLock.bounds.size.height);
    self.deleteSlideLock.titleLabel.text = @"Slide to delete";
    self.deleteSlideLock.thumbImage = [UIImage imageNamed:@"slider"];
    [self.deleteSlideLock addTarget:self action:@selector(deleteSliderWasToggled:) forControlEvents:UIControlEventTouchUpInside];
    [self.reminderDeleteBlock addSubview:self.deleteSlideLock];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
	[self.calendarTableViewController setSelectedCalendar:self.reminder.calendar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Methods

- (void)doneSliderWasToggled:(id)sender 
{
    [self.delegate reminderDetailsViewController:self didFinishWithResult:CVReminderDetailsResultComplete];
}

- (void)deleteSliderWasToggled:(id)sender 
{
    [self.delegate reminderDetailsViewController:self didFinishWithResult:CVReminderDetailsResultDeleted];
}

- (void)adjustLayoutOfBlocks 
{
    // rearrange detail blocks to match user preferences
    NSArray *detailsOrderingArray = [CVSettings reminderDetailsOrderingArray];
    
    // if there are no preferences set, just return
    if (!detailsOrderingArray) {
        return;
    }
    
    CGFloat currentY = 0;
    NSInteger cellHeight = 42;
    for (NSDictionary *dict in detailsOrderingArray) {
        if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Title"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _reminderTitleBlock.hidden = YES;
            }
            else {
                CGRect f = _reminderTitleBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_reminderTitleBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Calendar"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _reminderCalendarBlock.hidden = YES;
            }
            else {
                CGRect f = _reminderCalendarBlock.frame;
                f.origin.y = currentY;
                
                CGFloat calendarTableContentSize = self.calendarTableViewController.availableCalendars.count * cellHeight;
                CGSize calendarTableFrameSize = self.reminderCalendarTableView.frame.size;
                
                CGFloat heightDifference = (calendarTableContentSize - calendarTableFrameSize.height);
                f.size.height +=heightDifference;
                
                currentY += f.size.height;
                [_reminderCalendarBlock setFrame:f];
                
                self.reminderCalendarTableView.frame = CGRectMake(self.reminderCalendarTableView.frame.origin.x, self.reminderCalendarTableView.frame.origin.y, self.reminderCalendarTableView.bounds.size.width,  calendarTableContentSize);
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Priority"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _reminderPriorityBlock.hidden = YES;
            }
            else {
                CGRect f = _reminderPriorityBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_reminderPriorityBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Notes"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _reminderNotesBlock.hidden = YES;
            }
            else {
                CGRect f = _reminderNotesBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_reminderNotesBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Complete"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _reminderDoneBlock.hidden = YES;
            }
            else {
                CGRect f = _reminderDoneBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_reminderDoneBlock setFrame:f];
            }
        }
        
        else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Delete"]) {
            BOOL hide = [[dict objectForKey:@"HiddenKey"] boolValue];
            if (hide) {
                _reminderDeleteBlock.hidden = YES;
            }
            else {
                CGRect f = _reminderDeleteBlock.frame;
                f.origin.y = currentY;
                currentY += f.size.height;
                [_reminderDeleteBlock setFrame:f];
            }
        }
    }
    
    CGSize s = _contentScrollView.contentSize;
    s.height = currentY;
    _contentScrollView.contentSize = s;
}

- (void)hideKeyboard 
{
    [_reminderTitleTextView resignFirstResponder];
}

- (void)setPriority:(NSInteger)priority 
{
    
    _priorityHighCheckImageView.hidden = YES;
    _priorityMediumCheckImageView.hidden = YES;
    _priorityLowCheckImageView.hidden = YES;
    
    if (priority == CVColoredShapeTriangle) {
        _priorityHighCheckImageView.hidden = NO;
    }
    else if (priority == CVColoredShapeCircle) {
        _priorityMediumCheckImageView.hidden = NO;
    }
    else if (priority == CVColoredShapeRectangle) {
        _priorityLowCheckImageView.hidden = NO;
    }
    
    self.reminder.priority = priority;
}




#pragma mark - IBActions

- (IBAction)priorityHighButtonTapped:(id)sender 
{
    [self setPriority:CVColoredShapeTriangle];
}

- (IBAction)priorityMediumButtonTapped:(id)sender 
{
    [self setPriority:CVColoredShapeCircle];
}

- (IBAction)priorityLowButtonTapped:(id)sender 
{
    [self setPriority:CVColoredShapeRectangle];
}


#pragma mark - Scroll View Delegates

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    [self hideKeyboard];
}




#pragma mark - Text View Delegate

- (void)textViewDidEndEditing:(UITextView *)textView 
{
    if (textView == _reminderTitleTextView) {
        self.reminder.title = textView.text;
    }
}

- (void)textViewWasTappedWhenUneditable:(CVTextView *)textView 
{
    if (textView == _reminderNotesTextView) {
        CVEventDetailsNotesViewController_iPhone *notesViewController = [[CVEventDetailsNotesViewController_iPhone alloc] init];
        notesViewController.delegate = self;
        notesViewController.reminder = self.reminder;
        [self.modalNavigationController pushViewController:notesViewController animated:YES];
        [self.delegate reminderDetailsViewController:self didPushViewController:YES];  
    }
}




#pragma mark - Calendar Picker Delegate 

- (void)calendarPicker:(CVReminderCalendarPickerViewController *)calendarPicker didPickCalendar:(EKCalendar *)calendar 
{
    self.reminder.calendar = calendar;
}




#pragma mark - Notes View Controller Delegate

- (void)eventDetailsNotesViewController:(CVEventDetailsNotesViewController_iPhone *)controller didFinish:(CVEventDetailsNotesResult)result
{    
    if (result == CVEventDetailsNotesResultSaved) {
        _reminderNotesTextView.text = self.reminder.notes;
    }
}




@end
