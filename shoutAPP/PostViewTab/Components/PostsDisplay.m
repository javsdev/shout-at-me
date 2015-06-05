//
//  PostsDisplay.m
//  shoutAPP
//
//  Created by Mac on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "PostsDisplay.h"
#import "TextPostView.h"
#import "ImagePostView.h"
#import <AVFoundation/AVFoundation.h>

static float PostCellFullWidth;
static float PostCellFullHeight;
static float PostCellHalfWidth;
static float PostCellHalfHeight;
static float PostAnnotFullWidth;
static float PostAnnotFullHeight;
static BOOL SizesInit = false;

static NSMutableDictionary * postViewCache;

@implementation PostsDisplay

+(void) postHandle_txt:(PostView*)view withContent:(NSString*)content {
    TextPostView * textView = [[NSBundle mainBundle] loadNibNamed:@"TextPostView"
                                                            owner:self
                                                          options:nil ][0];
    [textView.TextView setText:content];
    [textView setFrame:view.PostDisplayView.bounds];
    [textView.TextView setFont:[UIFont boldSystemFontOfSize:22]];
    [textView.TextView setTextColor:[[UIColor alloc] initWithRed:31/255. green:96/255. blue:1.0 alpha:1.0]];
    [view.PostDisplayView addSubview:textView];
}

+(void) postHandle_img:(PostView*)view withContent:(NSString*)content {
    ImagePostView * imgView = [[NSBundle mainBundle] loadNibNamed:@"ImagePostView"
                                                            owner:self
                                                          options:nil ][0];
    
    [imgView setFrame:view.PostDisplayView.bounds];
    [imgView initWithImageSrc:content];
    [view.PostDisplayView addSubview:imgView];
}


+(void) postHandle_vid:(PostView*)view withContent:(NSString*)content{
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:content]]; //
    
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    
    [layer setPlayer:player];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    [view.PostDisplayView.layer addSublayer:layer];
    view.PostDisplayView.player = layer;
    
    UIButton *playToggle = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 95, 200)];
    [playToggle setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [playToggle setTitle:@"Play" forState:UIControlStateNormal];
    [playToggle addTarget:view.PostDisplayView action:@selector(playerToggle) forControlEvents:UIControlEventTouchDown];
    
    [view.PostDisplayView addSubview:playToggle];
}

+(void) postTypeHandle:(GeoPost*)post withView:(PostView*)view{
    if (post){
        switch (post.content_type) {
            case 1: // Handles regular texts
                [PostsDisplay postHandle_txt:view withContent:post.contents];
                break;
            case 2: // handles images
                [PostsDisplay postHandle_img:view withContent:post.contents];
                break;
            case 3:
            case 4: // handles videos and audio
                [PostsDisplay postHandle_vid:view withContent:post.contents];
                break;
        }
        NSLog(@"%f,%f", view.PostDisplayView.frame.size.width,view.PostDisplayView.frame.size.height);
    }
}

+(PostView*) cachedViewForPostWithId: (long)postId {
    return [postViewCache objectForKey:@(postId)];
}

+(PostView*) viewForPost:(GeoPost*) post{
    PostView * c_view = [[NSBundle mainBundle] loadNibNamed:@"PostView"
                                                          owner:self
                                                        options:nil ][0];
    
    c_view.Post = post;
    
    [c_view.ProfileName setTitle:post.user_profile forState:UIControlStateNormal];
    [c_view.Likes setTitle:[NSString stringWithFormat:@"%i", post.likes_count] forState:UIControlStateNormal];
    [c_view.Dislikes setTitle:[NSString stringWithFormat:@"%i", 0] forState:UIControlStateNormal];
    [c_view.Favorites setTitle:[NSString stringWithFormat:@"%i", post.favs_count] forState:UIControlStateNormal];
    
    [c_view setIsPaired:post.is_subscribed];
    [c_view setIsLiked:post.is_liked];
    [c_view setIsFaved:post.is_faved];
    
    // Get display picture
    
    __block NSString * c_display_img = post.display_image;
    
    if (![c_display_img isEqualToString:@""]){
        dispatch_async(MEDIA_DISPATCH, ^{
            __block UIImage * display_pic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:c_display_img]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                c_view.DisplayPicture.image = display_pic;
            });
        });
    }
    
    [PostsDisplay postTypeHandle:post withView:c_view];
    
    [postViewCache setObject:c_view forKey:@(post.post_id)];
    
    return c_view;
}

+(void) initRectSizesForSize:(CGSize)size withCellSpace:(float)space {
    if ( size.width == 0 || size.height == 0) return;
    
    PostCellHalfWidth = (size.width-space) / 2;
    PostCellHalfHeight = (size.height-space) / 2;
    PostCellFullWidth = size.width;
    PostCellFullHeight = size.height;
    PostAnnotFullWidth = size.width * 0.6;
    PostAnnotFullHeight = size.height * 0.4;
    
    SizesInit = true;    
}

+(CGSize) sizeForCellSize:(PostCellSize)size withOrientation:(PostCellViewOrientation)oriented {
    switch (size) {
        case PostCellSizeSmall: return CGSizeMake(
                                                  oriented==PostCellViewOrientationPortait? PostCellHalfWidth:PostCellHalfHeight,
                                                  oriented==PostCellViewOrientationPortait? PostCellHalfWidth:PostCellHalfHeight);
            break;
        case PostCellSizeMedium: return CGSizeMake(
                                                   oriented==PostCellViewOrientationPortait? PostCellFullWidth:PostCellFullHeight,
                                                   oriented==PostCellViewOrientationPortait? PostCellHalfWidth:PostCellHalfHeight);
            break;
        case PostCellSizeLarge: return CGSizeMake(
                                                   oriented==PostCellViewOrientationPortait? PostCellFullWidth:PostCellFullHeight,
                                                  oriented==PostCellViewOrientationPortait? PostCellFullWidth:PostCellFullHeight);
            break;
        case PostMapAnnotation: return CGSizeMake( oriented==PostCellViewOrientationPortait? PostAnnotFullWidth:PostAnnotFullHeight,
                                                  oriented==PostCellViewOrientationPortait? PostAnnotFullWidth:PostAnnotFullHeight);
    }
    
    return CGSizeMake(50, 50);
}

+(void) resetCache{
    postViewCache = [NSMutableDictionary new];
}

@end
