//
//  TrafficDataController.h
//  Kiwi
//
//  Created by Laurence Wong on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "DataController.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TrafficDataController : DataController

@property NSString *trafficURLStr1;
@property NSString *trafficURLStr2;
@property NSMutableArray *resourcesProperty;

- (NSString*)retrieveData:(CLLocationCoordinate2D) bottomLeft and:(CLLocationCoordinate2D) topRight;
@end
