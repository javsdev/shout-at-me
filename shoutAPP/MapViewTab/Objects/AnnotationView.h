//
//  AnnotationView.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "GeoPost.h"
#import "PostsDisplay.h"


@interface AnnotationView : UIView

@property (nonatomic, strong) GeoPost * Post;
@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) CGFloat contentWidth;


-(void) initWithPostId:(long)postId;
//- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
