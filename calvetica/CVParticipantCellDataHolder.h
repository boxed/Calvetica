//
//  CVParticipantCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



@interface CVParticipantCellDataHolder : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSArray *telephoneNumbers;
@property (nonatomic, strong) EKParticipant *participant;
@property (nonatomic, strong) NSNumber *recordID;

@end
