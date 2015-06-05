//
//  UserLocation.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 6/1/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserLocation : NSObject <CLLocationManagerDelegate>

+(void) startStandarUpdates;
+(CGPoint) userLocation;

-(void)locationRefresh;
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end
