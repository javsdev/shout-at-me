//
//  TopBarView.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarView-Delegate.h"

@interface TopBarView : UIView<UISearchBarDelegate>
{
    UIImageView *_background1;
}


-(void)pressSearchButton:(id)sender;
-(void)pressHomeButton:(id)sender;
-(void)pressBackButton:(id)sender;

//AGREGAR RUTA INGLES
-(void)pressSettingsButton:(id)sender;
//-(void)pressSettingsButton;

@property(nonatomic, weak) id <TopBarView_Delegate> delegate;
@property(nonatomic, strong) UIImageView *background1;
@property(nonatomic, strong)UISearchBar *searchBar;
@end
