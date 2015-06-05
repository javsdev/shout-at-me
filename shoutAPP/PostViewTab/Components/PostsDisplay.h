//
//  PostsDisplay.h
//  shoutAPP
//
//  Created by Mac on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PostView.h"
#import "GeoPost.h"

typedef enum {
    PostCellSizeSmall,
    PostCellSizeMedium,
    PostCellSizeLarge
} PostCellSize;

typedef enum {
    PostCellViewOrientationLandscape,
    PostCellViewOrientationPortait
} PostCellViewOrientation;

@interface PostsDisplay : NSObject

+(PostView*) cachedViewForPostWithId: (long)postId;
+(PostView*)viewForPost:(GeoPost*)post;
+(void) initRectSizesForSize:(CGSize)size withCellSpace:(float)space;
+(CGSize) sizeForCellSize:(PostCellSize)size withOrientation:(PostCellViewOrientation)oriented;

@end
