//
//  RegisterVC.h
//  shoutAPP
//
//  Created by MAC01 on 6/1/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterDelegate <NSObject>

-(void)didRegisterSuccessWithResult:(RequestResult *)result;

@end

@interface RegisterVC : UIViewController

@property (nonatomic, assign) id<RegisterDelegate> delegate;

@end
