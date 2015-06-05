//
//  AnnotationView.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "AnnotationView.h"
#import "ShoutAnnotation.h"
#define CONTENT_HEIGHT 80
@implementation AnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/*- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    //if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])

    ShoutAnnotation *tmpAnnotation = (ShoutAnnotation*)annotation;
    self.contentHeight = 80.0;
    self.contentWidth =100.0;
    self.backgroundColor = [UIColor clearColor];
    [Contents largeViewOfPost:tmpAnnotation.postId
                    forUserId:GEO_LOGGED_USER
                 onCompletion:^(RequestResult *result) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (result.success){
                             self.Post = [[GeoPost alloc] initWithDictionary:result.extra];
                             UIView * viewForPost = [PostsDisplay viewForPost:self.Post];
                             [viewForPost setBackgroundColor:[UIColor greenColor]];
                             [viewForPost setFrame:CGRectMake(0, 0, self.contentWidth , self.contentHeight)];
                             [viewForPost setCenter:CGPointMake(viewForPost.center.x - viewForPost.frame.size.width/2, viewForPost.center.y - viewForPost.frame.size.height)];
                             [self addSubview: viewForPost];
                         }
                         else {
                             [self removeFromSuperview];
                             NSLog(@"%@", result.msg);
                         }
                         
                         //newCell.Post =
                     });
                 } ];
}*/



-(void)initWithPostId:(long)postId{
    self.backgroundColor = [UIColor clearColor];
    [Contents largeViewOfPost:postId
                    forUserId:GEO_LOGGED_USER
                 onCompletion:^(RequestResult *result) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (result.success){
                             self.Post = [[GeoPost alloc] initWithDictionary:result.extra];
                             UIView * viewForPost = [PostsDisplay viewForPost:self.Post];
                             [viewForPost setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                             [viewForPost setCenter:CGPointMake(viewForPost.center.x - viewForPost.frame.size.width/2, viewForPost.center.y - viewForPost.frame.size.height)];
                             [self addSubview: viewForPost];
                         }
                         else {
                             [self removeFromSuperview];
                             NSLog(@"%@", result.msg);
                         }
                         
                         //newCell.Post =
                     });
                 } ];

}



@end
