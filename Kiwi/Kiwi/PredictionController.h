//
//  PredictionController.h
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherDataController.h"

@interface PredictionController : NSObject

@property (strong, nonatomic) WeatherDataController *weatherDataController;

-(void)initiatePredictions;

@end
