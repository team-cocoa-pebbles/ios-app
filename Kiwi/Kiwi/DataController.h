//
//  DataController.h
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject
{
    dispatch_semaphore_t semaphore;
}

- (NSString*)retrieveData:(NSDictionary*) dictionary;

@end
