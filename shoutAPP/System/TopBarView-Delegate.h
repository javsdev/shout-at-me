//
//  TopBarView-Delegate.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TopBarView_Delegate <NSObject>

@optional
-(void)pressSearchButton:(id)sender;
-(void)pressHomeButton:(id)sender;
-(void)pressBackButton:(id)sender;

-(void)pressSettingsButton:(id)sender;
@end
