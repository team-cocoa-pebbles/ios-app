//
//  TwitterDataController.m
//  Kiwi
//
//  Created by Laurence Wong on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "TwitterDataController.h"

@implementation TwitterDataController

- (id)init
{
    self.url = @"http://www.iheartquotes.com/api/v1/random?max_characters=21";
    semaphore = dispatch_semaphore_create(0);
    return self;
}

-(NSURLRequest *)connection:(NSURLConnection *)connection
            willSendRequest:(NSURLRequest *)request
           redirectResponse:(NSURLResponse *)redirectResponse
{
    NSURLRequest *newRequest = request;
    
    if (redirectResponse)
    {
        newRequest = nil;
    }
    return newRequest;
}

- (NSDictionary*)retrieveData
{
    NSLog(@"Retrieving quote data");
    NSURL *weatherURL = [NSURL URLWithString:self.url];
    NSLog(@"URL: %@", weatherURL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:weatherURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
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
                               
                               
                               NSString* newStr = [[NSString alloc] initWithData:data
                                                                        encoding:NSUTF8StringEncoding];
                               quote = [[newStr componentsSeparatedByString: @"\n"] objectAtIndex:0];
                               //NSLog(@"Dictionary: %@", root);
                               dispatch_semaphore_signal(semaphore);



                           }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    NSNumber *stringKey = @(3);
    NSDictionary *update = @{stringKey:quote};
    
    return update;
}

@end
