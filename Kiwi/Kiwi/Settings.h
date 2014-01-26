//
//  Settings.h
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property BOOL WeatherOn;
@property BOOL TrafficOn;
@property BOOL FactsOn;
@property BOOL CalendarOn;
@property BOOL LunchOn;
@property BOOL QuotesOn;

+ (Settings *)sharedSettings;
@end
