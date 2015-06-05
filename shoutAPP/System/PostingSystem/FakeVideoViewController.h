//
//  FakeVideoViewController.h
//  shoutAPP
//
//  Created by MAC01 on 6/4/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FakeVideoDelegate <NSObject>

-(void)didFinishPickingFakeMediaWithInfo:(NSString *)info;

-(void)fakePickerControllerDidCancel;

@end

@interface FakeVideoViewController : UIViewController

@property (assign, nonatomic) id<FakeVideoDelegate> delegate;

@end
