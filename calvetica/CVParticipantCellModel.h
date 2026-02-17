//
//  CVParticipantCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//




NS_ASSUME_NONNULL_BEGIN

@interface CVParticipantCellModel : NSObject

@property (nonatomic, copy  ) NSString      *email;
@property (nonatomic, copy  ) NSArray<NSDictionary *>       *telephoneNumbers;
@property (nonatomic, strong) EKParticipant *participant;
@property (nonatomic, copy  ) NSString      *contactIdentifier;

@end

NS_ASSUME_NONNULL_END