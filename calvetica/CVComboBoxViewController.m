//
//  CVComboBox.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVComboBoxViewController.h"




@implementation CVComboBoxViewController

- (NSInteger)selectedItemIndex 
{
    return [self.items indexOfObject:self.selectedItem];
}

- (void)setSelectedItem:(NSObject *)selItem 
{
    _selectedItem = selItem;
    if (self.selectedItemLabel) {
        self.selectedItemLabel.text = [_selectedItem description];
    }
}




#pragma mark - Constructor

- (id)init 
{
    self = [super init];
    if (self) {
        self.items = @[];
        self.maxWidth = DEFAULT_MAX_WIDTH;
    }
    return self;
}

- (id)initWithTargetView:(UIView *)view itemsToSelect:(NSArray *)itemsToSelect selectedItemIndex:(NSInteger)selItem 
{
    self = [self init];
    if (self) {
        if (itemsToSelect.count == 0) {
            @throw [NSException exceptionWithName:@"CVComboBox invalid arguments." reason:@"itemsToSelect cannot be empty." userInfo:nil];
        }
        
        self.targetView = view;
        self.items = itemsToSelect;
        self.selectedItem = [self.items objectAtIndex:selItem];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.itemsView.layer.shadowColor = [patentedShadow CGColor];
    self.itemsView.layer.shadowOffset = CGSizeMake(0, 1);
    self.itemsView.layer.shadowOpacity = 1;
    self.itemsView.layer.shadowRadius = 2.8;
    
    self.selectedItemLabel.layer.shadowColor = [patentedShadow CGColor];
    self.selectedItemLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.selectedItemLabel.layer.shadowOpacity = 1;
    self.selectedItemLabel.layer.shadowRadius = 2.8;
}

- (void)viewDidUnload 
{
    self.itemsTableView = nil;
    self.itemsView = nil;
    self.mainView = nil;
    self.selectedItemLabel = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    CGRect frame = self.mainView.frame;
    
    // @hack: hacked way of displaying combobox in correct place. May break in future
    if (self.targetView.frame.origin.y != 0) {
        frame.origin.x = self.targetView.frame.origin.x;
        frame.origin.y = self.targetView.frame.origin.y;
    }
    else {
        frame.origin.x = self.targetView.frame.origin.x + self.targetView.superview.frame.origin.x;
        frame.origin.y = self.targetView.superview.frame.origin.y;
    }
    
    self.mainView.frame = frame;
    
    // The label for the selected item should be the same width as the target view.
    CGRect selectedItemLabelFrame = self.selectedItemLabel.frame;
    selectedItemLabelFrame.size.width = self.targetView.frame.size.width;
    self.selectedItemLabel.frame = selectedItemLabelFrame;
    
    self.selectedItemLabel.text = [self.selectedItem description];
    [self.itemsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.items indexOfObject:self.selectedItem] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *cellId = @"comboBoxCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        cell.textLabel.textColor = patentedWhite;
    }
    
    NSObject *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return NO;
}






#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    self.selectedItem = [self.items objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = patentedRed;
    
    [self.delegate comboBox:self didFinishWithResult:CVComboBoxResultFinished];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = patentedBlack;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return ITEM_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSObject *item = [self.items objectAtIndex:indexPath.row];
    if (item == self.selectedItem) {
        cell.backgroundColor = patentedRed;
    } else {
        cell.backgroundColor = patentedBlack;
    }
}




#pragma mark - IBActions

- (void)backgroundTapped:(id)sender 
{
    [self.delegate comboBox:self didFinishWithResult:CVComboBoxResultFinished];
}




@end
