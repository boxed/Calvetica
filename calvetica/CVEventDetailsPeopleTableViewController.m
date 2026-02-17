//
//  CVEventDetailsPeopleTableViewController.m
//  calvetica
//

#import "CVEventDetailsPeopleTableViewController.h"
#import "CVParticipantCellModel.h"
#import "UITableView+Utilities.h"
#import <Contacts/Contacts.h>


@implementation CVEventDetailsPeopleTableViewController

- (NSString *)descriptionForParticipantStatus:(EKParticipantStatus)status
{
    switch (status) {
        case EKParticipantStatusUnknown: return NSLocalizedString(@"UNKNOWN", @"When the participant's status is UNKNOWN");
        case EKParticipantStatusPending: return NSLocalizedString(@"PENDING", @"When the participant's status is PENDING");
        case EKParticipantStatusAccepted: return NSLocalizedString(@"ACCEPTED", @"When the participant's status is ACCEPTED");
        case EKParticipantStatusTentative: return NSLocalizedString(@"TENTATIVE", @"When the participant's status is TENTATIVE");
        case EKParticipantStatusDelegated: return NSLocalizedString(@"DELEGATED", @"When the participant's status is DELEGATED");
        case EKParticipantStatusCompleted: return NSLocalizedString(@"COMPLETED", @"When the participant's status is COMPLETED");
        case EKParticipantStatusInProcess: return NSLocalizedString(@"INPROCESS", @"When the participant's status is INPROCESS");
        default: return NSLocalizedString(@"UNKNOWN", @"When the participant's status is UNKNOWN");
    }
}

- (NSString *)emailAddressFromParticipant:(EKParticipant *)participant
{
    NSString *email = [NSString stringWithFormat:@"%@", participant.URL];
    NSArray *components = [email componentsSeparatedByString:@"mailto:"];
    return [components lastObject];
}

- (id)initWithEvent:(EKEvent *)newEvent
{
    self = [super init];
    if (self) {
        _participantDataHolderArray = [NSMutableArray array];
        _event = newEvent;
        [self loadAttendees];
    }
    return self;
}

- (void)loadAttendees
{
    _participantDataHolderArray = [NSMutableArray array];

    if (!_event) return;

    if (_event.attendees) {
        _hasAttendees = YES;

        CNContactStore *contactStore = [[CNContactStore alloc] init];
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        BOOL hasContactsAccess = (authStatus == CNAuthorizationStatusAuthorized);

        NSArray *participants = _event.organizer ? @[_event.organizer] : @[];
        participants = [participants arrayByAddingObjectsFromArray:_event.attendees];

        for (EKParticipant *participant in participants) {
            CVParticipantCellModel *holder = [[CVParticipantCellModel alloc] init];
            holder.participant = participant;

            NSString *participantEmail = [self emailAddressFromParticipant:participant];
            holder.email = participantEmail;

            if (hasContactsAccess && participantEmail.length > 0) {
                NSPredicate *predicate = [CNContact predicateForContactsMatchingEmailAddress:participantEmail];
                NSArray *keysToFetch = @[CNContactIdentifierKey, CNContactPhoneNumbersKey];
                NSArray *contacts = [contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:nil];
                CNContact *contact = contacts.firstObject;

                if (contact) {
                    holder.contactIdentifier = contact.identifier;

                    NSMutableArray *numbersArray = [NSMutableArray array];
                    for (CNLabeledValue<CNPhoneNumber *> *labeledValue in contact.phoneNumbers) {
                        NSMutableDictionary *numberDict = [NSMutableDictionary dictionary];
                        NSString *label = [CNLabeledValue localizedStringForLabel:labeledValue.label] ?: @"";
                        NSString *telephone = labeledValue.value.stringValue ?: @"";
                        [numberDict setObject:label forKey:@"label"];
                        [numberDict setObject:telephone forKey:@"telephone"];
                        [numbersArray addObject:numberDict];
                    }
                    if (numbersArray.count > 0) {
                        holder.telephoneNumbers = numbersArray;
                    }
                }
            }

            [_participantDataHolderArray addObject:holder];
        }
    }
    else {
        _hasAttendees = NO;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _participantDataHolderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVPeopleTableViewCell *cell = [CVPeopleTableViewCell cellForTableView:tableView];
    CVParticipantCellModel *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];

    if (holder.participant) {
        if (holder.email) {
            cell.emailButton.selected = YES;
        }
        else {
            cell.emailButton.alpha = 0.3;
        }

        if (holder.telephoneNumbers && holder.telephoneNumbers.count > 0 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]]) {
            cell.chatButton.selected = YES;
        }
        else {
            cell.chatButton.alpha = 0.3;
            cell.chatButton.enabled = NO;
        }

        cell.personTitleLabel.text = holder.participant.name;
        if ([holder.participant isEqual:_event.organizer]) {
            cell.personStatusLabel.text = @"EVENT ORGANIZER";
        }
        else {
            cell.personStatusLabel.text = [self descriptionForParticipantStatus:holder.participant.participantStatus];
        }
        cell.delegate = self;
    }
    else {
        cell.personTitleLabel.text = @"No attendees";
        cell.emailButton.hidden = YES;
        cell.chatButton.hidden = YES;
        cell.personStatusLabel.text = @"ADD ATTENDEES BELOW";
    }

    return cell;
}


#pragma mark - CVPeopleTableViewCellDelegate Methods

- (void)cellWasSwiped:(CVPeopleTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowContainingView:cell];
    CVParticipantCellModel *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];
    if (holder.contactIdentifier) {
        [_delegate personWasSwiped:holder.contactIdentifier];
    }
}

- (void)cellChatButtonWasPressed:(id)button
{
    UIButton *chatButton = (UIButton *)button;
    NSIndexPath *indexPath = [self.tableView indexPathForRowContainingView:chatButton];
    CVParticipantCellModel *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];

    if (holder.telephoneNumbers) {
        [_delegate chatButtonWasPressedWithTelephoneNumbers:holder.telephoneNumbers];
    }
}

- (void)cellEmailButtonWasPressed:(id)button
{
    UIButton *emailButton = (UIButton *)button;
    NSIndexPath *indexPath = [self.tableView indexPathForRowContainingView:emailButton];
    CVParticipantCellModel *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];

    if (holder.email) {
        [_delegate emailButtonWasPressedForParticipants:@[holder.email]];
    }
}

@end
