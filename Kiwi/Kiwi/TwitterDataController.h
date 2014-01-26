//
//  TwitterDataController.h
//  Kiwi
//
//  Created by Laurence Wong on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "DataController.h"
#import <PebbleKit/PebbleKit.h>

@interface TwitterDataController : DataController
{
    NSString *quote;
}

@property NSString *url;
- (NSDictionary*)retrieveData;
@end
