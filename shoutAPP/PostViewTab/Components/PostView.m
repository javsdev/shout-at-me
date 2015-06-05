//
//  PostToolbarView.m
//  shoutAPP
//
//  Created by MAC01 on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "PostView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@implementation PostView

bool _isPaired;
bool _isLiked;
bool _isFaved;

-(void) awakeFromNib{
    self.FollowButton.titleLabel.numberOfLines = 1;
    //self.FollowButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.ProfileName.titleLabel.numberOfLines = 1;
    //self.FollowButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

-(BOOL) getIsPaired {
    return _isPaired;
}

-(BOOL) getIsLiked {
    return _isLiked;
}

-(BOOL) getIsFaved {
    return _isFaved;
}

-(void) setIsPaired:(BOOL)isPaired{
    [self.FollowButton setBackgroundColor:(isPaired?[UIColor colorWithRed: 0.0 green: 1.0 blue: 0.5 alpha: 1.0]
                                           :[UIColor colorWithRed: 135.0/255.0 green: 206.0/255.0 blue:235.0/255.0 alpha: 1.0])];
    [self.FollowButton setTitle:(isPaired?@"DROP":@"STALK") forState:UIControlStateNormal];
    _isPaired = isPaired;
}

-(void) setIsLiked:(BOOL) isLiked{//(30,144,255)
    if (isLiked){
        [self.Likes setBackgroundColor:[[UIColor alloc] initWithRed:31/255. green:96/255. blue:1.0 alpha:0.40]];
        [self.Likes setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    } else {
        [self.Likes setBackgroundColor:[UIColor clearColor]];
        [self.Likes setTitleColor:[[UIColor alloc] initWithRed:31/255. green:96/255. blue:1.0 alpha:0.9] forState:UIControlStateNormal];
    }
    _isLiked = isLiked;
}

-(void) setIsFaved:(BOOL)isFaved {
    if (isFaved){
        [self.Favorites setBackgroundColor:[[UIColor alloc] initWithRed:1. green:1. blue:1.0 alpha:0.40]];
        [self.Favorites setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    } else {
        [self.Favorites setBackgroundColor:[UIColor clearColor]];
        [self.Favorites setTitleColor:[[UIColor alloc] initWithRed:1. green:1. blue:0.0 alpha:0.9] forState:UIControlStateNormal];
    }
    
    _isFaved = isFaved;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
       
    }
    
    return self;
}

- (IBAction)FollowButton:(UIButton *)sender {
    __block UIActivityIndicatorView * actView = [UIActivityIndicatorView new];
    [actView setCenter:self.FollowButton.center];
    
    [self.FollowButton addSubview:actView];
    [self.FollowButton setEnabled:false];
    
    [actView startAnimating];
    
    if (!_isPaired){
        [Subscriptions subscribeToUser:GEO_LOGGED_USER toOwner:self.Post.user_id onCompletion:^(RequestResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.success)
                    [self setIsPaired:[(NSString*)[result.extra objectForKey:@"users_paired"] boolValue]];
                [actView removeFromSuperview];
                [self.FollowButton setEnabled:true];
            });
        }];
    }
    else {
        [Subscriptions unsubscribeToUser:GEO_LOGGED_USER fromOwner:self.Post.user_id onCompletion:^(RequestResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.success)
                    [self setIsPaired:[(NSString*)[result.extra objectForKey:@"users_paired"] boolValue]];
                [actView removeFromSuperview];
                [self.FollowButton setEnabled:true];
            });
        }];
    }
}

- (IBAction)actionLike:(UIButton *)sender {
    CGPoint currentLocation = [UserLocation userLocation];
    
    [Posts likeTogglePost:self.Post.post_id
                      forUser:GEO_LOGGED_USER
                          lat:currentLocation.x
                          lng:currentLocation.y
                 onCompletion:^(RequestResult *result) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self setIsLiked:[(NSString*)[result.extra objectForKey:@"is_activity"] boolValue]];
                         [self.Likes setTitle:[result.extra objectForKey:@"activity_count"] forState:UIControlStateNormal];
                     });
                 }];
}

- (IBAction)actionFav:(UIButton *)sender {
    CGPoint currentLocation = [UserLocation userLocation];
    
    [Posts favoriteTogglePost:self.Post.post_id
                  forUser:GEO_LOGGED_USER
                      lat:currentLocation.x
                      lng:currentLocation.y
             onCompletion:^(RequestResult *result) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self setIsFaved:[(NSString*)[result.extra objectForKey:@"is_activity"] boolValue]];
                     [self.Favorites setTitle:[result.extra objectForKey:@"activity_count"] forState:UIControlStateNormal];
                 });
             }];
}

- (IBAction)actionDislike:(UIButton *)sender {

}

-(void) layoutSublayersOfLayer:(CALayer *)layer{
    if ( self.PostDisplayView.subviews.count && [((UIView*)(self.PostDisplayView.subviews[0])).layer.sublayers[0] isKindOfClass:[AVPlayerLayer class]] ){
        [((UIView*)(self.PostDisplayView.subviews[0])).layer setFrame:self.bounds];
    }
}

@end
