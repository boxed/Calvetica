//
//  CVEventDetailsLocationViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/9/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "strings.h"
#import "CVViewController.h"
#import "CVNativeAlertView.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, CVEventDetailsLocationResult) {
    CVEventDetailsLocationResultDone,
    CVEventDetailsLocationResultSaved,
    CVEventDetailsLocationResultCancelled
};

@protocol CVEventDetailsLocationViewControllerDelegate;

@interface CVEventDetailsLocationViewController : CVViewController  <MKMapViewDelegate> {
    BOOL showAlerts;
}

@property (nonatomic, nullable, weak  )          id<CVEventDetailsLocationViewControllerDelegate> delegate;
@property (nonatomic, strong)          EKEvent                                          *event;
@property (nonatomic, strong)          CLGeocoder                                       *geocoder;

@property (nonatomic, nullable, weak  ) IBOutlet UITextView                                       *locationTextView;
@property (nonatomic, nullable, weak  ) IBOutlet MKMapView                                        *mapView;
@property (nonatomic, nullable, weak  ) IBOutlet UIActivityIndicatorView                          *activityIndicator;


#pragma mark - Methods
- (void)clearMapViewAnnotations;
- (BOOL)placemarkForCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)showLocationDisplayAlerts:(BOOL)displayAlerts;
- (void)showUserLocation;

#pragma mark IBActions
- (IBAction)showLocationButtonWasTapped:(id)sender;

@end

@protocol CVEventDetailsLocationViewControllerDelegate <NSObject>
@required
- (void)eventDetailsLocationViewController:(CVEventDetailsLocationViewController *)controller didFinish:(CVEventDetailsLocationResult)result;
@end

NS_ASSUME_NONNULL_END