//
//  CVTimeZoneViewController.h
//  calvetica
//
//  Created by Adam Kirk on 10/2/13.
//
//

#import <UIKit/UIKit.h>


@protocol CVTimeZoneViewControllerDelegate;


@interface CVTimeZoneViewController : UIViewController
@property (nonatomic, weak  ) id<CVTimeZoneViewControllerDelegate> delegate;
@property (nonatomic, strong) NSTimeZone                           *selectedTimeZone;
@end


@protocol CVTimeZoneViewControllerDelegate <NSObject>
- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didToggleSupportOn:(BOOL)isOn;
- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didSelectTimeZone:(NSTimeZone *)timeZone;
@end