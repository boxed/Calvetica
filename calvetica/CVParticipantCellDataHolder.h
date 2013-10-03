//
//  CVParticipantCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



@interface CVParticipantCellDataHolder : NSObject

@property (nonatomic, copy  ) NSString      *email;
@property (nonatomic, copy  ) NSArray       *telephoneNumbers;
@property (nonatomic, strong) EKParticipant *participant;
@property (nonatomic, strong) NSNumber      *recordID;

@end
