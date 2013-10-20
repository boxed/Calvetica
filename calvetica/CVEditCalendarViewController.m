//
//  CVCalendarDetailsViewController.m
//  calvetica
//
//  Created by James Schultz on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CVEditCalendarViewController.h"
#import "CVNativeAlertView.h"
#import "UIColor+Calvetica.h"
#import "UIImage+Clear.h"
#import "UIColor+Compare.h"


@interface CVEditCalendarViewController ()
@property (nonatomic, strong) UITextField *calendarTitleTextField;
@property (nonatomic, copy) NSArray *availableColors;
@property (nonatomic, strong) UIImage *clearImage;
@end


@implementation CVEditCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _availableColors = [self loadColors];
    self.clearImage = [UIImage clearImageWithSize:CGSizeMake(30, 30)];

    _calendarTitleTextField                         = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _calendarTitleTextField.delegate                = self;
    _calendarTitleTextField.returnKeyType           = UIReturnKeyDone;
    _calendarTitleTextField.font                    = [UIFont systemFontOfSize:16];
    _calendarTitleTextField.textColor               = [UIColor darkTextColor];
    _calendarTitleTextField.textAlignment           = NSTextAlignmentLeft;
    _calendarTitleTextField.autocapitalizationType  = UITextAutocapitalizationTypeSentences;
    _calendarTitleTextField.placeholder             = @"My new calendar";
    _calendarTitleTextField.autoresizingMask        = UIViewAutoresizingFlexibleWidth;

    _calendarTitleTextField.text    = self.calendar.title;
    self.navigationItem.title       = @"Edit Calendar";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
}

- (void)dealloc
{
    _calendarTitleTextField.delegate = nil;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}




#pragma mark - Actions

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
        UIColor *color                  = [_availableColors objectAtIndex:indexPath.row];
        cell.imageView.backgroundColor  = color;
        cell.imageView.image            = self.clearImage;
        cell.textLabel.text             = [NSString stringWithFormat:@"%@", color.mys_title];
        cell.selectionStyle             = UITableViewCellSelectionStyleBlue;
        cell.accessoryView              = nil;

        BOOL colorEqual = [[_calendar customColor] isEqualToColor:color];

        if (color.mys_selected) {
            if (colorEqual) {
                cell.detailTextLabel.text = NSLocalizedString(@"current selection", @"The user is able to choose a custom color");
            }
            else {
                cell.detailTextLabel.text = NSLocalizedString(@"in use by another calendar", @"the custom color selected by the user is in use by another calendar");
            }
        }
        else {
            cell.detailTextLabel.text = nil;
        }

        if (colorEqual) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        return cell;
    }

    return cell;
}




#pragma mark - DELEGATE table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UIColor *color      = [_availableColors objectAtIndex:indexPath.row];
        _calendar.CGColor   = color.CGColor;
        for (UIColor *c in self.availableColors) {
            if ([color isEqualToColor:c]) {
                c.mys_selected = YES;
            }
            else {
                c.mys_selected = NO;
            }
        }
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




#pragma mark - DELEGATE text field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}









#pragma mark - Private

- (NSArray *)loadColors
{
    NSMutableArray *colors = [NSMutableArray new];
    [colors addObjectsFromArray:[UIColor primaryPalette]];
    [colors addObjectsFromArray:[UIColor secondaryPalette]];
    [colors addObjectsFromArray:[UIColor systemPalette]];
    for (EKCalendar *calendar in [EKEventStore eventCalendars]) {
        for (UIColor *color in colors) {
            if ([[calendar customColor] isEqualToColor:color]) {
                color.mys_selected = YES;
                break;
            }
        }
    }

    return colors;
}


@end
