//
//  CVCalendarPickerViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarPickerViewController_iPhone.h"




@implementation CVCalendarPickerViewController_iPhone

- (void)dealloc
{
    self.calendarsTableView.delegate    = nil;
    self.calendarsTableView.dataSource  = nil;
    self.scrollView.delegate            = nil;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.calendarPickerController                           = [[CVCalendarPickerTableViewController alloc] init];
    self.calendarPickerController.delegate                  = self;
    self.calendarPickerController.tableView                 = self.calendarsTableView;
    self.calendarsTableView.dataSource                      = self.calendarPickerController;
    self.calendarsTableView.delegate                        = self.calendarPickerController;
    self.calendarPickerController.showUneditableCalendars   = NO;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [self adjustLayoutOfTableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Methods

- (void)adjustLayoutOfTableView 
{
    CGFloat currentY = self.view.bounds.origin.y;
    NSInteger cellHeight = 42;
    
    CGRect f = _eventCalendarBlock.frame;
    f.origin.y = currentY;
    
    CGFloat calendarTableContentSize = self.calendarPickerController.calendars.count * cellHeight;
    CGSize calendarTableFrameSize = self.calendarsTableView.bounds.size;
    
    CGFloat heightDifference = (calendarTableContentSize - calendarTableFrameSize.height);
    f.size.height +=heightDifference;
    
    currentY += f.size.height;
    [_eventCalendarBlock setFrame:f];
    
    self.calendarsTableView.frame = CGRectMake(self.calendarsTableView.frame.origin.x, self.calendarsTableView.frame.origin.y, self.calendarsTableView.bounds.size.width,  calendarTableContentSize);
    
    // resize the scroll view
    CGSize s = self.scrollView.contentSize;
    if (currentY > s.height) {
        s.height = currentY;
    }
    self.scrollView.contentSize = s;
}


#pragma mark - IBActions

#pragma mark - CVCalendarPickerTableViewControllerDelegate Methods
- (void)calendarPicker:(CVCalendarPickerTableViewController *)calendarPicker didPickCalendar:(EKCalendar *)calendar 
{
    [self.delegate calendarPickerController:self didPickCalendar:calendar];
}

#pragma mark - CVModalProtocol Methods
- (void)modalBackdropWasTouched 
{
    [self.delegate calendarPickerController:self didPickCalendar:nil];
}

@end
