//
//  WeatherDataController.m
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "WeatherDataController.h"

@interface WeatherDataController () <NSURLConnectionDelegate>
@end

@implementation WeatherDataController

- (id)init
{
    self.weatherURLStr1 = @"http://api.openweathermap.org/data/2.5/weather?lat=";
    self.weatherURLStr2 = @"&lon=";
    //lock = [[NSLock alloc] init];
    semaphore = dispatch_semaphore_create(0);
    return self;
}

-(NSURLRequest *)connection:(NSURLConnection *)connection
                willSendRequest:(NSURLRequest *)request
                redirectResponse:(NSURLResponse *)redirectResponse
{
    NSURLRequest *newRequest = request;
    
    if (redirectResponse)
    {
        newRequest = nil;
    }
    return newRequest;
}

- (NSString*)retrieveData:(CLLocationCoordinate2D) coordinate
{
    NSLog(@"Retrieving weather data");
    NSURL *weatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%F%@%f", self.weatherURLStr1, coordinate.latitude, self.weatherURLStr2, coordinate.longitude]];
    NSLog(@"URL: %@", weatherURL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:weatherURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                     queue:queue
                     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
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
        NSLog(@"Dictionary: %@", root);
        if(jsonError){
            NSLog(@"JSON error: %@", jsonError);
            message = @"Error parsing response";
            showAlert();
        }
                         
        NSLog(@"JSON weather data loaded.");
        NSString *temperature = [[root objectForKey:@"main"] objectForKey:@"temp"];
        NSArray *weather = [root objectForKey:@"weather"];
        NSString *description = [[weather objectAtIndex:0] objectForKey:@"description"];

        NSLog(@"description: %@ temperature: %@", description, temperature);
                         
                         
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return @"yay";

    
}

@end
