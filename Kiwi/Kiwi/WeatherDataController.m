//
//  WeatherDataController.m
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "WeatherDataController.h"

@implementation WeatherDataController

- (id)init
{
    self.weatherURLStr1 = @"http://api.openweathermap.org/data/2.5/weather?lat=";
    self.weatherURLStr2 = @"lon=";
    
    return self;
}

- (NSString*)retrieveData:(CLLocationCoordinate2D) coordinate
{
    
    NSLog(@"Retrieving weather data");
    NSURL *weatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%F%@%f", self.weatherURLStr1, coordinate.latitude, self.weatherURLStr2, coordinate.longitude]];

    NSData *data = [[NSData alloc] initWithContentsOfURL:weatherURL];
    if(!data){
        NSLog(@"Error loading weather JSON");
        return nil;
    }
    NSError *error;
    // Line below is broken!
    NSDictionary *weatherData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(!weatherData){
        NSLog(@"Weather data dictionary is null: %@", [error localizedDescription]);
        return nil;
    }
    
    // Check for error or non-OK statusCode:
    if (error) {
        NSLog(@"Error loading weather data dictionary: %@", [error localizedDescription]);
        [[[UIAlertView alloc] initWithTitle:nil message:@"Error fetching weather" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return nil;
    }
    else {
        NSLog(@"JSON weather data loaded.");
        NSLog(@"%@", weatherData);
    }
    
    // Parse user data
    NSString *description = weatherData[@"weather"][@"description"];
    NSString *temperature = weatherData[@"main"][@"temp"];
    
    NSLog(@"description: %@ temperature: %@", description, temperature);
    
    return @"yay";
}

@end
