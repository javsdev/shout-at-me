//
//  InterfaceController.m
//  shoutAPP WatchKit Extension
//
//  Created by Miguel Garcia Topete on 6/5/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "MapInterfaceController.h"


@interface MapInterfaceController()

@end


@implementation MapInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self requestLocationFromPhone];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void) requestLocationFromPhone
{
    [WKInterfaceController openParentApplication:@{@"request":@"location"}
                                           reply:^(NSDictionary *replyInfo, NSError *error) {
                                               
                                               // the request was successful
                                               if(error == nil) {
                                                   
                                                   // get the serialized location object
                                                   NSDictionary *location = replyInfo[@"location"];
                                                   
                                                   // pull out the speed (it's an NSNumber)
//                                                   NSNumber *speed = location[@"speed"];
                                                   
                                                   // and convert it to a string for our label
  //                                                 NSString *speedString = [NSString stringWithFormat:@"Speed: %g", speed.doubleValue];
                                                   
                                                   // update our label with the newest location's speed
//                                                   [_speedLabel setText:speedString];
                                                   
                                                   // next, get the lat/lon
                                                   NSNumber *latitude = location[@"latitude"];
                                                   NSNumber *longitude = location[@"longitude"];
                                                   
                                                   // and update our map
                                                   MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
                                                   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
                                                   
                                                   // drop a pin where the user is currently
                                                   [_myMap addAnnotation:coordinate withPinColor:WKInterfaceMapPinColorRed];
                                                   
                                                   // and give it a region to display
                                                   MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
                                                   [_myMap setRegion:region];
                                               }
                                               
                                               // the request failed
                                               else {
                                                   //      [Crittercism logError:error];
                                               }
                                           }];
}


@end



