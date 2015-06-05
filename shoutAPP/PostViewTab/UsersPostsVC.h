//
//  UsersPostsVC.h
//  shoutAPP
//
//  Created by Mac on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersPostsVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

-(void) updatePostsForCollectionView;
@end
