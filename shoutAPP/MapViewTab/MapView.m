//
//  SecondViewController.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "MapView.h"
#import "AnnotationView.h"
#import "ShoutAnnotation.h"

// pad our map by 10% around the farthest annotations
#define MAP_PADDING 1.1

// we'll make sure that our minimum vertical span is about a kilometer
// there are ~111km to a degree of latitude. regionThatFits will take care of
// longitude, which is more complicated, anyway.
#define MINIMUM_VISIBLE_LATITUDE 0.01


@interface PopOverIPhone()

@end

@implementation PopOverIPhone

+ (BOOL)_popoversDisabled {
    return NO;
}

@end

@interface MapView ()

@property (nonatomic, strong) NSMutableArray * PostsAnnotations;

@end

@implementation MapView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.map setDelegate:self];
    self.PostsAnnotations = [NSMutableArray new];
    self.modalPresentationStyle = UIModalPresentationPopover;
    self.navigationController.modalPresentationStyle = UIModalPresentationPopover;
}

-(void)viewDidAppear:(BOOL)animated
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self updatePostsForMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];
        
        pinView.image = [UIImage imageNamed:@"location"];
        [pinView setFrame:CGRectMake(0, 0, 25, 25)];
        pinView.enabled = false;
        return pinView;
    }
    
    if ([annotation isKindOfClass:[ShoutAnnotation class]]){
        ShoutAnnotation * shoutAnn = (ShoutAnnotation*)annotation;
        
//        MKAnnotationView * c_view = [mapView dequeueReusableAnnotationViewWithIdentifier:[NSString stringWithFormat:@"%li", shoutAnn.postId]];
//        NSLog(@"contenttype:%d",shoutAnn.contentType);
//        NSLog(@"Anotation:%f,%f",shoutAnn.coordinate.latitude,shoutAnn.coordinate.longitude);
//        
        //if (c_view) return c_view;
        
        ShoutAnnotation *customPinView = [[ShoutAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:[NSString stringWithFormat:@"%li", shoutAnn.postId]];
        customPinView = (ShoutAnnotation*)annotation;
        switch (customPinView.contentType) {
            case 1: customPinView.image = [UIImage imageNamed:@"ann-txt"];break;
            case 2: customPinView.image = [UIImage imageNamed:@"ann-picture"];break;
            case 3: customPinView.image = [UIImage imageNamed:@"ann-video"];break;
            case 4: customPinView.image = [UIImage imageNamed:@"ann-sound"];break;
            case 5: customPinView.image = [UIImage imageNamed:@"ann-url"];break;
            default:
                break;
        }
        
        [customPinView setFrame:CGRectMake(0, 0, 25, 25)];
       // customPinView.animatesDrop = YES;
        customPinView.canShowCallout = NO;
        
        return customPinView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    if ([view.annotation isKindOfClass:[MKUserLocation class]])
 //       return;
    
    if ([view.annotation isKindOfClass:[ShoutAnnotation class]])
    {
        ShoutAnnotation * shoutAnn = (ShoutAnnotation*)view.annotation;
        
        CLLocationCoordinate2D zoomLocation;
        
        zoomLocation.latitude = shoutAnn.coordinate.latitude;
        zoomLocation.longitude = shoutAnn.coordinate.longitude;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10000, 10000);
        [self.map setRegion:viewRegion animated:YES];

        AnnotationView * anView = [AnnotationView new];
        CGSize annotSize = [PostsDisplay sizeForCellSize:PostCellSizeSmall withOrientation:PostCellViewOrientationPortait];
        [anView setFrame:CGRectMake(0, 0, annotSize.width, annotSize.height)];
        [anView initWithPostId:shoutAnn.postId];

        [view addSubview: anView];
    }
}

