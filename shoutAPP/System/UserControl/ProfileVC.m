//
//  ProfileVC.m
//  shoutAPP
//
//  Created by MAC01 on 6/2/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "ProfileVC.h"
#import "GeoShoutApi.h"
#import "Utils.h"
#import "PicturePostViewController.h"

@interface ProfileVC ()<UITextFieldDelegate, PicturePostDelegate>

#pragma mark - UI outlets
@property (weak, nonatomic) IBOutlet UITextField *tfDisplayName;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *tfProfileName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *tfDisplayStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

#pragma mark - Properties
// We can check if there is any change in the profile to enable update button
@property (weak, nonatomic) NSDictionary *originalInfo;

@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIImage *image;

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Only date needed in the date picker
    self.dobDatePicker.datePickerMode = UIDatePickerModeDate;
    // Set current date as maximum date that can be choosed
    [self.dobDatePicker setMaximumDate:[NSDate date]];
    
    [self displayUserInfo];
}

-(void)displayUserInfo{
    [self.activityIndicator startAnimating];
    
    // Get current user info
    [Users getProfileWithUserId:GEO_LOGGED_USER onCompletion:^(RequestResult *result) {
        // Run this in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.success) {
                if ([result.extra objectForKey:@"display_name"] != nil) {
                    self.tfDisplayName.text = [result.extra objectForKey:@"display_name"];
                }
                if ([result.extra objectForKey:@"profile_name"] != nil) {
                    self.tfProfileName.text = [result.extra objectForKey:@"profile_name"];
                }
                if ([result.extra objectForKey:@"display_status"] != nil) {
                    self.tfDisplayStatus.text = [result.extra objectForKey:@"display_status"];
                }
                
                NSString *imgUrl = [result.extra objectForKey:@"display_img"];
                if (![imgUrl isEqual:[NSNull null]]) {
                    dispatch_async(MEDIA_DISPATCH, ^{
                        self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.profileImageView.image = self.image;
                        });
                    });
                }
                
                NSString *dateStr = [result.extra objectForKey:@"dob"];
                if (![dateStr isEqual:[NSNull null]]) {
                    NSDate *date = [Utils getDateWithString:dateStr withFormat:@"yyyy-MM-dd 00:00:00"];
                    
                    [self.dobDatePicker setDate:date];
                }
                
                self.originalInfo = result.extra;
            } else {
                // TODO: Show nice error :P to user
                NSLog(@"Error retrieving profile info");
            }
            
            [self.activityIndicator stopAnimating];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return true;
}

#pragma mark - Actions
- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Updates the all info but the image
- (IBAction)btnUpdate:(id)sender {
    [self.activityIndicator startAnimating];
    
    Profile *profile = [Profile new];
    profile.profileName = self.tfProfileName.text;
    profile.displayName = self.tfDisplayName.text;
    profile.displayStatus = self.tfDisplayStatus.text;
    profile.DOB = self.dobDatePicker.date;
    
    [Users updateUserWithProfile:profile withUserId:GEO_LOGGED_USER onCompletion:^(RequestResult *result) {
        NSLog(@"Result status: %i", result.success);
        
        [self postPicture:self.image];
    }];
}

// Show image picker view controller
- (IBAction)imageTap:(id)sender {
    PicturePostViewController *pictureVC = [[PicturePostViewController alloc] initWithNibName:@"PicturePostViewController" bundle:[NSBundle mainBundle]];
    [pictureVC.view setFrame:[[UIScreen mainScreen] bounds]];
    
    pictureVC.delegate = self;
    
    [self presentViewController:pictureVC animated:true completion:nil];
}

-(void) postPicture:(UIImage*)img {
    NSData *content = UIImageJPEGRepresentation(img, 0.75);
    
    [Posts postMedia:content
             forUser:GEO_LOGGED_USER
     withContentType:2
   contentTypeString:@"image/jpg"
          contentExt:@"jpg"
        onCompletion:^(RequestResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.success){
                    // TODO: Show success message/icon
                }
                else {
                    // TODO: Show error message/icon
                    
                    NSLog(@"Posting Error: %@", result.msg);
                }
                // TODO: Enable controls
                
                [self.activityIndicator stopAnimating];
            });
        }];
}

#pragma mark - image selection delegate methods
-(void)didSelectImage:(UIImage*)image{
    self.image = image;
    
    self.profileImageView.image = image;
}

@end
