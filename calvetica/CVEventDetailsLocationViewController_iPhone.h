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

typedef NS_ENUM(NSUInteger, CVEventDetailsLocationResult) {
    CVEventDetailsLocationResultDone,
    CVEventDetailsLocationResultSaved,
    CVEventDetailsLocationResultCancelled
};

@protocol CVEventDetailsLocationViewControllerDelegate;

@interface CVEventDetailsLocationViewController_iPhone : CVViewController  <MKMapViewDelegate> {
    BOOL showAlerts;
}

@property (nonatomic, weak  )          id<CVEventDetailsLocationViewControllerDelegate> delegate;
@property (nonatomic, strong)          EKEvent                                          *event;
@property (nonatomic, strong)          CLGeocoder                                       *geocoder;

@property (nonatomic, weak  ) IBOutlet UITextView                                       *locationTextView;
@property (nonatomic, weak  ) IBOutlet MKMapView                                        *mapView;
@property (nonatomic, weak  ) IBOutlet UIActivityIndicatorView                          *activityIndicator;


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
- (void)eventDetailsLocationViewController:(CVEventDetailsLocationViewController_iPhone *)controller didFinish:(CVEventDetailsLocationResult)result;
@end