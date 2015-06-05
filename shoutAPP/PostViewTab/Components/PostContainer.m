//
//  PostContainer.m
//  shoutAPP
//
//  Created by Mac on 6/5/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "PostContainer.h"

@implementation PostContainer


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) layoutSubviews{
    [super layoutSubviews];
    
    if (self.player){
        [self.player setFrame:self.bounds];
    }
}

-(void) playerToggle{
    if (self.player){
        if (self.player.player.rate == 1){
            [self.player.player pause];
        }
        else {
            [self.player.player play];
        }
    }
}


@end
