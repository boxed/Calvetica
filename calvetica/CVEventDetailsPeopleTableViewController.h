//
//  CVEventDetailsPeopleTableViewController_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVPeopleTableViewCell_iPhone.h"


@protocol CVEventDetailsPeopleTableViewControllerDelegate;


@interface CVEventDetailsPeopleTableViewController : UITableViewController <CVPeopleTableViewCellDelegate>
@property (nonatomic, weak  ) NSObject <CVEventDetailsPeopleTableViewControllerDelegate> *delegate;
@property (nonatomic, strong) EKEvent                                                           *event;
@property (nonatomic, strong) NSMutableArray                                                    *participantDataHolderArray;
@property (nonatomic        ) BOOL                                                              hasAttendees;
- (id)initWithEvent:(EKEvent *)newEvent;
- (NSString *)descriptionForParticipantStatus:(EKParticipantStatus)status;
- (NSString *)emailAddressFromParticipant:(EKParticipant *)participant;
- (NSNumber *)personWithEmail:(NSString *)email inAddressBook:(ABAddressBookRef)addressBook;
- (NSArray *)telephoneForPerson:(ABRecordRef)addressBookRef;
- (void)loadAttendees;
@end


@protocol CVEventDetailsPeopleTableViewControllerDelegate <NSObject>
- (void)chatButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers;
- (void)emailButtonWasPressedForParticipants:(NSArray *)participantEmails;
- (void)callButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers;
- (void)personWasSwiped:(NSNumber *)personID;
@end
