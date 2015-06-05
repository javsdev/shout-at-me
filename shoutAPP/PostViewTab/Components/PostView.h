//
//  PostToolbarView.h
//  shoutAPP
//
//  Created by MAC01 on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoPost.h"

@interface PostView : UIView

@property GeoPost * Post;

@property (weak, nonatomic) IBOutlet UIButton *ProfileName;
@property (weak, nonatomic) IBOutlet UIButton *Dislikes;
@property (weak, nonatomic) IBOutlet UIButton *Favorites;
@property (weak, nonatomic) IBOutlet UIButton *Likes;
@property (weak, nonatomic) IBOutlet UIView *PostDisplayView;
@property (weak, nonatomic) IBOutlet UIImageView *DisplayPicture;
@property (weak, nonatomic) IBOutlet UIButton *FollowButton;

@property (getter=getIsPaired, setter=setIsPaired:) BOOL isPaired;
@property (getter=getIsLiked, setter=setIsLiked:) BOOL isLiked;
@property (getter=getIsFaved, setter=setIsFaved:) BOOL isFaved;

@end
