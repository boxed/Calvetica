//
//  CVContactUsViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVContactUsViewController.h"




@implementation CVContactUsViewController


- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationItem.title = @"Contact Us";
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}



#pragma mark - Methods

- (void)emailButtonWasPressed 
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [mailComposer setToRecipients:@[@"support@calvetica.com"]];
        [mailComposer setSubject:@"Calvetica support"];
        
        NSString *OSVersion = [[UIDevice currentDevice] systemVersion];
        NSString *deviceVersion = [[UIDevice currentDevice] model];
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        NSString *messageBody = [NSString stringWithFormat:@"OS Version: %@\nDevice Model: %@\nApp Version: %@", OSVersion, deviceVersion, appVersion];
        
        [mailComposer setMessageBody:messageBody isHTML:NO];
        
        [self.navigationController presentViewController:mailComposer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)twitterButtonWasPressed 
{
    NSURL *twitterLink = [NSURL URLWithString:@"http://twitter.com/mystrou"];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:twitterLink]) {
        [[UIApplication sharedApplication] openURL:twitterLink];
    }
}

- (void)appStoreButtonWasPressed 
{
    NSURL *appStoreLink = [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=385862462"];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:appStoreLink]) {
        [[UIApplication sharedApplication] openURL:appStoreLink];
    }
}



#pragma mark - IBActions




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:17];

    if (indexPath.section == 0) {
        cell.textLabel.text = @"Email";
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = @"Twitter";
    }
    else if (indexPath.section == 2) {
        cell.textLabel.text = @"App Store";
    }

    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0) {
        // open email composer
        [self emailButtonWasPressed];
    }
    else if (indexPath.section == 1) {
        // open twitter link
        [self twitterButtonWasPressed];
    }
    else if (indexPath.section == 2) {
        // open app store link
        [self appStoreButtonWasPressed];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    if (section == 0) {
        return @"We read every email we get and do our best to answer them in a timely manner";
    }
    if (section == 1) {
        return @"We love Twitter!";
    }
    else {
        return @"Although we appreciate feedback in reviews on the App Store, if you have questions you want us to answer, please contact us by email or on Twitter so we can help. Apple doesn't allow us to respond to questions in reviews.";
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
