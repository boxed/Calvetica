//
//  CVKnowledgeBaseDetailViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVKnowledgeBaseDetailViewController.h"



@implementation CVKnowledgeBaseDetailViewController

- (void)viewWillAppear:(BOOL)animated 
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}

- (void)viewDidLoad 
{
    self.navigationItem.title = @"Answer";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.question.answerText;
    
    // set the textLabel properties so that the full text will be displayed
    cell.textLabel.numberOfLines = [self.question.answerText linesOfWordWrapTextWithFont:[UIFont boldSystemFontOfSize:18] constraintWidth:275];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [self.question.answerText totalHeightOfWordWrapTextWithFont:[UIFont boldSystemFontOfSize:18] constraintWidth:275] + 23;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return self.question.question;
}


@end
