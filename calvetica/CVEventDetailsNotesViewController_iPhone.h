//
//  CVEventDetailsNotesViewController.h
//  calvetica
//
//  Created by Adam Kirk on 5/7/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

typedef enum {
    CVEventDetailsNotesResultDone,
    CVEventDetailsNotesResultSaved,
    CVEventDetailsNotesResultCancelled
} CVEventDetailsNotesResult;


@protocol CVEventDetailsNotesViewControllerDelegate;


@interface CVEventDetailsNotesViewController_iPhone : CVViewController <UITextViewDelegate>

#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVEventDetailsNotesViewControllerDelegate> delegate;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) EKReminder *reminder;

#pragma mark - IBOutlets
@property (nonatomic, strong) IBOutlet UITextView *notesTextView;

#pragma mark - Methods
- (void)animateTextViewUp;
- (void)animateTextViewDown;

#pragma mark - Actions
- (IBAction)editNoteButtonWasTapped:(id)sender;

@end


@protocol CVEventDetailsNotesViewControllerDelegate <NSObject>
@required
- (void)eventDetailsNotesViewController:(CVEventDetailsNotesViewController_iPhone *)controller didFinish:(CVEventDetailsNotesResult)result;
@end