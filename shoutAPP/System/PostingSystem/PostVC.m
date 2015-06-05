//
//  PostVC.m
//  shoutAPP
//
//  Created by Mac on 5/30/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "PostVC.h"
#import "RequestResult.h"
#import "GeoShoutApi.h"
#import "VideoPostViewController.h"
#import <Parse/Parse.h>
static const int POST_TYPE_TEXT = 1;
static const int POST_TYPE_IMAGE = 2;
static const int POST_TYPE_AUDIO = 3;
static const int POST_TYPE_VIDEO = 4;
static const int POST_TYPE_URL = 5;

@interface PostVC () <UITextViewDelegate, PicturePostDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtPostContent;
@property (weak, nonatomic) IBOutlet UIButton *btnPostOut;
- (IBAction)actPost:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indPosting;

@property int postType;

// View to show preview image before posting
@property UIImageView *imageView;
@property NSObject * Media;

@end

@implementation PostVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtPostContent.delegate = self;
    
    self.postType = POST_TYPE_TEXT;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self sizeViewFor:self.txtPostContent];
    
    // Get user location
    //[self startStandarUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -TextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 1)
    {
        textView.text = @"";
        textView.tag = 0;
    }
    [self sizeViewFor:textView];

}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"Type text or paste url to share.";
        textView.tag = 1;
        
    }
    [textView resignFirstResponder];
    [self sizeViewFor:textView];

}
- (void)textViewDidChange:(UITextView *)textView {
    [self sizeViewFor:textView];
}

#pragma mark CustomMethods

-(void) sizeViewFor:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}


- (IBAction)actPost:(id)sender
{
    self.btnPostOut.hidden = true;
    [self.txtPostContent setUserInteractionEnabled:false];
    [self.indPosting startAnimating];
    
    switch (self.postType) {
        case POST_TYPE_TEXT:
            [self postText];
            break;
        case POST_TYPE_IMAGE:{
            [self postPicture:(UIImage*)self.Media];
        }
    }
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
    
    // Send push notification to query
    [PFPush sendPushMessageToQueryInBackground:pushQuery
                                   withMessage:@"Shout Added!"];

}

-(void)postText {
    CGPoint currentLocation = [UserLocation userLocation];
    // After determining if text is url or not, we either post text or post as a url
    [Posts postText:[self.txtPostContent text]
            forUser:GEO_LOGGED_USER
      withLattitude:currentLocation.x
      withLongitude:currentLocation.y
       onCompletion:^(RequestResult *result) {
        if (result.success){
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            self.btnPostOut.hidden = false;
            [self.txtPostContent setUserInteractionEnabled:true];
            [self.indPosting stopAnimating];
            
            NSLog(@"Posting Error: %@", result.msg);
        }
    }];
}

-(void) postPicture:(UIImage*)img {
    CGPoint currentLocation = [UserLocation userLocation];
    NSData *content = UIImageJPEGRepresentation(img, 0.75);
    
    [Posts postMedia:content
             forUser:GEO_LOGGED_USER
                 lat:currentLocation.x
                 lng:currentLocation.y
     withContentType:POST_TYPE_IMAGE
   contentTypeString:@"image/jpg"
          contentExt:@"jpg"
        onCompletion:^(RequestResult *result) {
            if (result.success){
                [self dismissViewControllerAnimated:true completion:nil];
            }
            else {
                self.btnPostOut.hidden = false;
                [self.txtPostContent setUserInteractionEnabled:true];
                [self.indPosting stopAnimating];
                
                NSLog(@"Posting Error: %@", result.msg);
            }
        }];
}

- (IBAction)doPostButtons:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
        {
            PicturePostViewController *pictureVC = [[PicturePostViewController alloc] initWithNibName:@"PicturePostViewController" bundle:[NSBundle mainBundle]];
            [pictureVC.view setFrame:[[UIScreen mainScreen] bounds]];
            
            pictureVC.delegate = self;
            
            [self presentViewController:pictureVC animated:true completion:nil];
        }
            break;
        case 1:
        {
            //AudioPost
            
//            PicturePostViewController *pictureVC = [[PicturePostViewController alloc] initWithNibName:@"PicturePostViewController" bundle:[NSBundle mainBundle]];
//            [pictureVC.view setFrame:[[UIScreen mainScreen] bounds]];
//            
//            [self presentViewController:pictureVC animated:true completion:nil];
        }
            break;
        case 2:
        {
            //Video
            
            VideoPostViewController *videoVC = [[VideoPostViewController alloc] initWithNibName:@"VideoPostViewController" bundle:[NSBundle mainBundle]];
            [videoVC.view setFrame:[[UIScreen mainScreen] bounds]];
            
            [self presentViewController:videoVC animated:true completion:nil];
        }
            break;

        default:
            break;
    
    }
    
    
}

#pragma mark - image selection delegate methods
-(void)didSelectImage:(UIImage*)image{
    self.Media = image;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.extraContentContainer.frame.size.width, self.extraContentContainer.frame.size.height)];
    self.imageView.image = image;
    [self.extraContentContainer addSubview:self.imageView];
    
    self.postType = POST_TYPE_IMAGE;
}
@end
