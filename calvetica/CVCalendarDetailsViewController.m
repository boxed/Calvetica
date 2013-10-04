//
//  CVCalendarDetailsViewController.m
//  calvetica
//
//  Created by James Schultz on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CVCalendarDetailsViewController.h"
#import "CVEventStore.h"
#import "CVNativeAlertView.h"
#import "CVCustomColorDataHolder.h"



@interface CVCalendarDetailsViewController ()
@property (nonatomic, strong) UITextField *calendarTitleTextField;
@property (nonatomic, copy) NSArray *availableColors;
@end




@implementation CVCalendarDetailsViewController


- (void)dealloc
{
    _calendarTitleTextField.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _availableColors = [self loadColors];

    _calendarTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _calendarTitleTextField.delegate = self;
    _calendarTitleTextField.returnKeyType = UIReturnKeyDone;
    _calendarTitleTextField.font = [UIFont systemFontOfSize:16];
    _calendarTitleTextField.textColor = [UIColor darkTextColor];
    _calendarTitleTextField.textAlignment = NSTextAlignmentLeft;
    _calendarTitleTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _calendarTitleTextField.placeholder = @"My new calendar";

	_calendarTitleTextField.text = self.calendar.title;
	self.navigationItem.title = @"Edit Calendar";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}




#pragma mark - Public Methods

- (void)cancelButtonPressed:(id)sender
{
    [_delegate calendarDetailsController:self didFinishWithResult:CVCalendarDetailsControllerResultCancelled];
}

- (void)doneButtonPressed:(id)sender
{
	[_calendarTitleTextField resignFirstResponder];

	if ([self.calendarTitleTextField.text isEqualToString:@""])
		_calendar.title = @"Untitled";
	else
		_calendar.title = _calendarTitleTextField.text;

	if ([_calendar save]) {
		[_delegate calendarDetailsController:self didFinishWithResult:CVCalendarDetailsControllerResultSaved];
	}
	else
		[_delegate calendarDetailsController:self didFinishWithResult:CVCalendarDetailsControllerResultCancelled];
}

- (NSArray *)loadColors
{
    NSArray *colors = [CVCustomColorDataHolder customColorsDataHolderCollection];
    for (EKCalendar *grp in [CVEventStore eventCalendars]) {
        for (CVCustomColorDataHolder *holder in colors) {
            if ([[grp customColor] isEqual:holder.color]) {
                holder.isSelected = YES;
                break;
            }
        }
    }

    return colors;
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _availableColors.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"CalendarDetailCell"];
    cell.textLabel.font         = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.detailTextLabel.font   = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];

    if (indexPath.section == 0) {
        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
        cell.textLabel.text         = @"Title";
        cell.detailTextLabel.text   = nil;
        cell.imageView.image        = nil;
        cell.accessoryView          = _calendarTitleTextField;
        return cell;
    }
	
    else if (indexPath.section == 1) {
        CVCustomColorDataHolder *colorHolder    = [_availableColors objectAtIndex:indexPath.row];
        cell.imageView.backgroundColor          = colorHolder.color;
        cell.imageView.image                    = [UIImage imageNamed:@"bg_clear_cell_image"];
        cell.textLabel.text                     = [NSString stringWithFormat:@"%@", colorHolder.title];
        cell.selectionStyle                     = UITableViewCellSelectionStyleBlue;
        cell.accessoryView                      = nil;

        if (colorHolder.isSelected) {
            if ([[_calendar customColor] isEqual:colorHolder.color]) {
                cell.detailTextLabel.text = NSLocalizedString(@"current selection", @"The user is able to choose a custom color");
            }
            else {
                cell.detailTextLabel.text = NSLocalizedString(@"in use by another calendar", @"the custom color selected by the user is in use by another calendar");
            }
        }
        else {
            cell.detailTextLabel.text = nil;
        }

        if ([[_calendar customColor] isEqual:colorHolder.color]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        return cell;
    }

    return [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CVCustomColorDataHolder *colorHolder = [_availableColors objectAtIndex:indexPath.row];
        _calendar.CGColor = colorHolder.color.CGColor;
        _availableColors = [self loadColors];
        [self.tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Calendar Title";
    }
    else if (section == 1) {
        return @"Calendar Color";
    }
    else return nil;
}









#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
