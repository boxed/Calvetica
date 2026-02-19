//
//  CVEventSnoozeViewController_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, CVEventSnoozeResult) {
    CVEventSnoozeResultCancelled,
    CVEventSnoozeResultShowDetails,
    CVEventSnoozeResultSnoozed
};


@protocol CVEventSnoozeViewControllerDelegate;


@interface CVEventSnoozeViewController : CVViewController
@property (nonatomic, nullable, weak  ) id<CVEventSnoozeViewControllerDelegate> delegate;
@property (nonatomic, strong) EKEvent                                 *event;
@end



@protocol CVEventSnoozeViewControllerDelegate <NSObject>
@required
- (void)eventSnoozeViewController:(CVEventSnoozeViewController *)controller didFinishWithResult:(CVEventSnoozeResult)result;
@end

NS_ASSUME_NONNULL_END
