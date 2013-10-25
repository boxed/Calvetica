//
//  CVWeekTableViewCellEvents.m
//  calvetica
//
//  Created by Adam Kirk on 3/23/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//




#import "CVWeekTableViewCellDrawing.h"
#import "CVCalendarItemShape.h"
#import "UIColor+Calvetica.h"
#import "UIColor+Compare.h"
#import "geometry.h"
#import "times.h"
#import "colors.h"


@implementation CVWeekTableViewCellDrawing

- (void)prepareCalendarItemsWithCompletion:(void (^)(NSArray *models))completion
{
    NSDate  *startDateOfWeek  = [self.delegate startDateForDrawingView:self];
    
    // get date range
    NSDate *startOfWeek = [startDateOfWeek mt_startOfCurrentWeek];
    NSDate *endOfWeek = [startDateOfWeek mt_endOfCurrentWeek];
    
    
    // grab all the events we need
    NSMutableArray *weekEvents = [NSMutableArray arrayWithArray:[EKEventStore eventsFromDate:startOfWeek
                                                                                      toDate:endOfWeek
                                                                          forActiveCalendars:YES]];  
    
    // sort the events in chrono order
    [weekEvents sortUsingComparator:(NSComparator)^(id obj1, id obj2){
        EKEvent *e1 = obj1;
        EKEvent *e2 = obj2;
        if (e1.isAllDay && e2.isAllDay) {
            return [e1.title localizedCaseInsensitiveCompare:e2.title];
        }
        return [e1 compareStartDateWithEvent:e2];
    }];
    
    NSMutableArray *chainedEvents                   = [NSMutableArray new];       // a collection of events that are chained together by any occurence of simultaneous overlap
    NSMutableArray *concurrentEvents                = [NSMutableArray new];       // a collection of events that occur simultaneously
    NSMutableArray *eventsToRemoveFromConcurrent    = [NSMutableArray new];
    NSMutableArray *eventSquareModels               = [NSMutableArray new];
    for (EKEvent *event in weekEvents) {
        
        NSDate *startDate   = event.startingDate;
        NSDate *endDate     = event.endingDate;

        CVCalendarItemShape *eventSquareModel    = [CVCalendarItemShape new];
        eventSquareModel.calendarItem           = event;
        eventSquareModel.startSeconds           = [startDate timeIntervalSinceDate:startOfWeek];
        eventSquareModel.endSeconds             = [endDate timeIntervalSinceDate:startOfWeek];

        if ([event.endingDate mt_isBefore:[NSDate date]]) {
            eventSquareModel.isPassed = YES;
        }
        
        for (NSUInteger day = 0; day < 7; day++) {
            NSDate *date = [startOfWeek mt_dateDaysAfter:day];
            if ([event occursAtAllOnDate:date]) {
                eventSquareModel.days[day] = 1;
            }
        }
        
        
        if ([event eventDuration] < 60 * 60 * 8) { //([event fitsWithinDayOfDate:event.startingDate] && ![event isAllDay]) || [event eventDuration] < SECONDS_IN_DAY - 1 ) {
            eventSquareModel.offset = -1;
            eventSquareModel.overlaps = -1;
            [eventSquareModels addObject:eventSquareModel];
            continue;
        }
        
            
        // if any concurrent events end before this one starts, it is no longer concurrent
        for (CVCalendarItemShape *e in concurrentEvents) {
            if (e.endSeconds <= eventSquareModel.startSeconds) {
                [eventsToRemoveFromConcurrent addObject:e];
            }
        }
        
        for (CVCalendarItemShape *e in eventsToRemoveFromConcurrent) {
            [concurrentEvents removeObject:e];
        }
        [eventsToRemoveFromConcurrent removeAllObjects];
        
        
        // chained events array is only emptied if there are no concurrent events
        if (concurrentEvents.count == 0) {
            [chainedEvents removeAllObjects];
        }
        
        // loop n^2 to make sure that any offset checked before an increment was not missed
        eventSquareModel.offset = 0;
        for (NSUInteger i = 0; i < concurrentEvents.count; i++) {
            for (CVCalendarItemShape *ie in concurrentEvents) {
                if ( ie.offset == eventSquareModel.offset ) {
                    eventSquareModel.offset++;
                }
            }
        }            
        
        // add the event to both sets because it's either a continuation or a start of a chain
        [chainedEvents addObject:eventSquareModel];
        [concurrentEvents addObject:eventSquareModel];
        
        // change the overlap count of all chained events to the max overlap count (so they are all the same width)
        NSUInteger maxOverlaps = 0;
        for (CVCalendarItemShape *e in chainedEvents) {
            if (e.overlaps < concurrentEvents.count) {
                e.overlaps = concurrentEvents.count;
            }
            
            if (e.overlaps > maxOverlaps) {
                maxOverlaps = e.overlaps;
            }
        }
        
        if (maxOverlaps > eventSquareModel.overlaps) {
            eventSquareModel.overlaps = maxOverlaps;
        }
        
        [eventSquareModels addObject:eventSquareModel];
    }

    if (PREFS.showReminders) {
        [[EKEventStore sharedStore] remindersFromDate:startOfWeek
                                               toDate:endOfWeek
                                            calendars:nil
                                              options:0
                                           completion:^(NSArray *reminders)
         {
             NSDate *now        = [NSDate date];
             NSDate *endOfToday = [now mt_endOfCurrentDay];
             BOOL isThisWeek    = [startOfWeek mt_isWithinSameWeek:endOfToday];

             for (EKReminder *reminder in reminders) {

                 NSDate *reminderDate = reminder.mys_date;
                 if (reminder.isFloating && isThisWeek) {
                     reminderDate = endOfToday;
                 }

                 CVCalendarItemShape *eventSquareModel    = [CVCalendarItemShape new];
                 eventSquareModel.calendarItem           = reminder;
                 eventSquareModel.startSeconds           = [reminderDate timeIntervalSinceDate:startOfWeek];
                 eventSquareModel.endSeconds             = eventSquareModel.startSeconds;
                 eventSquareModel.offset                 = -1;
                 eventSquareModel.overlaps               = -1;


                 if ([reminderDate mt_isBefore:now]) {
                     eventSquareModel.isPassed = YES;
                 }

                 for (NSUInteger day = 0; day < 7; day++) {
                     NSDate *date = [startOfWeek mt_dateDaysAfter:day];
                     if ([reminderDate mt_isWithinSameDay:date]) {
                         eventSquareModel.days[day] = 1;
                     }
                 }
                 [eventSquareModels addObject:eventSquareModel];
             }

             [eventSquareModels sortUsingComparator:^NSComparisonResult(CVCalendarItemShape *c1, CVCalendarItemShape *c2) {
                 return [c1.calendarItem compareWithCalendarItem:c2.calendarItem];
             }];
             
             if (completion) completion(eventSquareModels);
         }];
    }
    else {
        [eventSquareModels sortUsingComparator:^NSComparisonResult(CVCalendarItemShape *c1, CVCalendarItemShape *c2) {
            return [c1.calendarItem compareWithCalendarItem:c2.calendarItem];
        }];

        if (completion) completion(eventSquareModels);
    }
}

