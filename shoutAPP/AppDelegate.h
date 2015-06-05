//
//  AppDelegate.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarView.h"
#import "TopBarView-Delegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,TopBarView_Delegate>

-(void)verify_login;
-(void)refreshTabs;
-(void)closeMenu;

@property (strong, nonatomic) TopBarView *topApplicationBar;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBar;

@end

