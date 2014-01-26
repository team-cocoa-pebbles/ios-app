//
//  PredictionController.m
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "PredictionController.h"

@interface PredictionController () <CLLocationManagerDelegate>

@end

@implementation PredictionController
{
    CLLocationManager *_locationManager;
}

-(id)init
{
    self = [super init];
    
    // Set up the location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = 1.0 * 1000.0; // Move at least 1km until next location event is generated
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    self.weatherDataController = [[WeatherDataController alloc] init];
    self.trafficDataController = [[TrafficDataController alloc] init];
    
    return self;
}

-(void)initiatePredictions
{
    [self updateData];
}

-(void)updateData
{
    CLLocationCoordinate2D coordinate = _locationManager.location.coordinate;
    NSLog(@"Lat: %f Long: %f", coordinate.latitude, coordinate.longitude);
    
    NSString *message = [self.weatherDataController retrieveData:coordinate];
    NSLog(@"%@", message);
    
    CLLocationCoordinate2D coordinateT1 = _locationManager.location.coordinate;
    coordinateT1.latitude -= 0.01;
    coordinateT1.longitude += 0.01;
    CLLocationCoordinate2D coordinateT2 = _locationManager.location.coordinate;
    coordinateT2.latitude += 0.01;
    coordinateT2.longitude -= 0.01;
 /*
    coordinateT1.latitude = -0.01;
    coordinateT1.longitude = 0.01;
    CLLocationCoordinate2D coordinateT2 = _locationManager.location.coordinate;
    coordinateT2.latitude = 0.01;
    coordinateT2.longitude = -0.01;
*/
    NSLog(@"T1: Lat: %f Long: %f", coordinateT1.latitude, coordinateT1.longitude);
        NSLog(@"T2: Lat: %f Long: %f", coordinateT2.latitude, coordinateT2.longitude);
    NSMutableArray *resources;
    message = [self.trafficDataController retrieveData:coordinateT1 and:coordinateT2];
    resources = [self.trafficDataController resourcesProperty];
    NSLog(@"%@", message);
}



@end
