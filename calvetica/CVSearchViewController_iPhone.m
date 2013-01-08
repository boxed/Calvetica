//
//  CVSearchViewController_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVSearchViewController_iPhone.h"
#import "UIActivityIndicatorView+Utilities.h"
#import "CVSearchScopePopoverController.h"
#import "CVEventStore.h"
#import "CVEventCell.h"



@interface CVSearchViewController_iPhone ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet CVTextField *searchTextField;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UINib *eventCellNib;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *currentSearchText;
@property (nonatomic, assign) CVSearchScopePopoverOption searchScope;
@end



@implementation CVSearchViewController_iPhone

- (UINib *)eventCellNib 
{
    if (!_eventCellNib) {
        self.eventCellNib = [CVSearchEventCell nib];
    }
    return _eventCellNib;    
}

- (void)setSearchScope:(CVSearchScopePopoverOption)newSearchScope
{
	_searchScope = newSearchScope;
	[self searchForText:_searchTextField.text];
}





#pragma mark - Constructor

- (id)init 
{
    self = [super init];
    if (self) {
        self.results = [NSMutableArray array];
		_searchScope = CVSearchScopePopoverOption6Months;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [_searchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    if ([self.searchTextField isFirstResponder]) {
        [_searchTextField resignFirstResponder];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Methods

- (void)searchForText:(NSString *)text 
{
	// this value will get retained but not copied so it could change before the block start executing
    self.currentSearchText = text;
	
	// don't do any search if its an empty string
    if ([[text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return;
    }
    
    dispatch_async([CVOperationQueue backgroundQueue], ^{
        
        // pause to see if the user is done typing
        [NSThread sleepForTimeInterval:0.5];
        
        if (![self.currentSearchText isEqualToString:text]) {
            return;
        }
        
        // start spinner
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator startAnimating];
        });
		
		// set the start and end dates
		NSDate *startDate;
		NSDate *endDate;
		if (_searchScope == CVSearchScopePopoverOption3Months) {
			startDate = [[NSDate date] dateMonthsBefore:3];
			endDate = [[NSDate date] dateMonthsAfter:3];
		}
		
		else if (_searchScope == CVSearchScopePopoverOption6Months) {
			startDate = [[NSDate date] dateMonthsBefore:6];
			endDate = [[NSDate date] dateMonthsAfter:6];
		}
		
		else if (_searchScope == CVSearchScopePopoverOption1Year) {
			startDate = [[NSDate date] dateYearsBefore:1];
			endDate = [[NSDate date] dateYearsAfter:1];
		}
		
		else if (_searchScope == CVSearchScopePopoverOption5Years) {
			startDate = [[NSDate date] dateYearsBefore:5];
			endDate = [[NSDate date] dateYearsAfter:5];
		}
		
		else {
			startDate = [[NSDate date] dateYearsBefore:25];
			endDate = [[NSDate date] dateYearsAfter:25];
		}
        
        // fetch the events
        NSMutableArray *events = [NSMutableArray arrayWithArray:[CVEventStore eventsSearchedWithText:text startDate:startDate endDate:endDate forActiveCalendars:YES]];
        
        
        // sort the dates so that those that start first will appear first
		NSDate *rightNow = [NSDate date];
        [events sortUsingComparator:(NSComparator)^(id obj1, id obj2){
            EKEvent *e1 = obj1;
            EKEvent *e2 = obj2;
            return CVABS([e1.startingDate timeIntervalSinceDate:rightNow]) < CVABS([e2.startingDate timeIntervalSinceDate:rightNow]) ? NSOrderedAscending : NSOrderedDescending;
        }];
        
        
        // update the table with our new event or cell
        dispatch_async(dispatch_get_main_queue(), ^{
			
			// don't try to display the data if the search string has changed by the time this finished loading
			if (![self.currentSearchText isEqualToString:text]) {
				return;
			}
            
            // replace the old data holder array with the one we just generated
            self.results = events;
            
            [self.tableView reloadData];
            
            [_activityIndicator stopAnimating];
        });
    });
}




#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    CVSearchEventCell *cell = [CVSearchEventCell cellForTableView:tv fromNib:self.eventCellNib];
    EKEvent *event = [_results objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    [cell setEvent:event searchText:self.currentSearchText];
    
    return cell;
}




#pragma mark - Table View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    [_searchTextField resignFirstResponder];
}





#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
        
    // this value will get copied into the block
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
	[self searchForText:text];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    // this value will get copied into the block
    NSString *text = textField.text;
    
	[self searchForText:text];
    
    return YES;
}

- (IBAction)closeButtonWasTapped:(id)sender 
{
    [self.delegate searchViewController:self didFinishWithResult:CVSearchViewControllerResultFinished];
}

- (IBAction)gearButtonWasTapped:(id)sender 
{
	[_searchTextField resignFirstResponder];
	CVSearchScopePopoverController *scopePopover = [[CVSearchScopePopoverController alloc] init];
    scopePopover.delegate = self;
    scopePopover.currentScope = _searchScope;
    scopePopover.popoverBackdropColor = patentedDarkGray;
	CVViewController *rvc = (CVViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rvc presentPopoverModalViewController:scopePopover forView:sender animated:YES];
}




#pragma mark - CVSearchEventCellDelegate

- (void)searchCellWasTapped:(CVSearchEventCell *)cell 
{
    [_searchTextField resignFirstResponder];
    id<CVEventCellDelegate> d = (id<CVEventCellDelegate>)self.delegate;
    [d searchController:self cellWasTapped:(CVEventCell *)cell];
}



#pragma mark - CVSearchScopePopoverControllerDelegate

- (void)searchScopeController:(CVSearchScopePopoverController *)controller didSelectOption:(CVSearchScopePopoverOption)option 
{
	CVViewController *rvc = (CVViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
	[rvc dismissPopoverModalViewControllerAnimated:YES];
	[_searchTextField becomeFirstResponder];
	self.searchScope = option;
}

- (void)searchScopeControllerDidRequestToClose:(CVSearchScopePopoverController *)controller 
{
	CVViewController *rvc = (CVViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
	[rvc dismissPopoverModalViewControllerAnimated:YES];
	[_searchTextField becomeFirstResponder];
}



#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched
{
    [_delegate searchViewController:self didFinishWithResult:CVSearchViewControllerResultFinished];
}




@end
