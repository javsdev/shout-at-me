//
//  PostViewCollectionViewCell.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/28/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoPost.h"
#import "PostsDisplay.h"

@interface PostViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) GeoPost * Post;

-(void) initWithPostId:(long)postId;

@end
