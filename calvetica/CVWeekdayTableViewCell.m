//
//  CVWeekdayTableViewCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVWeekdayTableViewCell.h"
#import "CVEventSquare.h"
#import "UIView+Nibs.h"
#import "NSDate+ViewHelpers.h"
#import "EKEvent+Utilities.h"
#import "EKEventStore+Shared.h"
#import "colors.h"
#import "times.h"
#import "dimensions.h"


#define NUM_LABELS 25
#define TAG_OFFSET 99


@implementation CVWeekdayTableViewCell


- (void)setDate:(NSDate *)newDate 
{
    _date = newDate;
    
    _weekdayTitleLabel.text = [[_date stringWithTitleOfCurrentWeekDayAbbreviated:YES] uppercaseString];
    _monthDayTitleLabel.text = [NSString stringWithFormat:@"%d", [_date mt_dayOfMonth]];
    _redBarView.alpha = 1;
    
    _squaresView.date = newDate;
    _allDaySquaresView.date = newDate;
    
    if ([_date mt_isWithinSameDay:[NSDate date]]) {
        _allDaySquaresView.backgroundColor = patentedWhite;
        _squaresView.backgroundColor = patentedWhite;
        _redBarView.alpha = 0.7f;
    }
}

- (void)awakeFromNib
{
	[super awakeFromNib];
    _squaresView.delegate = self;
    _allDaySquaresView.delegate = self;
}

- (void)didMoveToWindow
{
	CGFloat rowHeight = round((self.bounds.size.height - _redBarView.frame.size.height) / (float)NUM_LABELS);
	CGRect f = _allDaySquaresView.frame;
	f.origin.x		= 0;
	f.origin.y		= round(_redBarView.frame.size.height);
	f.size.width	= self.bounds.size.width;
	f.size.height	= rowHeight;
	_allDaySquaresView.frame = f;

	f = _squaresView.frame;
	f.origin.x		= 0;
	f.origin.y		= round(_redBarView.frame.size.height + _allDaySquaresView.frame.size.height);
	//	f.size.width	= self.bounds.size.width;
	f.size.height	= round(self.bounds.size.height - f.origin.y);
	_squaresView.frame = f;
}



#pragma mark - Methods

- (void)drawEventSquares 
{
    
    // date can't be null
    if (!_date) return;
    
    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [_date copy];
    
    
    dispatch_async([CVOperationQueue backgroundQueue], ^(void) {
        
        // if this cell doesn't event represent day week anymore, then abort
        if (![dateCopy isEqualToDate:self.date]) return;

        // if this isn't even on the screen anymore, cancel it
        if (!self.window) return;

        // get date range
        NSDate *startOfDay = [dateCopy mt_startOfCurrentDay];
        NSDate *endOfDay = [dateCopy mt_endOfCurrentDay];
        
        
        
        // grab all the events we need
        NSMutableArray *weekEvents = [NSMutableArray arrayWithArray:[EKEventStore eventsFromDate:startOfDay
                                                                                          toDate:endOfDay
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
        
        NSMutableArray *chainedEvents = [NSMutableArray array]; // a collection of events that are chained together by any occurence of simultaneous overlap
        NSMutableArray *concurrentEvents = [NSMutableArray array]; // a collection of events that occur simultaneously
        NSMutableArray *eventsToRemoveFromConcurrent = [NSMutableArray array];
        NSMutableArray *eventSquareDataHolders = [NSMutableArray array];
        for (EKEvent *event in weekEvents) {
            
            CVEventSquare *eventSquareDataHolder = [[CVEventSquare alloc] init];
            eventSquareDataHolder.event = event;
            eventSquareDataHolder.startSeconds = [event.startingDate timeIntervalSinceDate:startOfDay];
            eventSquareDataHolder.endSeconds = [event.endingDate timeIntervalSinceDate:startOfDay];
            
            if (![event spansEntireDayOfDate:startOfDay]) {
                
                // if any concurrent events end before this one starts, it is no longer concurrent
                for (CVEventSquare *e in concurrentEvents) {
                    if (e.endSeconds <= eventSquareDataHolder.startSeconds) {
                        [eventsToRemoveFromConcurrent addObject:e];
                    }
                }
                
                for (CVEventSquare *e in eventsToRemoveFromConcurrent) {
                    [concurrentEvents removeObject:e];
                }
                [eventsToRemoveFromConcurrent removeAllObjects];
                
                
                // chained events array is only emptied if there are no concurrent events
                if (concurrentEvents.count == 0) {
                    [chainedEvents removeAllObjects];
                }
                
                // loop n^2 to make sure that any offset checked before an increment was not missed
                eventSquareDataHolder.offset = 0;
                for (NSInteger i=0; i < concurrentEvents.count; i++) {
                    for (CVEventSquare *ie in concurrentEvents) {
                        if ( ie.offset == eventSquareDataHolder.offset ) {
                            eventSquareDataHolder.offset++;
                        }
                    }
                }
                
                // add the event to both sets because it's either a continuation or a start of a chain
                [chainedEvents addObject:eventSquareDataHolder];
                [concurrentEvents addObject:eventSquareDataHolder];
                
                // change the overlap count of all chained events to the max overlap count (so they are all the same width)
                NSInteger maxOverlaps = 0;
                for (CVEventSquare *e in chainedEvents) {
                    if (e.overlaps < concurrentEvents.count) {
                        e.overlaps = concurrentEvents.count;
                    }
                    
                    if (e.overlaps > maxOverlaps) {
                        maxOverlaps = e.overlaps;
                    }
                }
                
                if (maxOverlaps > eventSquareDataHolder.overlaps) {
                    eventSquareDataHolder.overlaps = maxOverlaps;
                }
            }
            
            [eventSquareDataHolders addObject:eventSquareDataHolder];
        }
        

        NSMutableArray *allDayEventSquares = [NSMutableArray array];
        NSMutableArray *eventSquares = [NSMutableArray array];
        
        for (CVEventSquare *square in eventSquareDataHolders) {
            if ([square.event.startingDate mt_isOnOrBefore:startOfDay] && [square.event.endingDate mt_isOnOrAfter:endOfDay]) {
                [allDayEventSquares addObject:square];
            }
            else {
                [eventSquares addObject:square];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            _allDaySquaresView.squares = allDayEventSquares;
            _squaresView.squares = eventSquares;
        });
    });
}




#pragma mark - IBActions

- (IBAction)headerBarWasTapped:(id)sender 
{
    [_delegate weekdayCellHeaderWasTapped:self];
}




#pragma mark - CVEventSquaresViewDelegate

- (void)squaresView:(CVEventSquaresView *)view wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder 
{
    [_delegate weekdayCell:self wasLongPressedAtDate:datePressed allDay:allDay withPlaceholder:placeholder];
}

- (void)squaresView:(CVEventSquaresView *)view wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder 
{
    [_delegate weekdayCell:self wasPressedOnEvent:event withPlaceholder:placeholder];
}



#pragma mark - CVAllDayEventSquaresViewDelegate

- (void)allDaySquaresView:(CVAllDayEventSquaresView *)view wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder 
{
    [_delegate weekdayCell:self wasLongPressedAtDate:datePressed allDay:allDay withPlaceholder:placeholder];
}

- (void)allDaySquaresView:(CVAllDayEventSquaresView *)view wasPressedOnEvent:(id)event withPlaceholder:(UIView *)placeholder 
{
    [_delegate weekdayCell:self wasPressedOnEvent:event withPlaceholder:placeholder];
}




@end
