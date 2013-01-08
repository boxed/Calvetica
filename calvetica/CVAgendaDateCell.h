//
//  CVAgendaDateCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"
#import "EKEvent+Utilities.h"


@interface CVAgendaDateCell : CVCell

#pragma mark - Properties
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) IBOutlet CVLabel *weekdayLabel; 
@property (nonatomic, strong) IBOutlet CVLabel *dateLabel; 

#pragma mark - Methods


#pragma mark - IBActions


@end
