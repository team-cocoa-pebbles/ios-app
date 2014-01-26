//
//  TrafficDataController.m
//  Kiwi
//
//  Created by Laurence Wong on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "TrafficDataController.h"

@implementation TrafficDataController{
    NSString* relevantTrafficStr;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.trafficURLStr1 = @"http://dev.virtualearth.net/REST/v1/Traffic/Incidents/";
        self.trafficURLStr2 = @"?key=Ag7zBcnhLP6EOOlh_hNBGVgHRXrkClUVOZu3LIKePOOm76-JcJsqecDlP5UfUanB";
        semaphore = dispatch_semaphore_create(0);
        lastSentIncident = 0;
    }
    return self;
}

- (NSDictionary*)retrieveData:(CLLocationCoordinate2D) currentPosition
{
    lastKnownPosition = currentPosition;
    CLLocationCoordinate2D bottomLeft, topRight;
    bottomLeft = currentPosition;
    topRight = currentPosition;
    bottomLeft.latitude = 37;
    bottomLeft.longitude = -105;
    topRight.latitude = 45;
    topRight.longitude = -94;
    
    bottomLeft.latitude -= 0.01;
    bottomLeft.longitude += 0.01;
    topRight.latitude += 0.01;
    topRight.longitude -= 0.01;
    
    NSURL *weatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%f,%f,%f,%f%@", self.trafficURLStr1, bottomLeft.latitude, bottomLeft.longitude, topRight.latitude, topRight.longitude, self.trafficURLStr2]];
    NSURLRequest *request = [NSURLRequest requestWithURL:weatherURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = nil;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            httpResponse = (NSHTTPURLResponse *) response;
        }
        
        // NSURLConnection's completionHandler is called on the background thread.
        // Prepare a block to show an alert on the main thread:
        __block NSString *message = @"";
        void (^showAlert)(void) = ^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        };
        
        // Check for error or non-OK statusCode:
        if (error || httpResponse.statusCode != 200) {
            message = @"Error fetching weather";
            NSLog(@"URL error: %@", error);
            showAlert();
            return;
        }
        
        // Parse the JSON response:
        NSError *jsonError = nil;
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        //NSLog(@"%@", root);
        
        NSArray *resourceSets = [root objectForKey:@"resourceSets"];
        
        NSDictionary *resourceSetDictionary = [resourceSets objectAtIndex:0];
        
        NSArray *resourcesArray = [resourceSetDictionary objectForKey:@"resources"];
        
        self.resourcesProperty = [[NSMutableArray alloc] init];
        for(int i = 0; i < [resourcesArray count]; ++i)
        {
            NSDictionary *resourcesDictionary = [resourcesArray objectAtIndex:i];
            [self.resourcesProperty addObject:resourcesDictionary];
        }
        relevantTrafficStr = [self getMostRelevantTraffic];
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    NSNumber *trafficKey = @(2); // This is our custom-defined key for the icon ID, which is of type uint8_t.
    NSDictionary *update = @{trafficKey:relevantTrafficStr };
    return update;
}

- (float) distanceBetween:(CGPoint) x and:(CGPoint) y
{
    return sqrtf((powf((x.x - y.x), 2.0) + powf((x.y - y.y), 2.0)));
}

- (NSString*)getMostRelevantTraffic
{
    //Severity:
    /*
     1: LowImpact
     2: Minor
     3: Moderate
     4: Serious
     */
    //Type:
    /*
     1: Accident
     2: Congestion
     3: DisabledVehicle
     4: MassTransit
     5: Miscellaneous
     6: OtherNews
     7: PlannedEvent
     8: RoadHazard
     9: Construction
     10: Alert
     11: Weather
     */
    if([self.resourcesProperty count] > 0)
    {
        int i = 0;
        float distance = MAXFLOAT;
        int highestScoreIndex = 0;
        for(NSDictionary *resourcesDictionary in self.resourcesProperty)
        {
            NSDictionary *point = [resourcesDictionary objectForKey:@"point"];
            NSArray *coordinates = [point objectForKey:@"coordinates"];
            NSNumber *trafficLatitude, *trafficLongitude;
            trafficLatitude = [coordinates objectAtIndex:0];
            trafficLongitude = [coordinates objectAtIndex:1];
            
            float distanceFromDriver = [self distanceBetween:CGPointMake(lastKnownPosition.latitude, lastKnownPosition.longitude) and:CGPointMake([trafficLatitude floatValue], [trafficLongitude floatValue])];
            
            if(distance > distanceFromDriver){
                distance = distanceFromDriver;
                highestScoreIndex = i;
            }

            ++i;
        }
        NSDictionary *highestScoringEvent = [self.resourcesProperty objectAtIndex:highestScoreIndex];
        NSString *highestScoringEventDescription = [highestScoringEvent objectForKey:@"description"];
        return [self findStreetNamesInDescription:highestScoringEventDescription];
    }
    return @"EMPTY";
}

- (NSString *)findStreetNamesInDescription:(NSString *)description
{
    NSArray *tokenizedDescription = [description componentsSeparatedByString:@" -"];
    return [tokenizedDescription objectAtIndex:0];
}




@end
