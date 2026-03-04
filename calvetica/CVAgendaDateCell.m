//
//  CVAgendaDateCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaDateCell.h"
#import "colors.h"
#import "UILabel+Utilities.h"

static NSString * const kCellIdentifier = @"CVAgendaDateCell";

@implementation CVAgendaDateCell

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    CVAgendaDateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CVAgendaDateCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier];
    }
    cell.contentView.backgroundColor = calBackgroundColor();
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);

    // Weekday label
    self.weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 9, 222, 50)];
    self.weekdayLabel.font = [UIFont systemFontOfSize:26];
    self.weekdayLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    self.weekdayLabel.backgroundColor = [UIColor clearColor];
    self.weekdayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:self.weekdayLabel];

    // Date label
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(119, 11, 201, 50)];
    self.dateLabel.font = [UIFont systemFontOfSize:20];
    self.dateLabel.textColor = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1.0];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.dateLabel];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.weekdayLabel.text = nil;
    self.dateLabel.text = nil;
    self.weekdayLabel.textColor = calQuaternaryText();
    _date = nil;
}

- (void)setDate:(NSDate *)newDate
{
	_date = newDate;

	// set label text
	_weekdayLabel.text = [[_date stringWithTitleOfCurrentWeekDayAbbreviated:NO] lowercaseString];
	self.dateLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_date mt_dayOfMonth]];

	if ([_date mt_isWithinSameDay:[NSDate date]]) {
		self.weekdayLabel.textColor = patentedRed;
	}
	else {
		self.weekdayLabel.textColor = calQuaternaryText();
	}

	// move day label over
	CGRect f = self.dateLabel.frame;
	f.origin.x = self.weekdayLabel.frame.origin.x + [self.weekdayLabel sizeOfTextInLabel].width + 10;
	[self.dateLabel setFrame:f];
}

- (void)cellWasTapped:(id)sender
{

}

@end
