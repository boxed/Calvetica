//
//  CVKnowledgeBaseViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVKnowledgeBaseViewController.h"



@interface CVKnowledgeBaseViewController()
@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
- (void)configureFetchController;
@end




@implementation CVKnowledgeBaseViewController

- (void)configureFetchController 
{
    NSManagedObjectContext *context = [KBStore sharedStore].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"KBQuestion" inManagedObjectContext:context];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"updated" ascending:YES]];
    request.fetchBatchSize = 25;
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:@"KBQuestionCache"];
    
    self.fetchController = frc;
    self.fetchController.delegate = self;
}

- (void)performFetch 
{
    NSError *error = nil;
    [self.fetchController performFetch:&error];
    [self.tableView reloadData];
}



#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Knowledge Base";
    
    [self configureFetchController];
    
    // register to receive a notif when the KBStore is updated
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(knowledgeBaseStoreChanged) name:KBStoreFinishedUpdatingNotification object:nil];
    
    // set up the search bar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, 0, 38);
    self.tableView.tableHeaderView = searchBar;
    
    // set up the search display controller
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.delegate = self;
    
    // set up the indicator view
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicatorView.hidesWhenStopped = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
}

- (void)viewWillAppear:(BOOL)animated 
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
    
    [self performFetch];
    [[KBStore sharedStore] getLatestFromServer];
    
    [self.indicatorView startAnimating];
}

- (void)viewDidUnload 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}



#pragma mark - Private Methods
- (void)knowledgeBaseStoreChanged 
{
    [self.indicatorView stopAnimating];
}


#pragma mark - UISearchDisplayControllerDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString 
{
    self.searchResults = [KBStore searchWithText:searchString];
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if ([tableView isEqual:self.tableView]) {
        return [[self.fetchController sections] count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (tableView == self.tableView) {
        return [[[self.fetchController sections] objectAtIndex:section] numberOfObjects];
    }
    else {
        return self.searchResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    KBQuestion *question = nil;
    if (tableView == self.tableView) {
        question = [self.fetchController objectAtIndexPath:indexPath];
    }
    else {
        question = [self.searchResults objectAtIndex:indexPath.row];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = question.question;
    cell.textLabel.font = cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];

    
    // set the textLabel properties so that the full text will be displayed
    cell.textLabel.numberOfLines = [question.question
                                    linesOfWordWrapTextWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]
                                    constraintWidth:260];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    KBQuestion *question;
    if (tableView == self.tableView) {
        question = [self.fetchController objectAtIndexPath:indexPath];
    }
    else {
        question = [self.searchResults objectAtIndex:indexPath.row];
    }
    
    CVKBDetailWebViewController *details = [[CVKBDetailWebViewController alloc] init];
    details.question = question;
    
    [self.navigationController pushViewController:details animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    KBQuestion *question = nil;
    if (tableView == self.tableView) {
        question = [self.fetchController objectAtIndexPath:indexPath];
    }
    else {
        question = [self.searchResults objectAtIndex:indexPath.row];
    }
    
    // return the height with the cell padding added in
    return [question.question totalHeightOfWordWrapTextWithFont:[UIFont boldSystemFontOfSize:18] constraintWidth:260] + 23;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (tableView == self.tableView) {
        return @"Questions";
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    if (tableView == self.tableView) {
        return @"Select a question to learn more";
    }
    return nil;
}




#pragma mark NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    [self.tableView endUpdates];
}


@end
