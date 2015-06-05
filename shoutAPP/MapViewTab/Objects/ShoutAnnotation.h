//
//  ShoutAnnotation.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ShoutAnnotation : MKPinAnnotationView<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property long postId;
@property int contentType;
@property (nonatomic, strong)NSMutableArray *information;


@end
