//
//  CalendarDataController.h
//  Kiwi
//
//  Created by Laurence Wong on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "DataController.h"
#import <EventKit/EventKit.h>
#import <PebbleKit/PebbleKit.h>

@interface CalendarDataController : DataController
{
    EKEventStore* eventStore;
    NSDateFormatter* dateFormatter;
}
- (NSDictionary*)retrieveData:(NSDictionary*) dictionary;

@end
