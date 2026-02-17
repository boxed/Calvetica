//
//  CVEventDetailsLocationViewController_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 5/9/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsLocationViewController.h"
#import <Contacts/Contacts.h>


@implementation CVEventDetailsLocationViewController {
    MKPinAnnotationView *_mapPin;
}

- (void)dealloc
{
    [_mapPin removeObserver:self forKeyPath:@"selected"];
    _mapView.delegate = nil;
}


#pragma mark - Methods

- (void)clearMapViewAnnotations 
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
}

- (void)hideKeyboard 
{
    [_locationTextView resignFirstResponder];
}

- (void)mapViewWasPressed:(UIGestureRecognizer *)gestureRecognizer 
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D mapCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        [self placemarkForCoordinate:mapCoordinate];
    }
}

- (BOOL)placemarkForCoordinate:(CLLocationCoordinate2D)coordinate 
{
    if (!self.geocoder.geocoding) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                if (placemarks) {
                    [self clearMapViewAnnotations];
                    for (CLPlacemark *placemark in placemarks) {
                        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                        annotation.coordinate = placemark.location.coordinate;
                        CNPostalAddressFormatter *formatter = [[CNPostalAddressFormatter alloc] init];
                        NSString *addressString = placemark.postalAddress ? [formatter stringFromPostalAddress:placemark.postalAddress] : placemark.name;
                        annotation.title = [addressString stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
                        annotation.subtitle = placemark.country;
                        [self.mapView addAnnotation:annotation];
                        self.locationTextView.text = addressString;
                    }
                }
            }
            else {
                NSString *message = nil;
                if (error.code == kCLErrorGeocodeFoundNoResult) {
                    message = NSLocalizedString(@"We couldn't find an address for the location.", @"Error message displayed when the location screen can't find an address for the user's tap.");
                }
                else {
                    message = NSLocalizedString(@"There was a connection problem.", @"Error message displayed when the location screen fails to make a connection.");
                }
                [CVNativeAlertView showWithTitle:ALERT_TITLE_INFO message:message cancelButtonTitle:OK];
            }
        }];
            return YES;
        }
    
    return NO;
}


- (void)showLocationDisplayAlerts:(BOOL)displayAlerts 
{
    if ([self.locationTextView.text length] > 0) {
        showAlerts = displayAlerts;
        
        [self.activityIndicator startAnimating];
        if (!self.geocoder.geocoding) {
            [self.geocoder geocodeAddressString:self.locationTextView.text completionHandler:^(NSArray *placemarks, NSError *error) {
                if (!error) {
                    if (placemarks) {
                        [self clearMapViewAnnotations];
                        for (CLPlacemark *placemark in placemarks) {
                            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                            annotation.coordinate = placemark.location.coordinate;
                            CNPostalAddressFormatter *formatter = [[CNPostalAddressFormatter alloc] init];
                            annotation.title = placemark.postalAddress ? [[formatter stringFromPostalAddress:placemark.postalAddress] stringByReplacingOccurrencesOfString:@"\n" withString:@", "] : placemark.name;
                            annotation.subtitle = placemark.country;
                            [self.mapView addAnnotation:annotation];
                            MKCoordinateSpan span = MKCoordinateSpanMake(0.2f, 0.2f);
                            MKCoordinateRegion region = MKCoordinateRegionMake(placemark.location.coordinate, span);
                            [self.mapView setRegion:region animated:YES];
                        }
                    }
                }
                else {
                    NSString *message = nil;
                    if (error.code == kCLErrorGeocodeFoundNoResult) {
                        message = NSLocalizedString(@"We couldn't find an address for the location.", @"Error message displayed when the location screen can't find an address for the user's tap.");
                    }
                    else {
                        message = NSLocalizedString(@"There was a connection problem.", @"Error message displayed when the location screen fails to make a connection.");
                    }
                    [CVNativeAlertView showWithTitle:ALERT_TITLE_INFO message:message cancelButtonTitle:OK];
                }
                [self.locationTextView resignFirstResponder];
                [self.activityIndicator stopAnimating];
            }];
        }
    }
}

- (void)showUserLocation 
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2f, 0.2f);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span);
    
    [self.mapView setRegion:region animated:YES];
}




#pragma mark IBActions

- (void)accessoryViewCloseButtonTapped:(id)sender 
{
    [super accessoryViewCloseButtonTapped:sender];
    
    if (![_locationTextView.text isEqualToString:_event.location]) {
        [self clearMapViewAnnotations];
    }
}

- (void)showLocationButtonWasTapped:(id)sender
{
    [self showLocationDisplayAlerts:YES];
}

- (void)cancelButtonTapped:(id)sender
{
    [self.delegate eventDetailsLocationViewController:self didFinish:CVEventDetailsLocationResultCancelled];
}

- (void)doneButtonTapped:(id)sender
{
    self.event.location = self.locationTextView.text;
    [self.delegate eventDetailsLocationViewController:self didFinish:CVEventDetailsLocationResultSaved];
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation 
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        // Return nil so the system can handle the user's location itself.
        return nil;
    }
    
    _mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title];
    _mapPin.pinColor = MKPinAnnotationColorRed;
    _mapPin.animatesDrop = YES;
    _mapPin.canShowCallout = YES;
    _mapPin.enabled = YES;
    _mapPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [_mapPin addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:@"GMAP_ANNOTATION_SELECTED"];
	
	return _mapPin;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation 
{
    // Only update the user's location if there's no location set.
    if ([self.locationTextView.text length] == 0) {
        [self showUserLocation];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSString *action = (__bridge NSString*)context;
	
	// We only want to zoom to location when the annotation is actaully selected. This will trigger also for when it's deselected
	if([[change valueForKey:@"new"] intValue] == 1 && [action isEqualToString:@"GMAP_ANNOTATION_SELECTED"]) 
	{
		if([((MKAnnotationView*) object).annotation isKindOfClass:[MKPointAnnotation class]])
		{
			MKPointAnnotation *place = ((MKAnnotationView*) object).annotation;
			
			// Zoom into the location
            MKCoordinateSpan span = MKCoordinateSpanMake(0.2f, 0.2f);
            MKCoordinateRegion region = MKCoordinateRegionMake(place.coordinate, span);
			[_mapView setRegion:region animated:TRUE];
		}
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control 
{
    NSString *title = [view.annotation.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Open in\u2026"
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Apple Maps" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *stringURL = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", title];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Google Maps" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", title];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            stringURL = [NSString stringWithFormat:@"comgooglemaps://?q=%@", title];
        }
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    // For iPad, set the popover source
    actionSheet.popoverPresentationController.sourceView = view.superview;
    actionSheet.popoverPresentationController.sourceRect = view.frame;

    [self presentViewController:actionSheet animated:YES completion:nil];

}

#pragma mark UIView

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Location";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];

    _locationTextView.inputAccessoryView = self.keyboardAccessoryView;
    _locationTextView.text = _event.location;
    _mapView.showsUserLocation = YES;
	_mapView.delegate = self;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    // Capture touch events on the map view. We'll add pins if the user presses a region of the map.
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewWasPressed:)];
    gestureRecognizer.minimumPressDuration = 0.5f;
    [self.mapView addGestureRecognizer:gestureRecognizer];
    
    if ([_locationTextView.text length] != 0) {
        [self showLocationDisplayAlerts:NO];
    } else if (_mapView.userLocation.location) {
        [self showUserLocation];
    }
    
    if ([self.locationTextView.text length] == 0) {
        [_locationTextView becomeFirstResponder];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
