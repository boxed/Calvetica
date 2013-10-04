//
//  CVEventDetailsNotesViewController.m
//  calvetica
//
//  Created by Adam Kirk on 5/7/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsNotesViewController_iPhone.h"

// @todo: There's an annoying bug where the dismiss button appears when long pressing
// on the notes view. If we want to allow copy/paste (which we do), I haven't been able
// to find a work around. When long pressing, the text view becomes the first responder.
// Because it's not editable, the keyboard doesn't appear but the inputAccessoryView does.

@implementation CVEventDetailsNotesViewController_iPhone


- (void)dealloc
{
    self.notesTextView.delegate = nil;
}

#pragma mark - Methods

- (void)hideKeyboard
{
    [_notesTextView resignFirstResponder];
}

- (void)animateTextViewUp 
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect r = _notesTextView.frame;
        r.size.height = 135.0;
        [_notesTextView setFrame:r];
    }];
}

- (void)animateTextViewDown 
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect r = _notesTextView.frame;
        r.size.height = 300.0;
        [_notesTextView setFrame:r];
    }];    
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.notesTextView.inputAccessoryView = self.keyboardAccessoryView;
    
    if (self.event) {
        _notesTextView.text = _event.notes;
    }
    
    if ([_notesTextView.text length] == 0) {
        [self editNoteButtonWasTapped:nil];
    }
}






#pragma mark - Actions

- (void)accessoryViewCloseButtonTapped:(id)sender 
{
    [super accessoryViewCloseButtonTapped:sender];
    _notesTextView.editable = NO;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self animateTextViewDown];
    }
}

- (IBAction)editNoteButtonWasTapped:(id)sender 
{
    _notesTextView.editable = YES;
    [_notesTextView becomeFirstResponder];
    
    // The text view is animated up and down because of the keyboard. We shouldn't do this when running on the iPad, it looks strange.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self animateTextViewUp];
    }
    
    NSUInteger length = _notesTextView.text.length;
    _notesTextView.selectedRange = NSMakeRange(length,0); 
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
