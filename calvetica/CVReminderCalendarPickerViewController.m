//
//  CVReminderCalendarPickerViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderCalendarPickerViewController.h"
#import "EKCalendar+Utilities.h"
#import "CVEventStore.h"


@interface CVReminderCalendarPickerViewController()
@property (nonatomic, strong) UINib *calendarCellNib;
@end




@implementation CVReminderCalendarPickerViewController


#pragma mark - Constructor

- (id)initWithStyle:(UITableViewStyle)style 
{
    self = [super initWithStyle:style];
    if (self) {
        self.availableCalendars = [CVSettings selectedReminderCalendars];
    }
    return self;
}

- (UINib *)calendarCellNib 
{
    if (_calendarCellNib == nil) {
        self.calendarCellNib = [CVCalendarTableViewCell_iPhone nib];
    }
    return _calendarCellNib;    
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    dispatch_async([CVOperationQueue backgroundQueue], ^{
        self.availableCalendars = [CVEventStore reminderCalendars];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Private Methods

- (void)setSelectedCalendar:(EKCalendar *)calendar 
{
	for (EKCalendar *g in self.availableCalendars) {
		if ([g.calendarIdentifier isEqualToString:calendar.calendarIdentifier]) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.availableCalendars indexOfObject:calendar] inSection:0];
            if (self.tableView.scrollEnabled) {
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            }
            else {
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
			return;
		}
	}
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.availableCalendars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVCalendarTableViewCell_iPhone *cell = [CVCalendarTableViewCell_iPhone cellForTableView:tableView fromNib:self.calendarCellNib];

    EKCalendar *calendar = [self.availableCalendars objectAtIndex:indexPath.row];
    
    cell.calendarTitleLabel.text = calendar.title;
	cell.calendarTypeLabel.text = [calendar sourceString];
    cell.coloredDotView.color = [calendar customColor];
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    EKCalendar *calendar = [self.availableCalendars objectAtIndex:indexPath.row];
    [_delegate calendarPicker:self didPickCalendar:calendar];
}

@end
