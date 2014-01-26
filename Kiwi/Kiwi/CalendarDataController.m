//
//  CalendarDataController.m
//  Kiwi
//
//  Created by Laurence Wong on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "CalendarDataController.h"

@implementation CalendarDataController


- (id)init
{
    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm/dd/yyyy"];
        
        eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            //Handle access here
        }];
    }
    return self;
}

- (NSDictionary*)retrieveData
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Create the start date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = 0;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *oneWeekFromNowComponents = [[NSDateComponents alloc] init];
    oneWeekFromNowComponents.week = 1;
    NSDate *oneWeekFromNow = [calendar dateByAddingComponents:oneWeekFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:oneDayAgo
                                                                 endDate:oneWeekFromNow
                                                               calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    
    EKEvent *firstEvent = [events objectAtIndex:0];
    NSDate *firstEventDate = [firstEvent startDate];
    NSString* firstEventDateString = [dateFormatter stringFromDate:firstEventDate];
    NSString* firstEventLocation = firstEvent.location;
    
    NSNumber *titleKey = @(4);
    NSNumber *eventDateString = @(5);
    NSNumber *eventLocation = @(6);
    
    NSDictionary *firstEventInfoDic = @{ titleKey:firstEvent.title,
                                         eventDateString:firstEventDateString,
                                         eventLocation:firstEventLocation};
    
    return firstEventInfoDic;
}
@end
