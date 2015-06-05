//
//  MenuCustomCell.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/28/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "MenuCustomCell.h"

@implementation MenuCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doRightbutton:(UIButton *)sender 
{
    [self.delegate rightButtonPressed:sender withScrollView:self.scrollCell];
}

- (IBAction)doLeftButton:(UIButton *)sender
{
    [self.delegate leftButtonPressed:sender withScrollView:self.scrollCell];
}
@end
