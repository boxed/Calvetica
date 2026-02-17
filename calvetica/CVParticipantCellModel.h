//
//  CVParticipantCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



@interface CVParticipantCellModel : NSObject

@property (nonatomic, copy  ) NSString      *email;
@property (nonatomic, copy  ) NSArray       *telephoneNumbers;
@property (nonatomic, strong) EKParticipant *participant;
@property (nonatomic, copy  ) NSString      *contactIdentifier;

@end
