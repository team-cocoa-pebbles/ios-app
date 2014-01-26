//
//  Settings.m
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "Settings.h"

@implementation Settings

@synthesize WeatherOn;

+ (Settings *)sharedSettings
{
    static Settings *sharedSettings;
    
    @synchronized(self)
    {
        if (!sharedSettings){
            sharedSettings = [[Settings alloc] init];
            /*self.WeatherOn = YES;
            self.TrafficOn = YES;
            self.FactsOn = TRUE;
            self.CalendarOn = TRUE;
            self.LunchOn = TRUE;
            self.QuotesOn = TRUE;*/
        }
        
        return sharedSettings;
    }
}

@end
