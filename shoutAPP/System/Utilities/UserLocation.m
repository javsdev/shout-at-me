//
//  UserLocation.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 6/1/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "UserLocation.h"

UserLocation * cHandler;

@implementation UserLocation

CLLocationManager *locationManager;
double usrLat;
double usrLng;

#pragma mark - Helper functions to create CLLocationManager object

+(void)startStandarUpdates
{
    // Create the location manager if this object does not already have one
    if (nil == locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        
        //  Handler will only be created once
        cHandler = [UserLocation new];
        
        locationManager.delegate = cHandler;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
        // Set a movement threshold for new events.
        locationManager.distanceFilter = 0;
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            //[locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
        }
        
        [locationManager startUpdatingLocation];
        [locationManager startMonitoringSignificantLocationChanges];
    }
}

#pragma  mark - location manager delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation *location = [locations lastObject];
  
    // If the event is recent, do something with it.
    usrLat = location.coordinate.latitude;
    usrLng = location.coordinate.longitude;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    // TODO: Check if there is any usrLat and usrLng set already or previous check
    NSLog(@"Error getting usr location: %@", error);
}

+(CGPoint) userLocation{
    //[locationManager ]
    //[locationManager getLocation];
    
    [locationManager startUpdatingLocation];
    [locationManager stopUpdatingLocation];
    
    CGPoint newPoint = CGPointMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    
    return newPoint;
}


@end
