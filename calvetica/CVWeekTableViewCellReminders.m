//
//  CVWeekTableViewCellReminders.m
//  calvetica
//
//  Created by Adam Kirk on 3/23/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//




#import "CVWeekTableViewCellReminders.h"
#import "CVReminderSquare.h"
#import "CVEventStore.h"
#import "EKReminder+Calvetica.h"
#import "times.h"
#import "colors.h"




@implementation CVWeekTableViewCellReminders


- (NSArray *)prepareDataHolders
{
    NSDate  *startDateOfWeek  = [self.delegate startDateForDrawingView:self];
    
    // get date range
    NSDate *startOfWeek = [startDateOfWeek mt_startOfCurrentWeek];
    NSDate *endOfWeek = [startDateOfWeek mt_endOfCurrentWeek];
        
    // fetch week reminders
	NSArray *weekReminders = [CVEventStore remindersFromDate:startDateOfWeek toDate:endOfWeek activeCalendars:YES];

	NSDate *today = [NSDate date];

	// draw the reminders into their respective day squares
	NSMutableArray *reminderSquareDataHolders = [NSMutableArray array];
	for (EKReminder *reminder in weekReminders) {

		CVReminderSquare *reminderSquareDataHolder = [[CVReminderSquare alloc] init];
		reminderSquareDataHolder.reminder = reminder;

		NSDate *appearsOnDate = nil;
		NSDate *date = reminder.preferredDate;

		// if the reminder is completed, have it show up only on the day it was completed.
		if (reminder.isCompleted) {
			appearsOnDate = reminder.completionDate;
			reminderSquareDataHolder.isPassed = YES;
		}

		// if a reminder (not completed) is due after today, have it show up on the due date.
		else if (date && [date mt_isAfter:today])
			appearsOnDate = date;

		// otherwise it was due today or before today and is not completed, show it on today.
		else
			appearsOnDate = [[NSDate date] mt_startOfCurrentDay];


		// If the date the reminder is suppose to show up on is outside the range of the visible month, discard it.
		if ([appearsOnDate mt_isBefore:startOfWeek] || [appearsOnDate mt_isAfter:endOfWeek])
			continue;

		reminderSquareDataHolder.appearOnDate = appearsOnDate;

		for (NSInteger day = 0; day < 7; day++)
			if (([appearsOnDate mt_weekdayOfWeek] - 1) == day)
				reminderSquareDataHolder.days[day] = 1;

		// get the reminders shape
		NSInteger priority = reminder.priority;

		if (priority == CVColoredShapeTriangle)
			reminderSquareDataHolder.shape = CVColoredShapeTriangle;

		else if (priority == CVColoredShapeCircle)
			reminderSquareDataHolder.shape = CVColoredShapeCircle;
		
		else
			reminderSquareDataHolder.shape = CVColoredShapeRectangle;

		[reminderSquareDataHolders addObject:reminderSquareDataHolder];

	}

	return reminderSquareDataHolders;
}

- (void)draw 
{
    dispatch_async([CVOperationQueue backgroundQueue], ^(void) {
        if (!self.window) return;
		self.dataHolders = [self prepareDataHolders];
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			if (!self.window) return;
			[self setNeedsDisplay];
		});
    });
}

- (void)drawRect:(CGRect)rect 
{
    if (PAD) {
        [self drawiPad];
    }
    else {
        [self drawiPhone];
    }
}

- (void)drawiPhone 
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, 0.5f);
    
    CGFloat padding = 1.0f;
    CGFloat boxWidth = self.bounds.size.width / (DAYS_IN_WEEK * 1.0f);
    
    
    
    // DRAW REMINDERS
    
    NSInteger column[7];
    NSInteger row[7];
    memset(column, 0, 7 * sizeof(NSInteger));
    memset(row, 0, 7 * sizeof(NSInteger));
    
    for (CVReminderSquare *e in self.dataHolders) {
        
        e.width = 5;
        e.height = 5;
        
        for (NSInteger day = 0; day < 7; day++) {
            
            NSInteger c = column[day];
            NSInteger r = row[day];
            
            // check if occurs on day
            if (e.days[day] == 0) continue;
            
            e.x = (boxWidth * day) + (e.width * c);
            e.y = (e.height * r);
            
            
            // PADDING
            
            e.x += (padding * 2.0f) + (padding * c);
            e.y += (padding * 2.5f) + (padding * r);
            
            
            // INCREMENT
            
            if ( (e.x + (e.width * 2)) > ((day + 1) * boxWidth) ) {
                column[day] = 0;
                row[day]++;
            } else {
                column[day]++;
            }
            
            
            // DRAW
            
            UIColor *calendarColor = [UIColor colorWithCGColor:e.reminder.calendar.CGColor];
            CGColorRef color = [calendarColor CGColor];
            
            CGContextSetAlpha(context, 1.0f);
            if (e.isPassed) {
                CGContextSetAlpha(context, OLD_REMINDER_ALPHA);
            }
            
            CGRect boxFrame = CGRectMake(e.x, e.y, e.width, e.height);
            
            CGContextSetFillColorWithColor(context, color);
            CGContextSetStrokeColorWithColor(context, [patentedVeryLightGray CGColor]);
            CGContextSetLineWidth(context, 1.0f);
            
            if (e.shape == CVColoredShapeTriangle) {
                CGFloat minX = CGRectGetMinX(boxFrame);
                CGFloat maxX = CGRectGetMaxX(boxFrame);
                CGFloat minY = CGRectGetMinY(boxFrame);
                CGFloat maxY = CGRectGetMaxY(boxFrame);
                CGContextMoveToPoint(context, minX, maxY);
                CGContextAddLineToPoint(context, ((maxX - minX) / 2.0) + minX, minY);
                CGContextAddLineToPoint(context, maxX, maxY);
                CGContextClosePath(context);
                CGContextFillPath(context);
            }
            
            else if (e.shape == CVColoredShapeRectangle) {
                CGContextFillRect(context, boxFrame);
            }
            
            else {
                CGContextFillEllipseInRect(context, boxFrame);
            }
            
        }
        
    }
    
}

