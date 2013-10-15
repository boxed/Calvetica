//
//  CVEventDetailsPeopleTableViewController_iPhone.m
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsPeopleTableViewController_iPhone.h"


@implementation CVEventDetailsPeopleTableViewController_iPhone

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

//@hack(James) the methods to find the attendees address book info are hacks because the built in method doesn't work, apple posted to the forums that the issue was a bug and they would fix it soon, i'm assuming it will be fixed in iOS5, the correct method is - (ABRecordRef)ABRecordWithAddressBook:(ABAddressBookRef)addressBook, you call this method on the participant and it will return their record if it's found in the address book.
- (NSNumber *)personWithEmail:(NSString *)email inAddressBook:(ABAddressBookRef)addressBook 
{ 
    ABRecordRef person = nil;
    NSNumber *recordId = nil;
    if (!addressBook) {
        return nil;
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    if (allPeople) {
        for (NSUInteger i = 0; i < CFArrayGetCount(allPeople); i++) {
            person = CFArrayGetValueAtIndex(allPeople, i);
            ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
            if (emails) {
                for (NSUInteger j = 0; j < ABMultiValueGetCount(emails); j++) {
                    NSString *personsEmail = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                    if ([personsEmail isEqualToString:email]) {
                        recordId = @(ABRecordGetRecordID(person));
                        break;
                    }
                    else {
                    }
                }
                CFRelease(emails);
            }
            if (recordId) {
                break;
            }
        }
        CFRelease(allPeople);
    }
    return recordId;
}

- (NSArray *)telephoneForPerson:(ABRecordRef)person 
{
    NSMutableArray *numbersArray = nil;
    if (!person) {
        return nil;
    }
    ABMultiValueRef numbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    if (numbers) {
        numbersArray = [NSMutableArray array];
        for (NSUInteger i = 0; i < ABMultiValueGetCount(numbers); i++) {
            
            NSMutableDictionary *numberDict = [NSMutableDictionary dictionary];
            
            NSString *telephoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(numbers, i);
            NSString *locTelephoneLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)telephoneLabel);
            NSString *telephone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(numbers, i);
            
            [numberDict setObject:locTelephoneLabel forKey:@"label"];
            [numberDict setObject:telephone forKey:@"telephone"];
            
            [numbersArray addObject:numberDict];
        }
        CFRelease(numbers);
    }
    return [NSArray arrayWithArray:numbersArray];
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
    
    if (_event) {
        
        if (_event.attendees) {
            // get a copy of the address book to search
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
            
            // if the address book exists search for all the event attendees
            if (addressBook) {
				__block BOOL done = NO;
				ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
					if (granted) {
						// get attendees
						NSArray *participants = _event.organizer ? @[_event.organizer] : @[];
						participants = [participants arrayByAddingObjectsFromArray:_event.attendees];
						for (EKParticipant *participant in participants) {
							// add the participant info to the holder nad array
							CVParticipantCellDataHolder *holder = [[CVParticipantCellDataHolder alloc] init];
							holder.participant = participant;

							// get the participants email address
							NSString *particantEmail = [self emailAddressFromParticipant:participant];
							holder.email = particantEmail;

							// search the address book for a person with the participant email
							NSNumber *personId = [self personWithEmail:particantEmail inAddressBook:addressBook];

							// if a person is found that matches, get their telephone number
							if (personId) {
								holder.recordID = personId;

								ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, [personId intValue]);
								if (person) {
									NSArray *telephoneNumbers = [self telephoneForPerson:person];

									// if the person has a telephone number save it
									if (telephoneNumbers) {
										holder.telephoneNumbers = telephoneNumbers;
									}
								}
							}

							[_participantDataHolderArray addObject:holder];
						}
						CFRelease(addressBook);
					}
					done = YES;
				});
				while (!done) {
					[NSThread sleepForTimeInterval:0.05];
				}
			}
        }
        else {
            CVParticipantCellDataHolder *holder = [[CVParticipantCellDataHolder alloc] init];
            [_participantDataHolderArray addObject:holder];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    CVPeopleTableViewCell_iPhone *cell = [CVPeopleTableViewCell_iPhone cellForTableView:tableView];
    CVParticipantCellDataHolder *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];
    
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
            cell.chatButton.enabled = false; 
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVParticipantCellDataHolder *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];
    
    if (holder.telephoneNumbers) {
        [_delegate callButtonWasPressedWithTelephoneNumbers:holder.telephoneNumbers];
    }
}

#pragma mark CVPeopleTableViewCell_iPhoneDelegate Methods

- (void)cellWasSwiped:(CVPeopleTableViewCell_iPhone *)cell 
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowContainingView:cell];
    CVParticipantCellDataHolder *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];
    if (holder.recordID) {
        [_delegate personWasSwiped:holder.recordID];
    }
}

- (void)cellChatButtonWasPressed:(id)button 
{
    UIButton *chatButton = (UIButton *)button;
    NSIndexPath *indexPath = [self.tableView indexPathForRowContainingView:chatButton];
    CVParticipantCellDataHolder *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];
    
    if (holder.telephoneNumbers) { 
        [_delegate chatButtonWasPressedWithTelephoneNumbers:holder.telephoneNumbers];
    }
}

- (void)cellEmailButtonWasPressed:(id)button 
{
    UIButton *emailButton = (UIButton *)button;
    NSIndexPath *indexPath = [self.tableView indexPathForRowContainingView:emailButton];
    CVParticipantCellDataHolder *holder = [_participantDataHolderArray objectAtIndex:indexPath.row];
    
    if (holder.email) {
        [_delegate emailButtonWasPressedForParticipants:@[holder.email]];
    }
}

@end
