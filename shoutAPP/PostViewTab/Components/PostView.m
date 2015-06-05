//
//  PostToolbarView.m
//  shoutAPP
//
//  Created by MAC01 on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "PostView.h"

@implementation PostView

bool _isPaired;
bool _isLiked;
bool _isFaved;

-(void) awakeFromNib{
    self.FollowButton.titleLabel.numberOfLines = 1;
    self.FollowButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.ProfileName.titleLabel.numberOfLines = 1;
    self.FollowButton.titleLabel.adjustsFontSizeToFitWidth = YES;
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

-(void) setIsLiked:(BOOL) isLiked{
    [self.Likes setBackgroundColor:isLiked?[UIColor blueColor]:[UIColor clearColor]];
    [self.Likes setTitleColor:isLiked?[UIColor whiteColor]:[UIColor blueColor] forState:UIControlStateNormal];
    _isLiked = isLiked;
}

-(void) setIsFaved:(BOOL)isFaved {
    [self.Favorites setBackgroundColor:isFaved?[UIColor yellowColor]:[UIColor clearColor]];
    [self.Favorites setTitleColor:isFaved?[UIColor whiteColor]:[UIColor yellowColor] forState:UIControlStateNormal];
    
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
@end
