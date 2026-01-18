//
//  CVEventDetailsNotesViewController.m
//  calvetica
//
//  Created by Adam Kirk on 5/7/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsNotesViewController.h"

@interface CVEventDetailsNotesViewController ()
@property (nonatomic, strong) UIView *notesInputAccessoryView;
@end

@implementation CVEventDetailsNotesViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.notesTextView.delegate = nil;
}

#pragma mark - Methods

- (void)hideKeyboard
{
    [_notesTextView resignFirstResponder];
}

- (void)animateTextViewUp
{
    // No longer needed - keyboard notifications handle this
}

- (void)animateTextViewDown
{
    // No longer needed - keyboard notifications handle this
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup full-screen layout
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    // Create custom input accessory with Cancel and Save buttons
    [self setupInputAccessoryView];
    self.notesTextView.inputAccessoryView = self.notesInputAccessoryView;

    // Make text view fill the screen with padding
    self.notesTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.notesTextView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.notesTextView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
        [self.notesTextView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
        [self.notesTextView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10]
    ]];

    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    if (self.event) {
        _notesTextView.text = _event.notes;
    }

    // Always start in edit mode
    [self editNoteButtonWasTapped:nil];
}

- (void)setupInputAccessoryView
{
    self.notesInputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.notesInputAccessoryView.backgroundColor = [UIColor systemGroupedBackgroundColor];

    // Cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.notesInputAccessoryView addSubview:cancelButton];

    // Save button
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.notesInputAccessoryView addSubview:saveButton];

    [NSLayoutConstraint activateConstraints:@[
        [cancelButton.leadingAnchor constraintEqualToAnchor:self.notesInputAccessoryView.leadingAnchor constant:16],
        [cancelButton.centerYAnchor constraintEqualToAnchor:self.notesInputAccessoryView.centerYAnchor],
        [saveButton.trailingAnchor constraintEqualToAnchor:self.notesInputAccessoryView.trailingAnchor constant:-16],
        [saveButton.centerYAnchor constraintEqualToAnchor:self.notesInputAccessoryView.centerYAnchor]
    ]];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    CGFloat keyboardHeight = keyboardFrame.size.height;

    [UIView animateWithDuration:duration animations:^{
        self.notesTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
        self.notesTextView.scrollIndicatorInsets = self.notesTextView.contentInset;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        self.notesTextView.contentInset = UIEdgeInsetsZero;
        self.notesTextView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

- (void)cancelButtonTapped:(id)sender
{
    [self hideKeyboard];
    [self.delegate eventDetailsNotesViewController:self didFinish:CVEventDetailsNotesResultCancelled];
}

- (void)saveButtonTapped:(id)sender
{
    self.event.notes = self.notesTextView.text;
    [self hideKeyboard];
    [self.delegate eventDetailsNotesViewController:self didFinish:CVEventDetailsNotesResultSaved];
}






#pragma mark - Actions

- (void)accessoryViewCloseButtonTapped:(id)sender
{
    [super accessoryViewCloseButtonTapped:sender];
    _notesTextView.editable = NO;
}

- (IBAction)editNoteButtonWasTapped:(id)sender
{
    _notesTextView.editable = YES;
    [_notesTextView becomeFirstResponder];

    NSUInteger length = _notesTextView.text.length;
    _notesTextView.selectedRange = NSMakeRange(length, 0);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
