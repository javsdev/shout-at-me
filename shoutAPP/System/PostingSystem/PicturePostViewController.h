//
//  PicturePostViewController.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicturePostDelegate <NSObject>

- (void) didSelectImage:(UIImage*)image;

@end

@interface PicturePostViewController : UIViewController

@property (nonatomic, weak) id<PicturePostDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)doTakePicture:(id)sender;
- (IBAction)doPictureFolder:(id)sender;

@end
