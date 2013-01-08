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

typedef enum {
    CVEventDetailsLocationResultDone,
    CVEventDetailsLocationResultSaved,
    CVEventDetailsLocationResultCancelled
} CVEventDetailsLocationResult;

@protocol CVEventDetailsLocationViewControllerDelegate;

@interface CVEventDetailsLocationViewController_iPhone : CVViewController  <MKMapViewDelegate> {
    BOOL showAlerts;
}

#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVEventDetailsLocationViewControllerDelegate> delegate;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) CLGeocoder *geocoder;

#pragma mark IBOutlets
@property (nonatomic, strong) IBOutlet UITextView *locationTextView;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;


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