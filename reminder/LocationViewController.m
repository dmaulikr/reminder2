//
//  LocationViewController.m
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"
#import "Annotation.h"
#import <CoreLocation/CoreLocation.h>


@interface LocationViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationMenager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) CLLocationDegrees *cordinates;
@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationMenager = [[CLLocationManager alloc] init];
    self.locationMenager.delegate = self;
    self.locationMenager.distanceFilter = kCLDistanceFilterNone;
    self.locationMenager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationMenager requestWhenInUseAuthorization];
    self.location = [[Location alloc] init];
    self.mapView.delegate = self;
    [self loadLastLocation];
}
-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(IBAction)currentLocation:(id)sender
{
    [self.locationMenager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation)
    {
        self.location.longnitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.location.latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    CLLocationDegrees latitude = [self.location.latitude doubleValue];
    CLLocationDegrees lognitude = [self.location.longnitude doubleValue];
    CLLocationCoordinate2D cordinates = CLLocationCoordinate2DMake(latitude, lognitude);
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = cordinates;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    [self.locationMenager stopUpdatingLocation];
    [self.mapView addAnnotation:point];
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.mapView.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = self.mapView.frame.size;
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error)
    {
        UIImage *image = snapshot.image;
        [self.delegate locationUpdated:self.location imageDraw:image];
    }];
}
-(void)loadLastLocation
{
    NSLog(@"loading last location... %@", self.location);
}

-(IBAction)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         [self.locationMenager stopUpdatingLocation];
     }];
}
@end
