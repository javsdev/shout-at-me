//
//  VideoPostViewController.h
//  shoutAPP
//
//  Created by MAC01 on 6/1/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoPostDelegate <NSObject>

-(void)didSelectVideo:(NSString *)videoUrl;

@end

@interface VideoPostViewController : UIViewController

@property (assign, nonatomic) id<VideoPostDelegate> delegate;

@end
