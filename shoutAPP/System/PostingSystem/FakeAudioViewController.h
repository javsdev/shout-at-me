//
//  FakeAudioViewController.h
//  shoutAPP
//
//  Created by MAC01 on 6/5/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FakeAudioDelegate <NSObject>

-(void)didFinishPickingFakeAudioWithInfo:(NSString *)info;
-(void)fakeAudioPickerControllerDidCancel;

@end

@interface FakeAudioViewController : UIViewController

@property (assign, nonatomic) id<FakeAudioDelegate> delegate;

@end
