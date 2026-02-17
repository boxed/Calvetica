//
//  CVTimeZoneViewController.h
//  calvetica
//
//  Created by Adam Kirk on 10/2/13.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol CVTimeZoneViewControllerDelegate;


@interface CVTimeZoneViewController : UIViewController
@property (nonatomic, nullable, weak  ) id<CVTimeZoneViewControllerDelegate> delegate;
@property (nonatomic, strong) NSTimeZone                           *selectedTimeZone;
@property (nonatomic, assign) BOOL                                 showsDoneButton;
@end


@protocol CVTimeZoneViewControllerDelegate <NSObject>
- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didToggleSupportOn:(BOOL)isOn;
- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didSelectTimeZone:(NSTimeZone *)timeZone;
@end

NS_ASSUME_NONNULL_END