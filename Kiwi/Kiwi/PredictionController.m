//
//  PredictionController.m
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "PredictionController.h"
#import <EventKit/EventKit.h>

@interface PredictionController () <CLLocationManagerDelegate>

@end

@implementation PredictionController
{
    CLLocationManager *_locationManager;
    EKEventStore *_eventStore;
}

-(id)init
{
    self = [super init];
    counter = 0;
    // Set up the location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = 1.0 * 1000.0; // Move at least 1km until next location event is generated
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    self.weatherDataController = [[WeatherDataController alloc] init];
    self.trafficDataController = [[TrafficDataController alloc] init];
    self.twitterDataController = [[TwitterDataController alloc] init];
    self.calendarDataController = [[CalendarDataController alloc] init];
    
    return self;
}

-(NSDictionary*)initiatePredictions
{
    CLLocationCoordinate2D coordinate = _locationManager.location.coordinate;
    NSLog(@"Lat: %f Long: %f", coordinate.latitude, coordinate.longitude);
    
    NSDictionary *weatherUpdate = [self.weatherDataController retrieveData:coordinate];
    NSLog(@"Weather Update: %@", weatherUpdate);
    
    NSLog(@"Lat: %f Long: %f", coordinate.latitude, coordinate.longitude);
    
    CLLocationCoordinate2D coordinateT = _locationManager.location.coordinate;
    
    NSLog(@"T1: Lat: %f Long: %f", coordinateT.latitude, coordinateT.longitude);
    NSDictionary *trafficUpdate = [self.trafficDataController retrieveData:coordinateT];
    NSLog(@"Traffic Update: %@", trafficUpdate);
    
    NSDictionary *twitterUpdate = [self.twitterDataController retrieveData];
    
    NSLog(@"Quote Update: %@", twitterUpdate);
    
    NSDictionary *calendarUpdate = [self.calendarDataController retrieveData];
    
    NSDictionary *relevantUpdate;
    
    if((counter % 2) == 0){
         relevantUpdate = weatherUpdate;
    }
    /*else if((counter % 2) == 1){
        relevantUpdate = trafficUpdate;
    }
    else if((counter % 5) == 0){
        relevantUpdate = twitterUpdate;
    }*/
    counter++;
    
    NSLog(@"Update chosen: %@", relevantUpdate);
    return relevantUpdate;
}

@end
