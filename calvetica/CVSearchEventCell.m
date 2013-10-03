//
//  CVSearchEventCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVSearchEventCell.h"




@implementation CVSearchEventCell


#pragma mark - View lifecycle

- (void)awakeFromNib 
{
	[super awakeFromNib];
}




#pragma mark - Methods

- (void)setEvent:(EKEvent *)newEvent searchText:(NSString *)searchText 
{
    self.event = newEvent;
	
    _tinyIcon.hidden = YES;
        
    // find which element matched and put it in the title with highlighted text
    NSString *text = nil;
    NSRange titleRange = [_event.title rangeOfString:searchText options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)];
    NSRange notesRange = [_event.notes rangeOfString:searchText options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)];
    NSRange locationRange = [_event.location rangeOfString:searchText options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)];
    BOOL startsAtBeginning = NO;
    BOOL endsAtEnding = NO;
    
    if (titleRange.location != NSNotFound && titleRange.length > 0) {
        NSString *string = _event.title;
        NSRange r = titleRange;
        
        NSInteger location = CVMAX(0, (r.location - 10));
        startsAtBeginning = location == 0;
        NSInteger length = CVMIN((string.length - location), (r.length + 20));
        endsAtEnding = length != (r.length + 20);
        text = [string substringWithRange:NSMakeRange(location, length)];

        _tinyIcon.image = nil;
        _tinyIcon.hidden = NO;
    }
    else if (notesRange.location != NSNotFound && notesRange.length > 0) {
        NSString *string = _event.notes;
        NSRange r = notesRange;
        
        NSInteger location = CVMAX(0, (r.location - 10));
        startsAtBeginning = location == 0;
        NSInteger length = CVMIN((string.length - location), (r.length + 20));
        endsAtEnding = length != (r.length + 20);
        text = [string substringWithRange:NSMakeRange(location, length)];
        
        _tinyIcon.image = [UIImage imageNamed:@"tinyicon_note"];
        _tinyIcon.hidden = NO;
    }
    else if (locationRange.location != NSNotFound && locationRange.length > 0) {
        NSString *string = _event.location;
        NSRange r = locationRange;
        
        NSInteger location = CVMAX(0, (r.location - 10));
        startsAtBeginning = location == 0;
        NSInteger length = CVMIN((string.length - location), (r.length + 20));
        endsAtEnding = length != (r.length + 20);
        text = [string substringWithRange:NSMakeRange(location, length)];

        _tinyIcon.image = [UIImage imageNamed:@"tinyicon_location"];
        _tinyIcon.hidden = NO;
    }

    _foundTextLabel.text = [NSString stringWithFormat:@"%@%@%@", (startsAtBeginning ? @"" : @"..."), text, (endsAtEnding ? @"" : @"...")];
    [_foundTextLabel changeColor:patentedRed ofSubstring:searchText];
    
    
    // update color
    self.coloredDotView.color = [_event.calendar customColor];
    
    // update red label
    self.redSubtitleLabel.text = [_event.startingDate stringWithWeekdayMonthDayYearHourMinute];
}




#pragma mark - Actions

- (IBAction)cellWasTapped:(id)sender 
{
    [super cellWasTapped:sender];
    [_delegate searchCellWasTapped:self];
}

- (IBAction)cellWasSwiped:(id)sender 
{
}

@end