- (void)drawiPad 
{
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, 0.5f);
    
    CGFloat padding = 1.0f;
    CGFloat boxWidth = self.bounds.size.width / (DAYS_IN_WEEK * 1.0f);
    NSInteger maxOffset[DAYS_IN_WEEK];
    memset(maxOffset, 0, DAYS_IN_WEEK * sizeof(NSInteger));
    NSInteger remindersDrawn = 0;
    
    
    
    // DRAW DOTS
    padding = 4.0f;
    NSInteger row[7];
    memset(row, 0, 7 * sizeof(NSInteger));
    
    for (CVReminderSquare *e in self.dataHolders) {
        
        e.width = 6;
        e.height = 6;
        
        for (NSInteger day = 0; day < 7; day++) {
            
            NSInteger r = row[day];
            
            // check if occurs on day
            if (e.days[day] == 0) continue;
            
            e.x = (boxWidth * day);
            e.y = (e.height * r) + (maxOffset[day] * padding * 3.0f);
            
            
            // PADDING
            
            e.x += padding;
            e.y += (padding * 1.5f) + (padding * r);
            
            
            
            // INCREMENT
            
            row[day]++;
            if ( (e.y + (e.height * 2.5f)) > self.bounds.size.height) {
                CGRect textFrame = CGRectZero;
                textFrame.origin.x = e.x;
                textFrame.origin.y = e.y;
                textFrame.size.height = e.height;
                textFrame.size.width = boxWidth;
                
                NSInteger remindersLeft = self.dataHolders.count - remindersDrawn;
                NSString *title = [NSString stringWithFormat:@"%d more...", remindersLeft];
                [title drawInRect:textFrame withFont:[UIFont systemFontOfSize:9.0f]];
                return;
            }
            
            
            // DRAW
            
            UIColor *calendarColor = [UIColor colorWithCGColor:e.reminder.calendar.CGColor];
            CGColorRef color = [calendarColor CGColor];
            
            CGContextSetAlpha(context, 1.0f);
            if (e.isPassed) {
                CGContextSetAlpha(context, OLD_REMINDER_ALPHA);
            }
            
            CGRect boxFrame = CGRectMake(e.x, e.y, e.width, e.height);
            
            CGContextSetFillColorWithColor(context, color);
            CGContextSetStrokeColorWithColor(context, [patentedVeryLightGray CGColor]);
            CGContextSetLineWidth(context, 1.0f);
            
            if (e.shape == CVColoredShapeTriangle) {
                CGFloat minX = CGRectGetMinX(boxFrame);
                CGFloat maxX = CGRectGetMaxX(boxFrame);
                CGFloat minY = CGRectGetMinY(boxFrame);
                CGFloat maxY = CGRectGetMaxY(boxFrame);
                CGContextMoveToPoint(context, minX, maxY);
                CGContextAddLineToPoint(context, ((maxX - minX) / 2.0) + minX, minY);
                CGContextAddLineToPoint(context, maxX, maxY);
                CGContextClosePath(context);
                CGContextFillPath(context);
            }
            
            else if (e.shape == CVColoredShapeRectangle) {
                CGContextFillRect(context, boxFrame);
            }
            
            else {
                CGContextFillEllipseInRect(context, boxFrame);
            }
            
            CGContextSetFillColorWithColor(context, [patentedBlack CGColor]);
            
            CGRect textFrame = boxFrame;
            textFrame.origin.x += 10.0f;
            textFrame.origin.y -= 3.0f;
            textFrame.size.width = boxWidth - boxFrame.size.width - (padding * 2.0f);
            
            UIFont *font = [UIFont systemFontOfSize:9.0f];
            
            NSString *title = e.reminder.title;
            [title drawInRect:textFrame withFont:font];
            
            if (e.reminder.isCompleted) {
                CGFloat minX = CGRectGetMinX(textFrame);
                CGFloat maxX = CGRectGetMaxX(textFrame);
                CGFloat stringX = minX + [title sizeWithFont:font].width;
                stringX = stringX > maxX ? maxX - padding : stringX;
                CGFloat midY = (CGRectGetMaxY(textFrame) - CGRectGetMinY(textFrame)) + CGRectGetMinY(textFrame);
                CGContextMoveToPoint(context, minX, midY);
                CGContextAddLineToPoint(context, stringX, midY);
                CGContextSetStrokeColorWithColor(context, [patentedBlack CGColor]);
                CGContextStrokePath(context);
            }
            
            remindersDrawn++;
        }
        
    }
    
}




@end
