//
//  AppDelegate.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/27/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "AppDelegate.h"
#import "MapView.h"
//#import "PostviewController.h"
#import "UsersPostsVC.h"
#import "LoginVC.h"
#import "GeoShoutApi.h"
#import "PostsDisplay.h"
#import "ProfileVC.h"
#import "MenuViewController.h"
#import <Parse/Parse.h>
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>

#define TOP_BAR_OFFSET  76.0

@interface AppDelegate ()<ShoutMenuViewDelegate>

@property (strong, nonatomic) MenuViewController *menu;

@end

BOOL isMenuShowing;
CGRect tmpFrame;
UIView *tmpView;

//  Global user ID
long GEO_LOGGED_USER;
dispatch_queue_t MEDIA_DISPATCH;
dispatch_queue_t PROCESSING_DISPATCH;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"VDOBmfsKD6NZAsIkjGMQM9hAS8xYt3eTqgqJEaki"
                  clientKey:@"JqPY9W3hPx8zcOzmVuC4nuiODjStADAFRSyXiEQo"];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionUSEast1
                                                          identityPoolId:@"us-east-1:041f3f66-f7de-406c-8b6b-e7c3cb9e1367"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.topApplicationBar = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 76)];
    self.topApplicationBar.delegate = self;
    
    float toolbarHeight = self.topApplicationBar.frame.size.height;
    
    MapView *mapVC = [[MapView alloc]initWithNibName:@"MapView" bundle:[NSBundle mainBundle]];
    mapVC.title = @"Map";
    [mapVC.view setFrame:CGRectMake(0, toolbarHeight, self.window.frame.size.width, self.window.frame.size.height-toolbarHeight)];
    
    UsersPostsVC *postVC = [[UsersPostsVC alloc]initWithNibName:@"UsersPostsVC" bundle:[NSBundle mainBundle]];
    postVC.title = @"Shouts";
    [postVC.view setFrame:CGRectMake(0, toolbarHeight, self.window.frame.size.width, self.window.frame.size.height-toolbarHeight)];
    NSArray *myControllers = [[NSArray alloc]initWithObjects:postVC,mapVC, nil];
    
    self.tabBar = [[UITabBarController alloc]init];
    [self.tabBar setViewControllers:myControllers];
    [self.window setRootViewController:self.tabBar];
    [self.window.rootViewController.view addSubview:self.topApplicationBar];
    [self.window.rootViewController.view bringSubviewToFront:self.topApplicationBar];

    [self.window makeKeyAndVisible];
    
    [self verify_login];
    [PostsDisplay initRectSizesForSize:self.window.frame.size withCellSpace:10];
    
    MEDIA_DISPATCH = dispatch_queue_create("MediaQueue", 0);
    PROCESSING_DISPATCH = dispatch_queue_create("ProcessingQueue", 0);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark - TopBarDelegate

-(void)pressSettingsButton:(id)sender
{
    //self.menu.tblView.frame = [Utils changeSize:self.menu.tblView resizeWidth:self.menu.view.frame.size.width resizeHeight:(45.0 * 5)];
    if (!self.menu)
    {
        tmpView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        [tmpView setBackgroundColor: [UIColor whiteColor]];
        tmpView.alpha = 0.1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissMenu)];
        [tmpView addGestureRecognizer:tap];
        self.menu = [[MenuViewController alloc]init];
        self.menu.delegate = self;
        isMenuShowing = NO;
        [self.menu.view setFrame:CGRectMake([Utils screenWidth] - 205, 74, 200, 0)];
        [self.window.rootViewController.view addSubview:tmpView];
        [self.window.rootViewController.view addSubview:self.menu.view];
    }
    
    float positionMenuY = (TOP_BAR_OFFSET-2);
    float positionMenuX = ([Utils screenWidth] - 205);
    if (!isMenuShowing)
    {
           tmpFrame = CGRectMake(positionMenuX,positionMenuY,200.0,(45*5));

        [self.menu.view setHidden:NO];
        self.menu.view.frame =CGRectMake(positionMenuX, positionMenuY, self.menu.view.frame.size.width, 0);
        [UIView animateWithDuration:0.25 animations:^{
            self.menu.view.frame = CGRectMake(positionMenuX, positionMenuY, self.menu.view.frame.size.width, tmpFrame.size.height);
        }];
        isMenuShowing = YES;
    }
    else
    {
        [self forceHide];
    }

}

-(void)pressSearchButton:(id)sender
{
    
}
#pragma mark - CustomMethods

- (void)forceHide
{
    isMenuShowing = NO;
    float positionMenuX = ([Utils screenWidth] - 205);
    float positionMenuY = (TOP_BAR_OFFSET-2);
    [UIView animateWithDuration:0.25 animations:^{
        self.menu.view.frame = CGRectMake(positionMenuX, positionMenuY, tmpFrame.size.width, 0.0);
    }];
    [self refreshTabs];
    self.menu = nil;
}

-(void)dissmissMenu
{
    NSLog(@"TapDetected");
    if (isMenuShowing) {
        [self forceHide];
        [tmpView removeFromSuperview];
        tmpView = nil;
    }
}

-(void)refreshTabs{
    [self.menu refreshPostsForTab];
}
-(void)closeMenu{
    [self dissmissMenu];
}

#pragma mark - User credentials
-(void)verify_login{
    if (!GEO_LOGGED_USER){
        [self presentLoginScreen];
    }
}

-(void) presentLoginScreen {
    LoginVC *userLogin = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:[NSBundle mainBundle]];
    [userLogin.view setFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    
    [self.window.rootViewController presentViewController:userLogin animated:true completion:nil];
}

#pragma mark - Menu delegate methods
-(void)didLaunchProfileSettings{
    ProfileVC *profileVC = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:[NSBundle mainBundle]];
    
    [self.window.rootViewController presentViewController:profileVC animated:YES completion:nil];
}

@end
