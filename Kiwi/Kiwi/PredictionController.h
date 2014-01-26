//
//  PredictionController.h
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherDataController.h"
#import "TrafficDataController.h"
#import "TwitterDataController.h"
#import "CalendarDataController.h"

@interface PredictionController : NSObject

@property (strong, nonatomic) WeatherDataController *weatherDataController;
@property (strong, nonatomic) TrafficDataController *trafficDataController;
@property (strong, nonatomic) TwitterDataController *twitterDataController;
@property (strong, nonatomic) CalendarDataController *calendarDataController;

-(NSDictionary*)initiatePredictions;

@end
