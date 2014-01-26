//
//  WeatherDataController.h
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PebbleKit/PebbleKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DataController.h"

@interface WeatherDataController : DataController

@property NSString *weatherURLStr1;
@property NSString *weatherURLStr2;
@property NSMutableData *weatherData;

- (NSDictionary*)retrieveData:(CLLocationCoordinate2D) coordinate;

@end
