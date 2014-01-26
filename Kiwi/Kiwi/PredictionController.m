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
    NSLog([NSString stringWithFormat:@"%@", message]);
}



@end
