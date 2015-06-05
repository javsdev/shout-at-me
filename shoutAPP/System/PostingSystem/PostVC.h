//
//  PostVC.h
//  shoutAPP
//
//  Created by Mac on 5/30/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicturePostViewController.h"
@interface PostVC : UIViewController<PicturePostDelegate>

// Container for image, video and audio controllers to preview them before its posted
@property (weak, nonatomic) IBOutlet UIView *extraContentContainer;

- (IBAction)doPostButtons:(id)sender;
@end
