//
//  CVAgendaDateCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVAgendaDateCell : CVCell
@property (nonatomic, strong)          NSDate  *date;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel *weekdayLabel;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel *dateLabel;
@end

NS_ASSUME_NONNULL_END
