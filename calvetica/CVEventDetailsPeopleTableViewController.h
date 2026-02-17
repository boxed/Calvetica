//
//  CVEventDetailsPeopleTableViewController.h
//  calvetica
//

#import "CVPeopleTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CVParticipantCellModel;
@protocol CVEventDetailsPeopleTableViewControllerDelegate;


@interface CVEventDetailsPeopleTableViewController : UITableViewController <CVPeopleTableViewCellDelegate>
@property (nonatomic, nullable, weak  ) NSObject <CVEventDetailsPeopleTableViewControllerDelegate> *delegate;
@property (nonatomic, strong) EKEvent                                                    *event;
@property (nonatomic, strong) NSMutableArray<CVParticipantCellModel *>                                              *participantDataHolderArray;
@property (nonatomic        ) BOOL                                                        hasAttendees;
- (instancetype)initWithEvent:(EKEvent *)newEvent;
- (void)loadAttendees;
@end


@protocol CVEventDetailsPeopleTableViewControllerDelegate <NSObject>
- (void)chatButtonWasPressedWithTelephoneNumbers:(NSArray *)telephoneNumbers;
- (void)emailButtonWasPressedForParticipants:(NSArray *)participantEmails;
- (void)personWasSwiped:(NSString *)contactIdentifier;
@end

NS_ASSUME_NONNULL_END
