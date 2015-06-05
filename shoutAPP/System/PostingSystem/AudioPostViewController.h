//
//  AudioPostViewController.h
//  shoutAPP
//
//  Created by MAC01 on 6/4/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioPostDelegate <NSObject>

-(void)didSelectAudio:(NSString *)audioUrl;

@end

@interface AudioPostViewController : UIViewController

@property (assign, nonatomic) id<AudioPostDelegate> delegate;

@end
