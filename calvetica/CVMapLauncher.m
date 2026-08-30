//
//  CVMapLauncher.m
//  calvetica
//

#import "CVMapLauncher.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface CVMapLauncher () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLGeocoder        *geocoder;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation        *routeDestination;
@property (nonatomic, strong) NSString          *routeDestinationName;
@end


@implementation CVMapLauncher

+ (CVMapLauncher *)shared
{
    static CVMapLauncher *launcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        launcher = [[CVMapLauncher alloc] init];
    });
    return launcher;
}

+ (NSString *)nameForMapApp:(CVMapApp)mapApp
{
    switch (mapApp) {
        case CVMapAppGoogle:  return @"Google Maps";
        case CVMapAppOrganic: return @"Organic Maps";
        case CVMapAppApple:
        default:              return @"Apple Maps";
    }
}


#pragma mark - Public

+ (void)openLocation:(NSString *)location
{
    NSString *query = [self encodedQuery:location];
    if (query.length == 0) return;

    NSURL *url = nil;
    switch (PREFS.defaultMapApp) {
        case CVMapAppGoogle:
            if ([self canOpenScheme:@"comgooglemaps://"]) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@", query]];
            }
            else {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%@", query]];
            }
            break;
        case CVMapAppOrganic:
            if ([self canOpenScheme:@"om://"]) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"om://search?query=%@", query]];
            }
            // Organic Maps has no web version to fall back to.
            else {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.apple.com/?q=%@", query]];
            }
            break;
        case CVMapAppApple:
        default:
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.apple.com/?q=%@", query]];
            break;
    }
    [self openURL:url];
}

+ (void)routeToLocation:(NSString *)location
{
    NSString *query = [self encodedQuery:location];
    if (query.length == 0) return;

    NSURL *url = nil;
    switch (PREFS.defaultMapApp) {
        case CVMapAppGoogle:
            if ([self canOpenScheme:@"comgooglemaps://"]) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?daddr=%@", query]];
            }
            else {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/maps/dir/?api=1&destination=%@", query]];
            }
            break;
        case CVMapAppOrganic:
            if ([self canOpenScheme:@"om://"]) {
                // Organic Maps' route URL needs coordinates for both ends, so this
                // resolves the address and the user's position asynchronously first.
                [[self shared] routeWithOrganicMapsToLocation:location];
                return;
            }
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.apple.com/?daddr=%@", query]];
            break;
        case CVMapAppApple:
        default:
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.apple.com/?daddr=%@", query]];
            break;
    }
    [self openURL:url];
}


#pragma mark - Private

+ (NSString *)encodedQuery:(NSString *)location
{
    NSString *flattened = [[location stringByReplacingOccurrencesOfString:@"\n" withString:@", "]
                           stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // Encode everything but unreserved characters so "&", "?", "+" etc. in
    // addresses survive as query values.
    NSCharacterSet *unreserved = [NSCharacterSet characterSetWithCharactersInString:
                                  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"];
    return [flattened stringByAddingPercentEncodingWithAllowedCharacters:unreserved];
}

+ (BOOL)canOpenScheme:(NSString *)scheme
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]];
}

+ (void)openURL:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}


#pragma mark - Organic Maps routing

- (void)routeWithOrganicMapsToLocation:(NSString *)location
{
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    if (self.geocoder.geocoding) {
        [self.geocoder cancelGeocode];
    }
    [self.geocoder geocodeAddressString:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        CLLocation *destination = [placemarks firstObject].location;
        if (!destination) {
            [self fallBackToOrganicSearch:location];
            return;
        }
        self.routeDestination = destination;
        self.routeDestinationName = location;
        [self requestCurrentLocation];
    }];
}

- (void)requestCurrentLocation
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    switch (self.locationManager.authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            // locationManagerDidChangeAuthorization: continues once the user answers.
            [self.locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self fallBackToOrganicSearch:self.routeDestinationName];
            break;
        default:
            [self.locationManager requestLocation];
            break;
    }
}

- (void)openOrganicRouteFrom:(CLLocation *)start
{
    CLLocation *destination = self.routeDestination;
    NSString *name = [CVMapLauncher encodedQuery:self.routeDestinationName];
    self.routeDestination = nil;
    self.routeDestinationName = nil;
    if (!destination) return;

    NSString *stringURL = [NSString stringWithFormat:@"om://route?sll=%f,%f&saddr=%@&dll=%f,%f&daddr=%@&type=vehicle",
                           start.coordinate.latitude, start.coordinate.longitude,
                           [CVMapLauncher encodedQuery:NSLocalizedString(@"My Position", @"Route start label sent to Organic Maps.")],
                           destination.coordinate.latitude, destination.coordinate.longitude,
                           name];
    [CVMapLauncher openURL:[NSURL URLWithString:stringURL]];
}

- (void)fallBackToOrganicSearch:(NSString *)location
{
    self.routeDestination = nil;
    self.routeDestinationName = nil;
    NSString *query = [CVMapLauncher encodedQuery:location];
    if (query.length == 0) return;
    [CVMapLauncher openURL:[NSURL URLWithString:[NSString stringWithFormat:@"om://search?query=%@", query]]];
}


#pragma mark CLLocationManagerDelegate

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager
{
    if (!self.routeDestination) return;
    switch (manager.authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self fallBackToOrganicSearch:self.routeDestinationName];
            break;
        default:
            [manager requestLocation];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (!self.routeDestination) return;
    CLLocation *current = [locations lastObject];
    if (current) {
        [self openOrganicRouteFrom:current];
    }
    else {
        [self fallBackToOrganicSearch:self.routeDestinationName];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (!self.routeDestination) return;
    [self fallBackToOrganicSearch:self.routeDestinationName];
}

@end
