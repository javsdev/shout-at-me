//
//  ImageView.m
//  shoutAPP
//
//  Created by Mac on 6/2/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "ImagePostView.h"

@implementation ImagePostView

-(void) initWithImageSrc:(NSString*)source {
    __block ImagePostView * thisPost = self;
    __block UIImage * displayImage;
    
    dispatch_async(MEDIA_DISPATCH, ^{
        displayImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:source]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            thisPost.ShowImage.image = displayImage;
        });
    });
}

@end
