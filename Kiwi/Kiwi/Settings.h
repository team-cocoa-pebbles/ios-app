//
//  Settings.h
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (assign) BOOL weatherOn;
@property (assign) BOOL trafficOn;
@property (assign, nonatomic) BOOL FactsOn;
@property (assign, nonatomic) BOOL CalendarOn;
@property (assign, nonatomic) BOOL LunchOn;
@property (assign, nonatomic) BOOL QuotesOn;

+ (Settings *)sharedSettings;
@end
