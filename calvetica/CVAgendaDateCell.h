//
//  CVAgendaDateCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"


@interface CVAgendaDateCell : CVCell
@property (nonatomic, strong)          NSDate  *date;
@property (nonatomic, weak  ) IBOutlet UILabel *weekdayLabel;
@property (nonatomic, weak  ) IBOutlet UILabel *dateLabel;
@end
