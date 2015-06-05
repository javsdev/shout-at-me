//
//  UsersPostsVC.m
//  shoutAPP
//
//  Created by Mac on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "UsersPostsVC.h"
#import "PostViewCollectionViewCell.h"
#import "AppDelegate.h"
#import "GeoShoutApi.h"

@interface UsersPostsVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray * PostsIDS;
@property (nonatomic, strong) NSDictionary * refresh_info;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation UsersPostsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PostsIDS = [NSMutableArray new];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PostViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(includeNewData)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = true;
}

-(void)viewWillAppear:(BOOL)animated {
    if (GEO_LOGGED_USER) {
        [PostsDisplay resetCache];
        [self updatePostsForCollectionView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.PostsIDS.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostViewCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    long post_id = [(NSString*)[self.PostsIDS[indexPath.row] objectForKey:@"post_id"] integerValue];
    
    [cell initWithPostId: post_id];
    
    if (indexPath.row+1 == self.PostsIDS.count){
        [self updateCollectionStride];
    }
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([[self.PostsIDS[indexPath.row] valueForKey:@"content_type"] integerValue]){
        case 1: return [PostsDisplay sizeForCellSize:PostCellSizeMedium withOrientation:PostCellViewOrientationPortait]; break;
        case 2: return [PostsDisplay sizeForCellSize:PostCellSizeLarge withOrientation:PostCellViewOrientationPortait]; break;
        case 3: return [PostsDisplay sizeForCellSize:PostCellSizeSmall withOrientation:PostCellViewOrientationPortait]; break;
        case 4: return [PostsDisplay sizeForCellSize:PostCellSizeLarge withOrientation:PostCellViewOrientationPortait];
    }
    
    return [PostsDisplay sizeForCellSize:PostCellSizeSmall withOrientation:PostCellViewOrientationPortait];
}

#pragma mark - TopBarDelegates

-(void)pressSearchButton:(id)sender
{
    NSLog(@"search");
}
-(void)pressHomeButton:(id)sender
{
    NSLog(@"home");
}
-(void)pressBackButton:(id)sender
{
    NSLog(@"back");
}

#pragma mark - Posts Update

-(void) doCollectionRetrieve:(BOOL)forStrides{
    CGPoint currentLocation = [UserLocation userLocation];
    
    NSInteger sorting = [[NSUserDefaults standardUserDefaults]integerForKey:@"sort"];
    NSInteger range = [[NSUserDefaults standardUserDefaults]integerForKey:@"region"];
    
    NSString * c_method = @"";
    NSString * c_range = @"";
    
    switch (sorting) {
        case 0: c_method = @"popularity"; break;
        case 1: c_method = @"likes"; break;
        case 2: c_method = @"dislikes"; break;
    };
    
    switch (range) {
        case 0: c_range = @"5"; break;
        case 1: c_range = @"15"; break;
        case 2: c_range = @"25"; break;
        case 3: c_range = @"50"; break;
        case 4: c_range = @"region"; break;
        case 5: c_range = @"city"; break;
        case 6: c_range = @"state"; break;
        case 7: c_range = @"country"; break;
    }
    
    [Contents contentForUser:GEO_LOGGED_USER
                     withLat:currentLocation.x
                     withLng:currentLocation.y
                     inRange:c_range
                 sortingType:c_method
          forPlaceHolderDate:forStrides?self.refresh_info[@"place_holder_date"]:0
              forRefreshType:@"forward"
                 strideStart:forStrides?[(NSString*)self.refresh_info[@"stride_start"] intValue]:0
                   strideEnd:forStrides?[(NSString*)self.refresh_info[@"stride_end"] intValue]:0
                onCompletion:^(RequestResult *results) {
                    if (results.success){
                        self.refresh_info = [results.extra objectForKey:@"update_params"];
                        
                        int returned_count = [(NSString*)[results.extra objectForKey:@"count"] intValue];
                        __block NSArray * new_posts = (NSArray*)[results.extra objectForKey:@"items"];
                        
                        if (returned_count){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.PostsIDS addObjectsFromArray:new_posts];
                                [self.collectionView reloadData];
                                if (!forStrides)[self.collectionView setContentOffset:CGPointMake(0,0)];
                            });
                        }
                    }
                    else{
                        NSLog(@"Collection view error: %@", results.msg);
                    }
                }];
}

-(void) updatePostsForCollectionView {
    //  Clear Posts show, then add retrieved items
    [self.PostsIDS removeAllObjects];
    self.refresh_info = nil;
    [self doCollectionRetrieve:false];
}

-(void) updateCollectionStride{
    //  Append items to the end of the collection
    [self doCollectionRetrieve:true];
}

-(void) includeNewData{
    if (self.PostsIDS.count == 0) {
        [self updatePostsForCollectionView];
        [self.refreshControl endRefreshing];
        return;
    }
    //  include new data to the top of the collection
    
    CGPoint currentLocation = [UserLocation userLocation];
    
    NSInteger sorting = [[NSUserDefaults standardUserDefaults]integerForKey:@"sort"];
    NSInteger range = [[NSUserDefaults standardUserDefaults]integerForKey:@"region"];
    
    NSString * c_method = @"";
    NSString * c_range = @"";
    
    switch (sorting) {
        case 0: c_method = @"popularity"; break;
        case 1: c_method = @"likes"; break;
        case 2: c_method = @"dislikes"; break;
    };
    
    switch (range) {
        case 0: c_range = @"5"; break;
        case 1: c_range = @"15"; break;
        case 2: c_range = @"25"; break;
        case 3: c_range = @"50"; break;
        case 4: c_range = @"region"; break;
        case 5: c_range = @"city"; break;
        case 6: c_range = @"state"; break;
        case 7: c_range = @"country"; break;
    }
    
    [Contents contentForUser:GEO_LOGGED_USER
                     withLat:currentLocation.x
                     withLng:currentLocation.y
                     inRange:c_range
                 sortingType:c_method
          forPlaceHolderDate:self.refresh_info[@"place_holder_date"]
              forRefreshType:@"backward"
                 strideStart:0
                   strideEnd:0
                onCompletion:^(RequestResult *results) {
                    if (results.success){
                        int returned_count = [(NSString*)[results.extra objectForKey:@"count"] intValue];
                        __block NSArray * new_posts = (NSArray*)[results.extra objectForKey:@"items"];
                        
                        //  Update place holder infomation
                        NSString* newPlaceHolderDate = [results.extra objectForKey:@"update_params"];
                        NSNumber* newStrideStart = @([(NSNumber*)self.refresh_info[@"stride_start"]intValue]+returned_count);
                        NSNumber* newStrideEnd = @([(NSNumber*)self.refresh_info[@"stride_end"]intValue]+returned_count);
                        
                        self.refresh_info = @{ @"place_holder_date" : newPlaceHolderDate,
                                               @"stride_start" : newStrideStart,
                                               @"stride_end" : newStrideEnd};
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.refreshControl endRefreshing];
                            if (returned_count){
                                //  Update strides for the next time we append to the bottom
                                NSMutableArray * olderPosts = self.PostsIDS;
                                self.PostsIDS = [NSMutableArray arrayWithArray:new_posts];
                                [self.PostsIDS addObjectsFromArray:olderPosts];
                                
                                [self.collectionView reloadData];
                            }
                        });
                        
                    }
                    else{
                        NSLog(@"Collection view error: %@", results.msg);
                    }
                }];
}

@end
