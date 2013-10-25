//
//  CVEventSnoozeViewController_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "times.h"
#import "CVViewController.h"


typedef NS_ENUM(NSUInteger, CVEventSnoozeResult) {
    CVEventSnoozeResultCancelled,
    CVEventSnoozeResultShowDetails,
    CVEventSnoozeResultSnoozed
};


@protocol CVEventSnoozeViewControllerDelegate;


@interface CVEventSnoozeViewController_iPhone : CVViewController
@property (nonatomic, weak  ) id<CVEventSnoozeViewControllerDelegate> delegate;
@property (nonatomic, strong) EKEvent                                 *event;
@end



@protocol CVEventSnoozeViewControllerDelegate <NSObject>
@required
- (void)eventSnoozeViewController:(CVEventSnoozeViewController_iPhone *)controller didFinishWithResult:(CVEventSnoozeResult)result;
@end
