//
//  VideoPostViewController.m
//  shoutAPP
//
//  Created by MAC01 on 6/1/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoPostViewController.h"
#import "FakeVideoViewController.h"

@interface VideoPostViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FakeVideoDelegate>

@property UIImagePickerController *picker;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSString *videoUrl;
- (IBAction)doVideoFolder:(id)sender;

- (IBAction)doTakeVideo:(id)sender;

@end

@implementation VideoPostViewController

#pragma mark - View methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

-(void)showVideoWithURL:(NSURL *)url {
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: url];
    self.player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60);
    self.player.view.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.player.view];
    [self.player play];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)showFileSystemPicker{
    NSLog(@"PhotoLibrary Functions.");
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        self.picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        [self presentViewController:self.picker animated:YES completion:NULL];
    } else {
        NSLog(@"No device available for getting videos from dir");
    }
}

#pragma mark - Action methods
- (IBAction)doVideoFolder:(id)sender
{
    self.videoUrl = @"";
    [self.player stop];
    
    // TODO: For production
    [self showFileSystemPicker];
    
    // TODO: For testing without device
    //[self showFakeFileSystemPicker];
}

- (IBAction)doTakeVideo:(id)sender
{
    self.videoUrl = @"";
    [self.player stop];
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        self.picker.allowsEditing = NO;
        self.picker.showsCameraControls = NO;
        self.picker.cameraViewTransform = CGAffineTransformIdentity;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
            self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        else
            self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:self.picker animated:YES completion:NULL];
        
        [self.picker showsCameraControls];
        
         // TODO: Choose controls
        [self.picker startVideoCapture];
    } else {
        NSLog(@"Not device available for taking video");
    }
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnUse:(id)sender {
    [self.player stop];
    [self.player.view removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didSelectVideo:self.videoUrl];
    }];
}

#pragma mark - Image picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    
    NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    NSString *pathToVideo = [videoURL path];
    BOOL okToSaveVideo = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToVideo);
    if (okToSaveVideo) {
        UISaveVideoAtPathToSavedPhotosAlbum(pathToVideo, self, nil, NULL);
        
        [self showVideoWithURL:[NSURL URLWithString:pathToVideo]];
        
        self.videoUrl = pathToVideo;
    } else {
        //[self video:pathToVideo didFinishSavingWithError:nil contextInfo:NULL];
    }
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Fake Video Picker Methods
-(void)showFakeFileSystemPicker{
    FakeVideoViewController *pickerView = [[FakeVideoViewController alloc] initWithNibName:@"FakeVideoViewController" bundle:[NSBundle mainBundle]];
    pickerView.delegate = self;
    
    [self presentViewController:pickerView animated:YES completion:nil];
}

-(void)didFinishPickingFakeMediaWithInfo:(NSString *)info{
    [self showVideoWithURL:[NSURL fileURLWithPath:info]];
    
    self.videoUrl = info;
}

-(void)fakePickerControllerDidCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
