//
//  AppDelegate.h
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PebbleKit/PebbleKit.h>
#import "PredictionController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSTimer *timer;
    NSInteger predictionInterval;
}

@property (nonatomic, retain) NSTimer *timer;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) PredictionController *predictionController;



@end