//
//  CVWeekdayTableHeaderView.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface CVWeekdayTableHeaderView : UIView

@property (nonatomic, strong)          NSDate  *date;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel *weekNumberLabel;

@end

NS_ASSUME_NONNULL_END