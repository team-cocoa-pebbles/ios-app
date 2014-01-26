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
{
    NSLock *lock;
    int lastSentIncident;
    CLLocationCoordinate2D lastKnownPosition;
}
@property NSString *trafficURLStr1;
@property NSString *trafficURLStr2;
@property NSMutableArray *resourcesProperty;

- (NSString*)retrieveData:(CLLocationCoordinate2D) currentPosition;
- (NSString*)getMostRelevantTraffic;
- (NSString*)findStreetNamesInDescription:(NSString *) description;
@end
