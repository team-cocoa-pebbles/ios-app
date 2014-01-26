//
//  AppDelegate.m
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/25/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <PBPebbleCentralDelegate>
@end

@implementation AppDelegate {
    PBWatch *_targetWatch;
    //CLLocationManager *_locationManager;
}

- (void)refreshAction:(id)sender {
    if (_targetWatch == nil || [_targetWatch isConnected] == NO) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"No connected watch!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    // Fetch weather at current location using openweathermap.org's JSON API:
    
    /*NSString *apiURLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.1/find/city?lat=%f&lon=%f&cnt=1", coordinate.latitude, coordinate.longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiURLString]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = nil;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            httpResponse = (NSHTTPURLResponse *) response;
        }
        
        // NSURLConnection's completionHandler is called on the background thread.
        // Prepare a block to show an alert on the main thread:
        __block NSString *message = @"";
        void (^showAlert)(void) = ^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        };
        
        // Check for error or non-OK statusCode:
        if (error || httpResponse.statusCode != 200) {
            message = @"Error fetching weather";
            NSLog(@"URL error: %@", error);
            showAlert();
            return;
        }
        
        // Parse the JSON response:
        NSError *jsonError = nil;
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        NSLog(@"%@", root);
        @try {
         if (jsonError == nil && root) {
         // TODO: type checking / validation, this is really dangerous...
         NSDictionary *firstListItem = [root[@"list"] objectAtIndex:0];
         NSDictionary *main = firstListItem[@"main"];
         
         // Get the temperature:
         NSNumber *temperatureNumber = main[@"temp"]; // in degrees Kelvin
         int temperature = [temperatureNumber integerValue] - 273.15;
         
         // Get weather icon:
         NSNumber *weatherIconNumber = firstListItem[@"weather"][0][@"icon"];
        uint8_t weatherIconID = 2;
         
         // Send data to watch:
         // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definitions on the watch's end:
         NSNumber *iconKey = @(0); // This is our custom-defined key for the icon ID, which is of type uint8_t.
         NSNumber *temperatureKey = @(1); // This is our custom-defined key for the temperature string.
         NSDictionary *update = @{ iconKey:[NSNumber numberWithUint8:weatherIconID],
         temperatureKey:[NSString stringWithFormat:@"%d\u00B0C", temperature] };
         [_targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
         message = error ? [error localizedDescription] : @"Update sent!";
         showAlert();
         }];
         return;
         }
         }
         @catch (NSException *exception) {}
        NSLog(@"JSON error: %@", jsonError);
        message = @"Error parsing response";
        showAlert();
        
        NSNumber *iconKey = @(0); // This is our custom-defined key for the icon ID, which is of type uint8_t.
        NSNumber *temperatureKey = @(1); // This is our custom-defined key for the temperature string.
        NSDictionary *update = @{ iconKey:[NSNumber numberWithUint8:3],
                                  temperatureKey:[NSString stringWithFormat:@"%d\u00B0C", 30] };
        [_targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
            message = error ? [error localizedDescription] : @"Update sent!";
            showAlert();
        }];
    }];*/
}


- (void)setTargetWatch:(PBWatch*)watch {
    NSLog(@"Setting target watch");
    _targetWatch = watch;
    
    // NOTE:
    // For demonstration purposes, we start communicating with the watch immediately upon connection,
    // because we are calling -appMessagesGetIsSupported: here, which implicitely opens the communication session.
    // Real world apps should communicate only if the user is actively using the app, because there
    // is one communication session that is shared between all 3rd party iOS apps.
    
    // Test if the Pebble's firmware supports AppMessages / Weather:
    [watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            // Configure our communications channel to target the weather app:
            // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definition on the watch's end:
            
            
            uuid_t myAppUUIDbytes;
            NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"28AF3DC7-E40D-490F-BEF2-29548C8B0600"];
            [myAppUUID getUUIDBytes:myAppUUIDbytes];
            
            [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:16]];
            
            NSString *message = [NSString stringWithFormat:@"Yay! %@ supports AppMessages :D", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            
            NSString *message = [NSString stringWithFormat:@"Blegh... %@ does NOT support AppMessages :'(", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected..." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Launching Kiwi");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //self.logoImage = (UIImage*)(resizedImage:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) interpolationQuality:1);
    self.predictionController = [[PredictionController alloc] init];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [refreshButton setTitle:@"Fetch Weather" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setFrame:CGRectMake(10, 100, 300, 100)];
    [self.window addSubview:refreshButton];
    [self.predictionController initiatePredictions];
    [self.window makeKeyAndVisible];
    
    // We'd like to get called when Pebbles connect and disconnect, so become the delegate of PBPebbleCentral:
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    
    // Initialize with the last connected watch:
    [self setTargetWatch:[[PBPebbleCentral defaultCentral] lastConnectedWatch]];
    return YES;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 *  PBPebbleCentral delegate methods
 */

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    NSLog(@"Watch did connect");
    [self setTargetWatch:watch];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    [[[UIAlertView alloc] initWithTitle:@"Disconnected!" message:[watch name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    if (_targetWatch == watch || [watch isEqual:_targetWatch]) {
        [self setTargetWatch:nil];
    }
}

/*
 *  CLLocationManagerDelegate
 */

// iOS 5 and earlier:
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"New Location: %@", newLocation);
}

// iOS 6 and later:
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *lastLocation = [locations lastObject];
    [self locationManager:manager didUpdateToLocation:lastLocation fromLocation:nil];
}

@end
