//
//  TrafficDataController.m
//  Kiwi
//
//  Created by Laurence Wong on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "TrafficDataController.h"

@implementation TrafficDataController

- (id)init
{
    self = [super init];
    if (self) {
        self.trafficURLStr1 = @"http://dev.virtualearth.net/REST/v1/Traffic/Incidents/";
        self.trafficURLStr2 = @"?key=Ag7zBcnhLP6EOOlh_hNBGVgHRXrkClUVOZu3LIKePOOm76-JcJsqecDlP5UfUanB";
        semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (NSString*)retrieveData:(CLLocationCoordinate2D) bottomLeft and:(CLLocationCoordinate2D)topRight
{
    /*bottomLeft.latitude = 37;
    bottomLeft.longitude = -105;
    topRight.latitude = 45;
    topRight.longitude = -94;*/
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
        NSLog(@"%@", root);
        @try {
            if (jsonError == nil && root) {
                /*// TODO: type checking / validation, this is really dangerous...
                 NSDictionary *firstListItem = [root[@"list"] objectAtIndex:0];
                 NSDictionary *main = firstListItem[@"main"];
                 
                 // Get the temperature:
                 NSNumber *temperatureNumber = main[@"temp"]; // in degrees Kelvin
                 int temperature = [temperatureNumber integerValue] - 273.15;
                 
                 // Get weather icon:
                 NSNumber *weatherIconNumber = firstListItem[@"weather"][0][@"icon"];
                 uint8_t weatherIconID = 2;
                 
                 // Send data to watch:
                 // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definitions on the watch's end:
                 NSNumber *iconKey = @(0); // This is our custom-defined key for the icon ID, which is of type uint8_t.
                 NSNumber *temperatureKey = @(1); // This is our custom-defined key for the temperature string.
                 NSDictionary *update = @{ iconKey:[NSNumber numberWithUint8:weatherIconID],
                 temperatureKey:[NSString stringWithFormat:@"%d\u00B0C", temperature] };
                 [_targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
                 message = error ? [error localizedDescription] : @"Update sent!";
                 showAlert();
                 }];
                 return;*/
            }
        }
        @catch (NSException *exception) {
            NSLog(@"JSON error: %@", jsonError);
            message = @"Error parsing response";
            showAlert();
        }
        
        NSArray *resourceSets = [root objectForKey:@"resourceSets"];
        
        NSDictionary *resourceSetDictionary = [resourceSets objectAtIndex:0];
        
        NSArray *resourcesArray = [resourceSetDictionary objectForKey:@"resources"];
        
        self.resourcesProperty = [[NSMutableArray alloc] init];
        for(int i = 0; i < [resourcesArray count]; ++i)
        {
            NSDictionary *resourcesDictionary = [resourcesArray objectAtIndex:i];
            [self.resourcesProperty addObject:resourcesDictionary];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return @"yay";
}


@end
