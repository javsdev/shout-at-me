//
//  TopBarView.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "TopBarView.h"
#import "PostVC.h"

#define BUTTON_WIDTH 44
#define BUTTON_HEIGHT 44

@implementation TopBarView

@synthesize background1 = _background1;
UIButton *searchButton;
UIButton *addButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 27.0)];
        background.backgroundColor= [UIColor whiteColor];
        //background.image = [UIImage imageNamed:@"BS_FONDO.png"];
        [self addSubview:background];
        
        self.background1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 29, self.frame.size.width, 45.0)];
        self.background1.image = [UIImage imageNamed:@"BARRA_SUPERIOR_HOME.png"];
        [self addSubview:self.background1];
        
        UILabel *logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.background1.frame.origin.x+60, self.background1.frame.origin.y, self.background1.frame.size.width - 140.0, BUTTON_HEIGHT)];
        [logoLabel setText:@"SHOUT APP"];
        [logoLabel setTextAlignment:NSTextAlignmentCenter];
        [logoLabel setTextColor:[UIColor whiteColor]];
        [logoLabel setFont:[UIFont systemFontOfSize:30]];
        [self addSubview:logoLabel];
        
        UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        homeButton.frame = CGRectMake(self.background1.frame.origin.x+60, self.background1.frame.origin.y, self.background1.frame.size.width - 140.0, BUTTON_HEIGHT);
        //[homeButton setAlpha:0.5];
        [homeButton setBackgroundColor:[UIColor clearColor]];
        [homeButton addTarget:self action:@selector(pressHomeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:homeButton];
        
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(self.background1.frame.size.width-85, self.background1.frame.origin.y, 44.0, 44.0);
//        [backButton setImage:[UIImage imageNamed:@"BS_ICONO_BACK.png"] forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:backButton];

        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(self.background1.frame.origin.x+5, self.background1.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
        [addButton setImage:[UIImage imageNamed:@"btnAdd.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(pressAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];

        searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(self.background1.frame.size.width-85, self.background1.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
        [searchButton setImage:[UIImage imageNamed:@"BS_ICONO_SEARCH.png"] forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(pressSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchButton];
    
//        searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        searchButton.frame = CGRectMake(self.background1.frame.origin.x+5, self.background1.frame.origin.y, 44.0, 44.0);
//        [searchButton setImage:[UIImage imageNamed:@"BS_ICONO_SEARCH.png"] forState:UIControlStateNormal];
//        [searchButton addTarget:self action:@selector(pressSearchButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:searchButton];
        

/*MODIFICAR RUTA INGLES*/
        
        UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingsButton.frame = CGRectMake(self.background1.frame.size.width-40, self.background1.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
        [settingsButton setImage:[UIImage imageNamed:@"FILTROCD_BTN.png"] forState:UIControlStateNormal];
        [settingsButton addTarget:self action:@selector(pressSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:settingsButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - SearchBarDelegates
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.25 animations:^{
        self.searchBar.frame = [Utils XstretchToLeft:self.searchBar toXPosition:self.background1.frame.size.width-(BUTTON_WIDTH*2) resizeWidth:0];
    }];
    
    [searchButton setEnabled:YES];
}

-(void)pressSearchButton:(id)sender
{
//    searchButton.frame = CGRectMake(self.background1.frame.origin.x+5, self.background1.frame.origin.y, 44.0, 44.0);
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(self.background1.frame.size.width-(BUTTON_WIDTH*2), self.background1.frame.origin.y, 0, BUTTON_HEIGHT)];
    [self.searchBar setDelegate:self];
    self.searchBar.showsCancelButton = YES;
    //[self.delegate pressSearchButton:sender];
    [searchButton setEnabled:NO];
    [self addSubview:self.searchBar];
    [UIView animateWithDuration:0.25 animations:^{
    //self.searchBar.frame = [Utils changeSize:self.searchBar resizeWidth:self.background1.frame.size.width-88 resizeHeight:self.searchBar.frame.size.height];
        self.searchBar.frame = [Utils XstretchToLeft:self.searchBar toXPosition:self.background1.frame.origin.x+(BUTTON_WIDTH/4) resizeWidth:self.background1.frame.size.width - (BUTTON_WIDTH*1.5)];

    }];
}

-(void) pressHomeButton:(id)sender
{
    //[self.delegate pressHomeButton:sender];
    
}

-(void) pressSettingsButton:(id)sender
{
    [self.delegate pressSettingsButton:sender];
}

-(void) pressBackButton:(id)sender
{
    
    //[self.delegate pressBackButton:sender];
}

//  Call the VC that allows for posting new content

-(void) pressAddButton:(id)sender{
    PostVC * newPost = [[PostVC alloc] initWithNibName:@"PostVC" bundle:[NSBundle mainBundle]];
    [newPost.view setFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    
    [self.window.rootViewController presentViewController:newPost animated:true completion:nil];
}

@end
