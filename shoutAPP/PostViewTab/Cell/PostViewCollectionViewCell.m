//
//  PostViewCollectionViewCell.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/28/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "PostViewCollectionViewCell.h"
#import "GeoShoutApi.h"
#import "PostsDisplay.h"

@implementation PostViewCollectionViewCell

-(void)initWithPostId:(long)postId{
    PostViewCollectionViewCell * thisCell = self;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    PostView* c_view = [PostsDisplay cachedViewForPostWithId:postId];
    
    if (c_view){
        [thisCell addSubview: c_view];
        [c_view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        return;
    }
    
    //  only load unached posts
    
    [Contents largeViewOfPost:postId
                    forUserId:GEO_LOGGED_USER
                 onCompletion:^(RequestResult *result) {
                     __block RequestResult *useResult = result;
                     
                     dispatch_async( dispatch_get_main_queue(), ^{
                         if (useResult.success){
                             thisCell.Post = [[GeoPost alloc] initWithDictionary:useResult.extra];
                             
                             __block UIView * viewForPost = [PostsDisplay viewForPost:thisCell.Post];
                             [viewForPost setFrame:CGRectMake(0, 0, thisCell.frame.size.width, thisCell.frame.size.height)];
                             [thisCell addSubview: viewForPost];
                                                      }
                         else {
                             [thisCell removeFromSuperview];
                             NSLog(@"%@", useResult.msg);
                         }
                    });
                 } ];
}

@end
