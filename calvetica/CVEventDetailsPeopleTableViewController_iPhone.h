//
//  CVEventDetailsPeopleTableViewController_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "CVPeopleTableViewCell_iPhone.h"
#import "UITableView+Utilities.h"
#import "CVParticipantCellModel.h"
#import "colors.h"


@protocol CVEventDetailsPeopleTableViewController_iPhoneDelegate;


@interface CVEventDetailsPeopleTableViewController_iPhone : UITableViewController <CVPeopleTableViewCell_iPhoneDelegate>
@property (nonatomic, weak  ) NSObject <CVEventDetailsPeopleTableViewController_iPhoneDelegate> *delegate;
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


@protocol CVEventDetailsPeopleTableViewController_iPhoneDelegate <NSObject>
- (void)chatButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers;
- (void)emailButtonWasPressedForParticipants:(NSArray *)participantEmails;
- (void)callButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers;
- (void)personWasSwiped:(NSNumber *)personID;
@end