- (void)draw
{
    [MTq def:^{
        if (!self.window) return;
        [self prepareCalendarItemsWithCompletion:^(NSArray *models) {
            self.calendarItems = models;
            [MTq main:^{
                if (!self.window) return;
                self.hidden = NO;
                [self setNeedsDisplay];
            }];
        }];
    }];
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
    NSMutableArray *bars = [NSMutableArray array];
    NSMutableArray *dots = [NSMutableArray array];
    for (CVCalendarItemShape *e in self.calendarItems) {
        if (e.offset == -1 || [CVSettings dotsOnlyMonthView]) {
            [dots addObject:e];
        }
        else {
            [bars addObject:e];
        }
    }

    CGFloat padding = 1.0f;
    CGFloat boxWidth = self.bounds.size.width / (float)DAYS_IN_WEEK;
    NSUInteger maxOffset[DAYS_IN_WEEK];
    memset(maxOffset, 0, DAYS_IN_WEEK * sizeof(NSUInteger));
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    // DRAW BARS
    for (CVCalendarItemShape *e in bars) {
        
        NSUInteger startSecondsIntoWeek;
        NSUInteger endSecondsIntoDay;
        
        
        
        
        // SET X COORD
        
        // if it starts before this day
        if (e.startSeconds <= 0) {
            startSecondsIntoWeek = 0;
            e.x = 0;
            
        } 
        
        // otherwise it starts on this day
        else {
            startSecondsIntoWeek = e.startSeconds % SECONDS_IN_WEEK;
            e.x = (startSecondsIntoWeek / (float)SECONDS_IN_WEEK) * self.frame.size.width;	
        }
        
        
        
        
        // SET WIDTH
        
        // if it ends after the end of this week
        if (e.endSeconds >= SECONDS_IN_WEEK) {
            e.width = self.frame.size.width - e.x;
        } 
        
        // otherise, it ends within this week
        else {
            endSecondsIntoDay = e.endSeconds % SECONDS_IN_WEEK;
            e.width = ((endSecondsIntoDay - startSecondsIntoWeek) / (float)SECONDS_IN_WEEK) * self.frame.size.width;
            //iPhone min bar width
            if (e.width < 8) {
                e.width = 8;
            }
        }
        

        
        // SET HEIGHT
        
        e.height = 5;
        e.y = e.offset * e.height;
        
        for (NSUInteger day = 0; day < 7; day++) {
            // check if occurs on day
            if (e.days[day] == 0) continue;
            maxOffset[day] = e.offset >= maxOffset[day] ? e.offset + 1 : maxOffset[day];
        }
        
        
        
        
        // PADDING
        
        e.x += padding;
        e.y += (padding * 2.5f) + (padding * e.offset);
        e.width -= (padding * 2.0f);
        
        
        
        
        // DRAW
        CGColorRef color = [e.calendarItem.calendar customColor].CGColor;

        CGContextSetFillColorWithColor(context, color);
        CGContextSetShouldAntialias(context, YES);
        CGContextSetAlpha(context, 1.0f);

        if (e.isPassed) {
            CGContextSetAlpha(context, OLD_EVENT_ALPHA);
        }
        
        CGRect boxFrame = CGRectMake(roundf(e.x),
                                     roundf(e.y) - 1.0,
                                     roundf(e.width),
                                     roundf(e.height));
        
        CVContextFillRoundedRect(context, boxFrame, 2.5f);
    }
    
    
    
    // DRAW DOTS
    NSUInteger column[7];
    NSUInteger row[7];
    memset(column, 0, 7 * sizeof(NSUInteger));
    memset(row, 0, 7 * sizeof(NSUInteger));

    for (CVCalendarItemShape *e in dots) {
        
        e.width = 5;
        e.height = 5;
        
        for (NSUInteger day = 0; day < 7; day++) {
            
            NSUInteger c = column[day];
            NSUInteger r = row[day] + maxOffset[day];

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
            

            CGRect boxFrame = CGRectMake(roundf(e.x),
                                         roundf(e.y) - 1.0,
                                         roundf(e.width),
                                         roundf(e.height));

            // DRAW
            CGColorRef color = [e.calendarItem.calendar customColor].CGColor;
            CGContextSetFillColorWithColor(context, color);
            CGContextSetStrokeColorWithColor(context, color);
            CGContextSetAlpha(context, 1.0f);
            if (e.isPassed) {
                CGContextSetAlpha(context, OLD_EVENT_ALPHA);
            }

            if (e.calendarItem.isEvent) {
                CGContextFillEllipseInRect(context, boxFrame);
            }
            else {
                boxFrame = CGRectInset(boxFrame, 0.5, 0.5);
                CGContextSetLineWidth(context, 1.5);
                CGContextMoveToPoint(context, CGRectGetMinX(boxFrame), CGRectGetMidY(boxFrame));
                CGContextAddLineToPoint(context, CGRectGetMidX(boxFrame), CGRectGetMaxY(boxFrame));
                CGContextAddLineToPoint(context, CGRectGetMaxX(boxFrame), CGRectGetMinY(boxFrame));
                CGContextStrokePath(context);
            }
        }
    }
}

