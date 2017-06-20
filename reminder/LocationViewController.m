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
#import "Singleton.h"
#import "LocationC+CoreDataClass.h"
#import "AnnotationView.h"


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
    self.locationMenager.distanceFilter = 100;
    self.locationMenager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationMenager requestWhenInUseAuthorization];
    self.location = [[Location alloc] init];
    self.mapView.delegate = self;
    if (self.taskForLocation)
    {
        [self loadLocations:self.taskForLocation];
    }
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
    [self.locationMenager stopUpdatingLocation];
    
    Location *loca = [[Location alloc] init];
    loca.latitude = [NSString stringWithFormat:@"%f", latitude];
    loca.longnitude = [NSString stringWithFormat:@"%f", lognitude];
    [self reverseGeocodelocation:loca];
    TaskC *task = self.taskForLocation;
    self.actionLocationAdded = ^
    {
        Singleton *instance = [Singleton sharedInstance];
        [instance.coreData
         addLocationWithLatitude:loca.latitude
                                      andLognitude:loca.longnitude forTask:task];
    };
    [self zoomToCoordinate:cordinates];
}
-(IBAction)doneAction:(id)sender
{
    if (self.actionLocationAdded)
    {
        self.actionLocationAdded();
    }
    [self dismissViewControllerAnimated:YES completion:^
     {
         [self.locationMenager stopUpdatingLocation];
     }];
}
- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateSpan span;
    span.latitudeDelta = .004;
    span.longitudeDelta = .004;
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}
-(void)loadLocations:(TaskC *)task
{
    NSSet *set = task.locations;
    NSArray *locationsArray = [set allObjects];
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <[locationsArray count]; i++)
    {
        LocationC *location = (LocationC *)locationsArray[i];
        Location *object = [[Location alloc] init];
        object.latitude = location.latitude;
        object.longnitude = location.longnitude;
        [mArray addObject:object];
    }
    Location *loc = [mArray firstObject];
    if (loc)
    {
       [self zoomToRegion:loc];
    }
    for (Location *location in mArray)
    {
        [self reverseGeocodelocation:location];
    }
}
- (void)zoomToRegion:(Location *)location
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [location.latitude doubleValue];
    coordinate.longitude = [location.longnitude doubleValue];
    MKCoordinateSpan span;
    span.latitudeDelta = .07;
    span.longitudeDelta = .07;
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}
- (void)reverseGeocodelocation:(Location *)location
{
    CLLocation *locat = [[CLLocation alloc] initWithLatitude:[location.latitude doubleValue] longitude:[location.longnitude doubleValue]];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locat completionHandler:^(NSArray *placemarks, NSError *error)
    {
        NSLog(@"Finding address");
        if (error)
        {
            NSLog(@"Error %@", error.description);
        } else
        {
            CLPlacemark *placemark = [placemarks lastObject];
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D myCoordinate;
            myCoordinate.latitude = [location.latitude doubleValue];
            myCoordinate.longitude = [location.longnitude doubleValue];
            annotation.coordinate = myCoordinate;
            annotation.title = placemark.subLocality;
            annotation.subtitle = placemark.name;
            [self.mapView addAnnotation:annotation];
            NSLog(@"new location %@", placemark.name);
        }
    }];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    AnnotationView *annotationView = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CallOutAnnotationVifew"];
    
    NSArray *arry = [[NSBundle mainBundle] loadNibNamed:@"AnnotationView" owner:self options:nil];
    
    UIView *view1 = [arry objectAtIndex:0];
    
    [annotationView.contentView addSubview:view1];
    
 
    return annotationView;
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}
@end
