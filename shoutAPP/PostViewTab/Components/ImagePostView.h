//
//  ImageView.h
//  shoutAPP
//
//  Created by Mac on 6/2/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePostView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *ShowImage;

-(void) initWithImageSrc:(NSString*)source;

@end
