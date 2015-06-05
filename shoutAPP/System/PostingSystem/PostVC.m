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
#import "AudioPostViewController.h"
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


static const int POST_TYPE_TEXT = 1;
static const int POST_TYPE_IMAGE = 2;
static const int POST_TYPE_VIDEO = 3;
static const int POST_TYPE_AUDIO = 4;
static const int POST_TYPE_URL = 5;

@interface PostVC () <UITextViewDelegate, PicturePostDelegate, VideoPostDelegate, AudioPostDelegate>

#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UITextView *txtPostContent;
@property (weak, nonatomic) IBOutlet UIButton *btnPostOut;
- (IBAction)actPost:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indPosting;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveMedia;

@property int postType;

// Preview image before posting
@property UIImageView *imageView;
@property NSObject * media;

// Preview video before posting
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSString *videoUrl;

// Preview audio before posting
@property (nonatomic, strong) AVPlayerLayer *myPlayerLayer;
@property (nonatomic, strong) AVPlayer *myavp;
@property (nonatomic, strong) NSString *audioUrl;

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
        case POST_TYPE_IMAGE:
            [self postPicture:(UIImage*)self.media];
            break;
        case POST_TYPE_VIDEO:
            [self postVideo:self.videoUrl];
            break;
        case POST_TYPE_AUDIO: {
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *path = [bundle pathForResource:self.audioUrl ofType:@"mp3"];
            [self postAudio:path];
            
            break;
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

- (NSData *)generatePostDataForData:(NSData *)uploadData
{
    // Generate the post header:
    NSString *post = [NSString stringWithCString:"--AaB03x\r\nContent-Disposition: form-data; name=\"upload[file]\"; filename=\"somefile\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" encoding:NSASCIIStringEncoding];
    
    // Get the post header int ASCII format:
    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // Generate the mutable data variable:
    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
    [postData setData:postHeaderData];
    
    // Add the image:
    [postData appendData: uploadData];
    
    // Add the closing boundry:
    [postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    // Return the post data:
    return postData;
}

-(void) postVideo:(NSString*)videoPath {
    CGPoint currentLocation = [UserLocation userLocation];
    
    NSData *content = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoPath]];
    
    [Posts postMedia:content
             forUser:GEO_LOGGED_USER
                 lat:currentLocation.x
                 lng:currentLocation.y
     withContentType:POST_TYPE_VIDEO
   contentTypeString:@"video/quicktime"
          contentExt:@"mov"
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

-(void) postAudio:(NSString*)audioPath {
    CGPoint currentLocation = [UserLocation userLocation];
    
    NSData *content = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:audioPath]];
    
    [Posts postMedia:content
             forUser:GEO_LOGGED_USER
                 lat:currentLocation.x
                 lng:currentLocation.y
     withContentType:POST_TYPE_VIDEO
   contentTypeString:@"audio/mpeg3"
          contentExt:@"mp3"
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
    
    [self removeCurrentMedia];
    
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
            AudioPostViewController *audioVC = [[AudioPostViewController alloc] initWithNibName:@"AudioPostViewController" bundle:[NSBundle mainBundle]];
            [audioVC.view setFrame:[[UIScreen mainScreen] bounds]];
            
            audioVC.delegate = self;
            
            [self presentViewController:audioVC animated:true completion:nil];
        }
            break;
        case 2:
        {
            VideoPostViewController *videoVC = [[VideoPostViewController alloc] initWithNibName:@"VideoPostViewController" bundle:[NSBundle mainBundle]];
            [videoVC.view setFrame:[[UIScreen mainScreen] bounds]];
            
            videoVC.delegate = self;
            
            [self presentViewController:videoVC animated:true completion:nil];
        }
            break;

        default:
            break;
    }
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)removeMediaButton:(id)sender {
    [self removeCurrentMedia];
}

#pragma mark - Image selection delegate methods
-(void)didSelectImage:(UIImage*)image{
    self.media = image;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.extraContentContainer.frame.size.width, self.extraContentContainer.frame.size.height)];
    self.imageView.image = image;
    
    // Set mode to aspect fit
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.extraContentContainer addSubview:self.imageView];
    
    self.postType = POST_TYPE_IMAGE;
    
    [self.txtPostContent setEditable:NO];
    [self.btnRemoveMedia setHidden:NO];
}

-(void) didSelectVideo:(NSString *)videoUrl{
    NSLog(@"video selected: %@ ", videoUrl);
    
    self.videoUrl = videoUrl;
    
    //[self postVideo:videoUrl];
    
    self.postType = POST_TYPE_VIDEO;
    
    [self.txtPostContent setEditable:NO];
    [self.btnRemoveMedia setHidden:NO];
    
    [self showVideoWithURL:[NSURL fileURLWithPath:videoUrl]];
}

-(void)didSelectAudio:(NSString *)audioUrl{
    [self playAudioWithString:audioUrl];
    
    self.postType = POST_TYPE_AUDIO;
    
    self.audioUrl = audioUrl;
}

#pragma mark - Custom methods
-(void)showVideoWithURL:(NSURL *)url {
    if (self.player == nil) {
        self.player = [[MPMoviePlayerController alloc] initWithContentURL: url];
        self.player.view.frame = CGRectMake(0, 0, self.extraContentContainer.frame.size.width, self.extraContentContainer.frame.size.height);
        self.player.view.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [self.extraContentContainer addSubview:self.player.view];
    [self.player play];
    
    [self.txtPostContent setEditable:NO];
    [self.btnRemoveMedia setHidden:NO];
}

-(void)playAudioWithString:(NSString *)urlStr {
    NSURL *url = [[NSBundle mainBundle] URLForResource:urlStr withExtension:@"mp3"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.myavp = [AVPlayer playerWithPlayerItem:playerItem];
    self.myPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myavp];
    self.myPlayerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size
                                          .height);
    [self.view.layer addSublayer:self.myPlayerLayer];
    
    [self.myavp play];
}

-(void)removeCurrentMedia{
    switch (self.postType) {
        case POST_TYPE_IMAGE:
            [self.imageView removeFromSuperview];
            
            // TODO: Dismiss media
            self.media = nil;
            break;
        case POST_TYPE_AUDIO:
            [self.myavp pause];
            
            self.audioUrl = @"";
            break;
        case POST_TYPE_VIDEO:
            [self.player stop];
            [self.player.view removeFromSuperview];
            
            self.videoUrl = @"";
            break;
        default:
            break;
    }
    
    [self.txtPostContent setEditable:YES];
    [self.btnRemoveMedia setHidden:YES];
}
@end
