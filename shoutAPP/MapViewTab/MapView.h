//
//  SecondViewController.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Region.h"
@interface PopOverIPhone : UIPopoverController

+ (BOOL)_popoversDisabled;

@end

@interface MapView : UIViewController<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *map;

@property (strong, nonatomic) IBOutlet UIView *blockView;

-(void) updatePostsForMap;
-(void) updateRangeForLocation:(double)lat atLng:(double)lng;

@end

