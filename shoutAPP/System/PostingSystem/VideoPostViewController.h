//
//  VideoPostViewController.h
//  shoutAPP
//
//  Created by MAC01 on 6/1/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPostViewController : UIViewController
- (IBAction)doVideoFolder:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)doTakeVideo:(id)sender;
@end
