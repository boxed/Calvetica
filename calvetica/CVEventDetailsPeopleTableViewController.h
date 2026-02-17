//
//  CVEventDetailsPeopleTableViewController.h
//  calvetica
//

#import "CVPeopleTableViewCell.h"


@protocol CVEventDetailsPeopleTableViewControllerDelegate;


@interface CVEventDetailsPeopleTableViewController : UITableViewController <CVPeopleTableViewCellDelegate>
@property (nonatomic, weak  ) NSObject <CVEventDetailsPeopleTableViewControllerDelegate> *delegate;
@property (nonatomic, strong) EKEvent                                                    *event;
@property (nonatomic, strong) NSMutableArray                                              *participantDataHolderArray;
@property (nonatomic        ) BOOL                                                        hasAttendees;
- (id)initWithEvent:(EKEvent *)newEvent;
- (void)loadAttendees;
@end


@protocol CVEventDetailsPeopleTableViewControllerDelegate <NSObject>
- (void)chatButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers;
- (void)emailButtonWasPressedForParticipants:(NSArray *)participantEmails;
- (void)personWasSwiped:(NSString *)contactIdentifier;
@end
