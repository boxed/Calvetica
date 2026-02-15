//
//  CVInboxViewController.m
//  calvetica
//

#import "CVInboxViewController.h"
#import <EventKitUI/EventKitUI.h>
#import "EKEventStore+Shared.h"
#import "EKEventStore+Events.h"

static const NSInteger kRecentDays = 14;

typedef NS_ENUM(NSInteger, CVInboxSection) {
    CVInboxSectionPending,
    CVInboxSectionRecent,
    CVInboxSectionCount
};

@interface CVInboxViewController () <EKEventViewDelegate>
@property (nonatomic, strong) NSArray<EKEvent *> *pendingEvents;
@property (nonatomic, strong) NSArray<EKEvent *> *recentEvents;
@property (nonatomic, strong) NSDate *lastViewedDate;
@end


@implementation CVInboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Inbox";
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;

    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventStoreChanged:)
                                                 name:EKEventStoreChangedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.lastViewedDate) {
        self.lastViewedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastInboxViewedDate"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastInboxViewedDate"];
    [self fetchEvents];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Data

- (void)fetchEvents
{
    if (![EKEventStore isPermissionGranted]) {
        self.pendingEvents = @[];
        self.recentEvents = @[];
        [self.tableView reloadData];
        return;
    }

    NSDate *now = [NSDate date];
    NSDate *oneYearFromNow = [now mt_dateYearsAfter:1];
    NSArray *events = [EKEventStore eventsFromDate:now toDate:oneYearFromNow forActiveCalendars:NO];

    // Pending invitations
    NSMutableArray *pending = [NSMutableArray array];
    for (EKEvent *event in events) {
        for (EKParticipant *attendee in event.attendees) {
            if (attendee.isCurrentUser && attendee.participantStatus == EKParticipantStatusPending) {
                [pending addObject:event];
                break;
            }
        }
    }
    [pending sortUsingComparator:^NSComparisonResult(EKEvent *a, EKEvent *b) {
        return [a.startDate compare:b.startDate];
    }];
    self.pendingEvents = pending;

    // Recently added events by others on shared calendars
    NSDate *recentCutoff = [now mt_dateDaysBefore:kRecentDays];
    NSMutableSet *pendingIdentifiers = [NSMutableSet set];
    for (EKEvent *event in pending) {
        if (event.eventIdentifier) [pendingIdentifiers addObject:event.eventIdentifier];
    }

    NSMutableArray *recent = [NSMutableArray array];
    for (EKEvent *event in events) {
        // Skip events already in pending
        if (event.eventIdentifier && [pendingIdentifiers containsObject:event.eventIdentifier]) continue;

        // Must have been created recently
        if (!event.creationDate || [event.creationDate compare:recentCutoff] == NSOrderedAscending) continue;

        // Skip events organized by the current user
        if (event.organizer.isCurrentUser) continue;

        [recent addObject:event];
    }
    [recent sortUsingComparator:^NSComparisonResult(EKEvent *a, EKEvent *b) {
        return [b.creationDate compare:a.creationDate]; // newest first
    }];
    self.recentEvents = recent;

    [self.tableView reloadData];
}

- (void)eventStoreChanged:(NSNotification *)notification
{
    [self fetchEvents];
}

- (NSArray<EKEvent *> *)eventsForSection:(NSInteger)section
{
    if (section == CVInboxSectionPending) return self.pendingEvents;
    if (section == CVInboxSectionRecent) return self.recentEvents;
    return @[];
}

- (BOOL)isNewEvent:(EKEvent *)event inSection:(NSInteger)section
{
    if (section == CVInboxSectionPending) {
        // Pending invitations are "new" if created after last viewed
        if (!self.lastViewedDate) return YES;
        NSDate *date = event.creationDate ?: event.startDate;
        return [date compare:self.lastViewedDate] == NSOrderedDescending;
    }
    if (section == CVInboxSectionRecent) {
        if (!self.lastViewedDate) return NO;
        return event.creationDate && [event.creationDate compare:self.lastViewedDate] == NSOrderedDescending;
    }
    return NO;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return CVInboxSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == CVInboxSectionPending) return @"Pending Invitations";
    if (section == CVInboxSectionRecent) return @"Recently Added";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *events = [self eventsForSection:section];
    return events.count > 0 ? events.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *events = [self eventsForSection:indexPath.section];

    if (events.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (indexPath.section == CVInboxSectionPending) {
            cell.textLabel.text = @"No pending invitations";
        } else {
            cell.textLabel.text = @"No recent additions";
        }
        cell.textLabel.textColor = UIColor.secondaryLabelColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InboxCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    EKEvent *event = events[indexPath.row];

    cell.textLabel.text = event.title;
    cell.textLabel.textColor = UIColor.labelColor;

    // Subtitle: date + organizer
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = event.allDay ? NSDateFormatterNoStyle : NSDateFormatterShortStyle;
    NSString *dateStr = [formatter stringFromDate:event.startDate];

    NSString *organizer = event.organizer.name;
    if (organizer) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ — %@", dateStr, organizer];
    } else {
        cell.detailTextLabel.text = dateStr;
    }
    cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;

    // Calendar color dot
    UIView *colorDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    colorDot.backgroundColor = [UIColor colorWithCGColor:event.calendar.CGColor];
    colorDot.layer.cornerRadius = 6;
    cell.imageView.image = [self imageFromView:colorDot];

    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;

    return cell;
}

- (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *events = [self eventsForSection:indexPath.section];
    if (events.count == 0) return;

    EKEvent *event = events[indexPath.row];
    EKEventViewController *eventVC = [[EKEventViewController alloc] init];
    eventVC.event = event;
    eventVC.allowsEditing = YES;
    eventVC.delegate = self;
    [self.navigationController pushViewController:eventVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *events = [self eventsForSection:indexPath.section];
    if (indexPath.row < (NSInteger)events.count && [self isNewEvent:events[indexPath.row] inSection:indexPath.section]) {
        cell.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.12];
    } else {
        cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    }
}


#pragma mark - EKEventViewDelegate

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
