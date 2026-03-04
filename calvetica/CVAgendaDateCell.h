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
@property (nonatomic, nullable, strong) UILabel *weekdayLabel;
@property (nonatomic, nullable, strong) UILabel *dateLabel;

+ (instancetype)cellForTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
