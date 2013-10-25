//
//  CVEventDetailsNotesViewController.h
//  calvetica
//
//  Created by Adam Kirk on 5/7/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

typedef NS_ENUM(NSUInteger, CVEventDetailsNotesResult) {
    CVEventDetailsNotesResultDone,
    CVEventDetailsNotesResultSaved,
    CVEventDetailsNotesResultCancelled
};


@protocol CVEventDetailsNotesViewControllerDelegate;


@interface CVEventDetailsNotesViewController_iPhone : CVViewController <UITextViewDelegate>

#pragma mark - Properties
@property (nonatomic, weak) id<CVEventDetailsNotesViewControllerDelegate> delegate;
@property (nonatomic, strong) EKEvent *event;

#pragma mark - IBOutlets
@property (nonatomic, weak) IBOutlet UITextView *notesTextView;

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