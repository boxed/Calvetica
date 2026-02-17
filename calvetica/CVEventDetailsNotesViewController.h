//
//  CVEventDetailsNotesViewController.h
//  calvetica
//
//  Created by Adam Kirk on 5/7/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, CVEventDetailsNotesResult) {
    CVEventDetailsNotesResultDone,
    CVEventDetailsNotesResultSaved,
    CVEventDetailsNotesResultCancelled
};


@protocol CVEventDetailsNotesViewControllerDelegate;


@interface CVEventDetailsNotesViewController : CVViewController <UITextViewDelegate>

#pragma mark - Properties
@property (nonatomic, nullable, weak) id<CVEventDetailsNotesViewControllerDelegate> delegate;
@property (nonatomic, strong) EKEvent *event;

#pragma mark - IBOutlets
@property (nonatomic, nullable, weak) IBOutlet UITextView *notesTextView;

#pragma mark - Methods
- (void)animateTextViewUp;
- (void)animateTextViewDown;

#pragma mark - Actions
- (IBAction)editNoteButtonWasTapped:(id)sender;

@end


@protocol CVEventDetailsNotesViewControllerDelegate <NSObject>
@required
- (void)eventDetailsNotesViewController:(CVEventDetailsNotesViewController *)controller didFinish:(CVEventDetailsNotesResult)result;
@end

NS_ASSUME_NONNULL_END