- (void)drawiPad 
{
    NSUInteger totalEventsPerDay[DAYS_IN_WEEK];
    memset(totalEventsPerDay, 0, DAYS_IN_WEEK * sizeof(NSUInteger));
    
    NSMutableArray *bars = [NSMutableArray array];
    NSMutableArray *dots = [NSMutableArray array];
    for (CVCalendarItemShape *e in self.calendarItems) {
        
        for (NSUInteger day = 0; day < 7; day++) {
            if (e.days[day] == 1) totalEventsPerDay[day]++;
        }
        
        if (e.offset == -1 || [CVSettings dotsOnlyMonthView]) {
            [dots addObject:e];
        }
        else {
            [bars addObject:e];
        }
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, 0.5f);
    

    NSUInteger maxOffset[DAYS_IN_WEEK];
    memset(maxOffset, 0, DAYS_IN_WEEK * sizeof(NSUInteger));
    NSUInteger eventsDrawnPerDay[DAYS_IN_WEEK];
    memset(eventsDrawnPerDay, 0, DAYS_IN_WEEK * sizeof(NSUInteger));
    
    
    // DIMENSIONS
    
    CGFloat boxWidth                = floorf(self.frame.size.width / (float)DAYS_IN_WEEK);
    CGFloat topPadding              = 3.0f;
    
    CGFloat barSidePadding          = 2.0f;
    CGFloat barSpacing              = 1.0f;
    CGFloat barHeight               = 12;
    CGFloat barHeightWithSpacing    = barHeight + barSpacing;
    
    
    
    // DRAW BARS
    for (CVCalendarItemShape *e in bars) {
        
        NSUInteger startSecondsIntoWeek;
        NSUInteger endSecondsIntoDay;
        
        
        // SET X COORD
        
        // if it starts before this week
        if (e.startSeconds <= 0) {
            startSecondsIntoWeek = 0;
            e.x = 0;
        } 
        
        // otherwise it starts on this day
        else {
            startSecondsIntoWeek = e.startSeconds % SECONDS_IN_WEEK;
            e.x = (startSecondsIntoWeek / (float)SECONDS_IN_WEEK) * self.frame.size.width;	
        }
        
        
        
        
        // SET WIDTH
        
        // if it ends after the end of this week
        if (e.endSeconds >= SECONDS_IN_WEEK) {
            e.width = self.frame.size.width - e.x;
        } 
        
        // otherise, it ends within this week
        else {
            endSecondsIntoDay = e.endSeconds % SECONDS_IN_WEEK;
            e.width = ((endSecondsIntoDay - startSecondsIntoWeek) / (float)SECONDS_IN_WEEK) * self.frame.size.width;	
            //iPad min bar width
            if (e.width < 20) {
                e.width = 20;
            }
        }
        
        
        
        
        // ADJUST SIDE PADDING
        
        e.x += barSidePadding;
        e.width -= (barSidePadding * 2.0f);
        
        
        
        
        
        // SET Y COORD
        
        e.y = topPadding + (barHeightWithSpacing * e.offset);
        
        
        
        // SET HEIGHT
        
        e.height = barHeight;
        
        if ( (e.y + (barHeightWithSpacing * 2.0f)) > self.bounds.size.height) {
            [dots addObjectsFromArray:bars];
            break;
        }
        
        for (NSUInteger day = 0; day < 7; day++) {
            // check if occurs on day
            if (e.days[day] == 0) continue;
            maxOffset[day] = e.offset >= maxOffset[day] ? e.offset + 1 : maxOffset[day];
        }
        
        
        // DRAW
        UIColor *calendarColor = [e.calendarItem.calendar customColor];
        CGColorRef color = [calendarColor CGColor];
        
        CGContextSetAlpha(context, 1.0f);
        if (e.isPassed) {
            CGContextSetAlpha(context, OLD_EVENT_ALPHA);
        }
        
        CGRect boxFrame = CGRectMake(roundf(e.x),
                                     roundf(e.y),
                                     roundf(e.width),
                                     roundf(e.height));

        CGContextSetFillColorWithColor(context, color);
        CGContextSetStrokeColorWithColor(context, [patentedVeryLightGray CGColor]);
        CGContextSetLineWidth(context, 1.0f);
        
        CVContextFillRoundedRect(context, boxFrame, 6.0f);
        
        // event text color
        if([calendarColor shouldUseLightText]) {
            CGContextSetFillColorWithColor(context, [patentedWhite CGColor]);
        }
        else {
            CGContextSetFillColorWithColor(context, [patentedBlack CGColor]);
        }

        CGRect textFrame = boxFrame;
        textFrame.origin.x += 5.0f;
        textFrame.size.width -= 10.0f;

		NSString *title = [e.calendarItem mys_title];
        [title drawInRect:textFrame withFont:[UIFont systemFontOfSize:9.0f] lineBreakMode:NSLineBreakByTruncatingTail];
        
        for (NSUInteger day = 0; day < 7; day++) {
            if (e.days[day] == 1) {
                eventsDrawnPerDay[day]++;
            }
        }
    }
    
    

    CGFloat dotSidePadding          = 5.0f;
    CGFloat dotSpacing              = 5.0f;
    CGFloat dotRadius               = 6.0f;
    CGFloat paddingBelowBars        = 3.0f;
    CGFloat dotHeightWithSpacing    = dotRadius + dotSpacing;
    
    
    
    // DRAW DOTS
    barSpacing = 4.0f;
    NSUInteger row[7];
    memset(row, 0, 7 * sizeof(NSUInteger));
    NSUInteger fullDays[DAYS_IN_WEEK];
    memset(fullDays, 0, DAYS_IN_WEEK * sizeof(NSUInteger));
    
    for (CVCalendarItemShape *e in dots) {
        
        e.width = 6;
        e.height = 6;
        
        for (NSUInteger day = 0; day < 7; day++) {

            CGContextSetShouldAntialias(context, YES);

            NSUInteger r = row[day];
            
            // check if occurs on day
            if (e.days[day] == 0 || fullDays[day] == 1) continue;
            
            
            // X COORD
            e.x = (boxWidth * day);
            e.x += dotSidePadding;
            
            
            // Y COORD
            e.y = topPadding + (maxOffset[day] * barHeightWithSpacing) + paddingBelowBars + (dotHeightWithSpacing * r);
            
            
            // INCREMENT
            row[day]++;
            if ((e.y + (dotHeightWithSpacing * 2.0f)) > self.bounds.size.height ) {
                CGRect textFrame = CGRectZero;
                textFrame.origin.x = e.x;
                textFrame.origin.y = e.y;
                textFrame.size.height = e.height;
                textFrame.size.width = boxWidth;
                
                NSUInteger eventsLeftToday = totalEventsPerDay[day] - eventsDrawnPerDay[day];
                if (eventsLeftToday > 0) {
                    NSString *title = [NSString stringWithFormat:@"%lu more...", (unsigned long)eventsLeftToday];
                    [title drawInRect:textFrame withFont:[UIFont systemFontOfSize:9.0f]];                    
                }
                
                fullDays[day] = 1;
                continue;
            }
            
            
            CGRect boxFrame = CGRectMake(roundf(e.x),
                                         roundf(e.y),
                                         roundf(e.width),
                                         roundf(e.height));

            // DRAW
            CGColorRef color = [e.calendarItem.calendar customColor].CGColor;

            CGContextSetFillColorWithColor(context, color);
            CGContextSetStrokeColorWithColor(context, color);
            CGContextSetAlpha(context, 1.0f);
            if (e.isPassed) {
                CGContextSetAlpha(context, OLD_EVENT_ALPHA);
            }
            
            if (e.calendarItem.isEvent) {
                CGContextFillEllipseInRect(context, boxFrame);
            }
            else {
                boxFrame.origin.y -= 1;
                CGContextSetLineWidth(context, 2);
                CGContextMoveToPoint(context, CGRectGetMinX(boxFrame), CGRectGetMidY(boxFrame));
                CGContextAddLineToPoint(context, CGRectGetMidX(boxFrame), CGRectGetMaxY(boxFrame));
                CGContextAddLineToPoint(context, CGRectGetMaxX(boxFrame), CGRectGetMinY(boxFrame));
                CGContextStrokePath(context);
                boxFrame.origin.y += 1;
            }


            // DRAW TEXT
            CGContextSetFillColorWithColor(context, [patentedBlack CGColor]);

            CGRect textFrame = boxFrame;
            textFrame.origin.x += 10.0f;
            textFrame.origin.y -= 3.0f;
            textFrame.size.width = boxWidth - boxFrame.size.width - (barSpacing * 2.0f);

            NSString *title = [e.calendarItem mys_title];
            [title drawInRect:textFrame withFont:[UIFont systemFontOfSize:9.0f] lineBreakMode:NSLineBreakByTruncatingTail];

            CGRect textRect = [title boundingRectWithSize:CGSizeMake(textFrame.size.width, 1000)
                                                  options:0
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:9.0] }
                                                  context:nil];

            CGContextSetShouldAntialias(context, NO);
            CGContextSetLineWidth(context, 0.1);
            // draw strikethrough if reminder and completed
            if (e.calendarItem.isReminder && [(EKReminder *)e.calendarItem isCompleted]) {
                CGRect strikeLineRect       = CGRectZero;
                strikeLineRect.origin.x     = CGRectGetMinX(textFrame);
                strikeLineRect.origin.y     = CGRectGetMinY(textFrame) + (textRect.size.height / 2);
                strikeLineRect.size.width   = MIN(textRect.size.width, textFrame.size.width - 10);
                strikeLineRect.size.height  = 1;
                strikeLineRect              = CGRectIntegral(strikeLineRect);
                CGContextMoveToPoint(context, CGRectGetMinX(strikeLineRect), CGRectGetMaxY(strikeLineRect));
                CGContextAddLineToPoint(context, CGRectGetMaxX(strikeLineRect), CGRectGetMaxY(strikeLineRect));
                CGContextStrokePath(context);
            }

            eventsDrawnPerDay[day]++;
        }
        
    }
    
}




@end
