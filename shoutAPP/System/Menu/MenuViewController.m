//
//  MenuViewController.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/28/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "MenuViewController.h"
#import "MapCustomCell.h"
#import "UsersPostsVC.h"
#import "MapView.h"
#import "ProfileVC.h"

@interface MenuViewController ()

@end

NSArray *arrTab1;
NSArray *arrTab2;
NSArray *arrSort;
NSArray *arrRegion;

AppDelegate *appDelegate;
MenuCustomCell *menuCell;

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    arrTab1 = @[@"Popularity",@"5 Miles",@"Profile",@"Settings",@"Logout"];
    arrTab2 = @[@"Profile",@"Settings",@"Logout"];
    arrSort = @[@"Popularity",@"Likes",@"Dislikes"];
    arrRegion = @[@"5 Miles",@"15 Miles",@"25 Miles",@"50 Miles",@"Region",@"City",@"State",@"Country"];
    
    [self.tblView registerNib:[UINib nibWithNibName:@"MenuCustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MenuCell"];
    [self.tblView registerNib:[UINib nibWithNibName:@"MapCustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MapCell"];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 0){
        NSInteger c_sort_index = [[NSUserDefaults standardUserDefaults] integerForKey:indexPath.row?@"region":@"sort"];
        MenuCustomCell * cCell = menuCell;
        
        float width = cCell.lblMenu.frame.size.width;
        
        float x = ((width+8)*c_sort_index);
        [cCell.scrollCell setContentOffset:CGPointMake(x, 0)animated:true ];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
        return arrTab1.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MenuCellIdentifier = @"MenuCell";
    static NSString *MapCellIdentifier = @"MapCell";
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            menuCell = [tableView dequeueReusableCellWithIdentifier:MenuCellIdentifier];
            menuCell.tag = 8;
            menuCell.delegate = self;
            
            float x = 8.0;
            float width = menuCell.lblMenu.frame.size.width;
            menuCell.scrollCell.contentSize = [Utils changeScrollViewContentSize:menuCell.scrollCell resizeWidth:menuCell.frame.size.width * arrRegion.count resizeHeight:menuCell.frame.size.height];
            for (int i=0; i<arrSort.count;i++)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, 12, width, 20)];
                label.text = arrSort[i];
                label.textAlignment = NSTextAlignmentCenter;
                [label setFont:[UIFont systemFontOfSize:20]];
                [label setMinimumScaleFactor:10/20];
                menuCell.btnLeft.tag = 0;
                menuCell.btnRight.tag = 0;
                [menuCell.scrollCell addSubview:label];
                x = x + (width +8);
            }
            
            [menuCell.lblMenu setHidden:YES];
            return  menuCell;
        }
            break;
        case 1:
        {
            menuCell = [tableView dequeueReusableCellWithIdentifier:MenuCellIdentifier];
            menuCell.delegate = self;
            
            float x = 8.0;
            float width = menuCell.lblMenu.frame.size.width;
            
            menuCell.scrollCell.contentSize = [Utils changeScrollViewContentSize:menuCell.scrollCell resizeWidth:menuCell.frame.size.width * arrRegion.count resizeHeight:menuCell.frame.size.height];
            
            for (int i=0; i<arrRegion.count;i++)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, 12, width, 20)];
                label.text = arrRegion[i];
                label.textAlignment = NSTextAlignmentCenter;
                [label setFont:[UIFont systemFontOfSize:20]];
                [label setMinimumScaleFactor:10/20];
                
                [menuCell.scrollCell addSubview:label];
                x = x + (width +8);
            }
            
            menuCell.btnLeft.tag = 1;
            menuCell.btnRight.tag = 1;
            
            [menuCell.lblMenu setHidden:YES];
            
            return menuCell;
        }
            break;
        case 2:
        {
            MapCustomCell *mapCell= [tableView dequeueReusableCellWithIdentifier:MapCellIdentifier];
            mapCell.lblMap.text = arrTab1[indexPath.row];
            return mapCell;
        }
            break;
        case 3:
        {
            MapCustomCell *mapCell= [tableView dequeueReusableCellWithIdentifier:MapCellIdentifier];
            mapCell.lblMap.text = arrTab1[indexPath.row];
            return mapCell;
        }
            break;
        case 4:
        {
            MapCustomCell *mapCell= [tableView dequeueReusableCellWithIdentifier:MapCellIdentifier];
            mapCell.lblMap.text = arrTab1[indexPath.row];
            return mapCell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}



#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2: {
            [self.delegate didLaunchProfileSettings];
            break;
        }
        case 4: {
            GEO_LOGGED_USER = 0;
            [appDelegate closeMenu];
            [appDelegate verify_login];
        } break;
    }
    return false;
}

#pragma mark -MenuCustomCellDelegate

-(void) incItems:(int)by
         toIndex:(NSString*)use
          forArr:(NSArray*)arr
         withBtn:(UIButton*)sender
  withScrollView:(UIScrollView *)cellScroll {
    float w = menuCell.lblMenu.frame.size.width;
    float x = cellScroll.contentOffset.x;
    
    NSInteger index = [[NSUserDefaults standardUserDefaults]integerForKey:use];
    
    int newIndex = (unsigned int)index + by;
    
    if (newIndex >= 0 && newIndex < arr.count){
        x = ((w+8)*newIndex);
        [[NSUserDefaults standardUserDefaults] setInteger:newIndex forKey:use];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [cellScroll setContentOffset:CGPointMake(x, cellScroll.frame.origin.y) animated:YES];
    }
}

-(void)rightButtonPressed:(UIButton*)sender withScrollView:(UIScrollView *)cellScroll
{
    [self incItems:1
           toIndex:sender.tag==0?@"sort":@"region"
            forArr:sender.tag==0?arrSort:arrRegion
           withBtn:sender
    withScrollView:cellScroll];
}

-(void)leftButtonPressed:(UIButton*)sender withScrollView:(UIScrollView *)cellScroll
{
    [self incItems:-1
           toIndex:sender.tag==0?@"sort":@"region"
            forArr:sender.tag==0?arrSort:arrRegion
           withBtn:sender
    withScrollView:cellScroll];
}

-(void) refreshPostsForTab {
    switch(appDelegate.tabBar.selectedIndex)
    {
        case 0: [appDelegate.tabBar.viewControllers[0] performSelector:@selector(updatePostsForCollectionView) withObject:self]; break;
        case 1: [appDelegate.tabBar.viewControllers[1] performSelector:@selector(updatePostsForMap) withObject:self]; break;
    }
}


#pragma mark -MyMethods


@end