-(void) updateRangeForLocation:(double)lat atLng:(double)lng {
    NSInteger desired_range = [[NSUserDefaults standardUserDefaults]integerForKey:@"region"];
    float use_range = 0;
    
    switch (desired_range) {
        case 0:
        case 1:
        case 2:
        case 3:{
            NSArray * use_ranges = @[@5, @15, @25, @50];
            use_range = [use_ranges[desired_range] intValue] * 2 * 1609.344;
            
            MKCoordinateRegion c_region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lat, lng), use_range, use_range);
            [self.map setRegion:c_region animated:YES];
        } break;
            
        case 4:
        case 5:
        case 6:
        case 7:
        {

             [Users getUserRegionWithName:(int)desired_range forLat:lat forLng:lng onCompletion:^(Region *region) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     MKCoordinateRegion reg;
                     reg.center.latitude = (region.startLat + region.endLat) / 2;
                     reg.center.longitude = (region.startLng + region.endLng) / 2;
                     
                     reg.span.latitudeDelta = (MAX(region.startLat, region.endLat) - MIN(region.startLat, region.endLat)) * MAP_PADDING;
                     
                     reg.span.latitudeDelta = (reg.span.latitudeDelta < MINIMUM_VISIBLE_LATITUDE)
                     ? MINIMUM_VISIBLE_LATITUDE
                     : reg.span.latitudeDelta;
                     
                     reg.span.longitudeDelta = (MAX(region.endLng, region.startLng) - MIN(region.endLng, region.startLng)) * MAP_PADDING;
                     
                     MKCoordinateRegion scaledRegion = [self.map regionThatFits:reg];
                     [self.map setRegion:scaledRegion animated:YES];
            
                 });
             }];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.5
                         animations:^{ annView.frame = endFrame; }];
    }
}

- (void)mapView:(MKMapView *)mapview annotationView:(MKAnnotationView *)view
{
    [mapview deselectAnnotation:view.annotation animated:YES];
    CGSize c_size = [PostsDisplay sizeForCellSize:PostCellSizeSmall withOrientation:PostCellViewOrientationPortait];
    PostView * pv = [PostsDisplay viewForPost:((AnnotationView*)view).Post];
    [pv setFrame:CGRectMake(0, 0, c_size.width, c_size.height)];
    [view addSubview:pv];
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{

    [self removeAlSubviews:view];
    CGPoint currentLocation = [UserLocation userLocation];
    [self updateRangeForLocation:currentLocation.x atLng:currentLocation.y];

}

#pragma mark - Posts Update

-(void) updatePostsForMap {
    
    CGPoint currentLocation = [UserLocation userLocation];
    
    NSInteger sorting = [[NSUserDefaults standardUserDefaults]integerForKey:@"sort"];
    NSInteger range = [[NSUserDefaults standardUserDefaults]integerForKey:@"region"];
    
    NSString * c_method = @"";
    NSString * c_range = @"";
    
    switch (sorting) {
        case 0: c_method = @"popularity"; break;
        case 1: c_method = @"likes"; break;
        case 2: c_method = @"dislikes"; break;
    };
    
    switch (range) {
        case 0: c_range = @"5"; break;
        case 1: c_range = @"15"; break;
        case 2: c_range = @"25"; break;
        case 3: c_range = @"50"; break;
        case 4: c_range = @"region"; break;
        case 5: c_range = @"city"; break;
        case 6: c_range = @"state"; break;
        case 7: c_range = @"country"; break;
    }
    
    [self.map removeAnnotations:self.PostsAnnotations];
    [self.PostsAnnotations removeAllObjects];
    
    
    [Contents contentForUser:GEO_LOGGED_USER
                     withLat:currentLocation.x
                     withLng:currentLocation.y
                     inRange:c_range
                 sortingType:c_method
          forPlaceHolderDate:0
              forRefreshType:@"forward"
                 strideStart:0
                   strideEnd:50
                onCompletion:^(RequestResult *results) {

                    if (results.success)
                    {
                        [self updateRangeForLocation:currentLocation.x atLng:currentLocation.y];
                        
                        NSDictionary *dict = results.extra;
                        if ([[dict objectForKey:@"count"] intValue]>0)
                        {
                            NSArray *itemsArray = [dict objectForKey:@"items"];
                            for (NSDictionary *aItem in itemsArray)
                            {
                                ShoutAnnotation *aShout = [ShoutAnnotation new];
                                
                                aShout.title = @"test";
                                aShout.subtitle = @"test subtext";
                                aShout.postId = [aItem[@"post_id"] integerValue];
                                aShout.contentType = [aItem[@"content_type"] intValue];
                                
                                [aShout setCoordinate:CLLocationCoordinate2DMake([[aItem objectForKey:@"lat"] floatValue], [[aItem objectForKey:@"long"] floatValue])];
                                
                                [self.PostsAnnotations addObject:aShout];
                                [self.map addAnnotation:aShout];
                            }
                            
                        }
                    }
                }];
}



-(void)removeAlSubviews:(UIView*)parentView
{
    for (UIView *subView in parentView.subviews)
    {
        if (subView.subviews.count != 0) {
            [self removeAlSubviews:subView];
        }
        [subView removeFromSuperview];
        
    }
}

@end
