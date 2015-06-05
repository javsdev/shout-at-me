//
//  MenuCustomCell.h
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/28/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuCustomCellDelegate <NSObject>

-(void)leftButtonPressed:(UIButton*)sender withScrollView:(UIScrollView*)cellScroll;
-(void)rightButtonPressed:(UIButton*)sender withScrollView:(UIScrollView*)cellScroll;

@end

@interface MenuCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIScrollView *scrollCell;
@property (strong, nonatomic) IBOutlet UILabel *lblMenu;
@property (weak  , nonatomic) id<MenuCustomCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *btnLeft;
@property (strong, nonatomic) IBOutlet UIButton *btnRight;

- (IBAction)doRightbutton:(UIButton *)sender;
- (IBAction)doLeftButton:(UIButton *)sender;
@end
