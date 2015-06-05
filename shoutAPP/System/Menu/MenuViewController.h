//
//  MenuViewController.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/28/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MenuCustomCell.h"

@protocol ShoutMenuViewDelegate <NSObject>

-(void)didLaunchProfileSettings;

@end

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MenuCustomCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (assign, nonatomic) id<ShoutMenuViewDelegate> delegate;

-(void) refreshPostsForTab;
@end
